--Who is the senior most employee based on job title?

Select  Top (1) *
from employee
Order by levels desc


--Which countries have the most Invoices?

Select Count(*) as C, billing_country
From dbo.invoice
Group by billing_country
order by C desc

-- What are top 3 values of total invoice?
select  Top(3) total
from invoice
order by total desc

/* Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
 select Top(1) Sum(total) as invoiced_amount, billing_city 
 from invoice
 group by billing_city
 order by invoiced_amount desc

 /* Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select Top(1) cust.customer_id,cust.first_name, cust.last_name,sum(inv.total) as total
from customer as cust
Join invoice as inv ON cust.customer_id=inv.customer_id
group by cust.customer_id,cust.first_name,cust.last_name
order by total desc

/*Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A*/

select Distinct email,first_name,last_name 
from customer
join invoice ON invoice.customer_id=customer.customer_id
join invoice_line On invoice_line.invoice_id=invoice.invoice_id
where track_id IN(
    Select track_id from track
    Join genre on genre.genre_id=track.genre_id
    where genre.name Like 'Rock'
)
Order by email


/*Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands*/select Top(10) artist.artist_id,artist.name,Count(artist.artist_id) as Total_Songsfrom trackJoin album on track.album_id=album.album_idJoin artist on album.artist_id=artist.artist_idJoin genre on track.genre_id=genre.genre_idwhere genre.name Like 'Rock'Group by artist.artist_id, artist.nameorder by Total_Songs desc/*Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first*/select name, millisecondsfrom trackwhere milliseconds>(      Select Avg(milliseconds) as average_length	  from track)order by milliseconds desc

