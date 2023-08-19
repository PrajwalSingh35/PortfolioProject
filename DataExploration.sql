select *
from CovidDeaths$
order by 3,4

--Showing total death per popuation by continent
select continent, Max(cast(total_deaths as int)) as TotalDeaths
From CovidDeaths$
where continent is not null
Group by continent
order by TotalDeaths

--Showing total death per popuation by continent
select location, Max(cast(total_deaths as int)) as TotalDeaths
From CovidDeaths$
where continent is not null
Group by location
order by TotalDeaths desc

-- Death percentage per total cases reported for india
select location, date, total_deaths, total_cases, (total_deaths/total_cases)* 100 as DeathPercentage
From CovidDeaths$
where location = 'India'
order by DeathPercentage desc

-- Global Data
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercent
From CovidDeaths$
--where location = 'India'
where continent is not null
--group by date
order by 1,2

-- Location per population which is vaccinated
select dea.continent,dea.location,dea.date,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.date) as PopulationVaccinated
From CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
--where location = 'India'
where dea.continent is not null
--group by date
order by 2,3

-- USing CTE to identify percentage
With PopvsVac (Continent, Location, Date,Population, Vaccination, PopulationVaccinated)
As
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by dea.location order by dea.location,dea.date) as PopulationVaccinated
From CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
--where location = 'India'
where dea.continent is not null
--group by date
--order by 2,3
)
Select *, (PopulationVaccinated/Population)*100
from PopvsVac


-- Using Temp Table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PopulationVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as PopulationVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (PopulationVaccinated/Population)*100 as VaccinationPercent
From #PercentPopulationVaccinated
 

 
-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
