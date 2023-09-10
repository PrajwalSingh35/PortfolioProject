import random

MAX_LINES= 3
MAX_BET= 500
MIN_BET= 10

ROWS= 3
COLS= 3

symbol_count = {
    "A":2,
    "B":4,
    "C":6,
    "D":8

    }

symbol_value = {
    "A":5,
    "B":4,
    "C":3,
    "D":2

    }

def check_winning(columns, lines, bet, values):
    winnings=0
    winning_lines=[]
    for line in range(lines):
        symbol=columns[0][line]
        for column in columns:
            symbol_check=column[line]
            if symbol != symbol_check:
                break
        else:
            winnings += values[symbol] * bet
            winning_lines.append(line+1)

    return winnings, winning_lines

def get_slot_machine_spin(rows, cols, symbols):
    all_symbols=[]
    for symbol, symbol_count in symbols.items():
        for _ in range(symbol_count):
            all_symbols.append(symbol)

    columns=[]
    for _ in range(cols):
        column=[]
        current_symbol= all_symbols[:]
        for _ in range(rows):
            value=random.choice(current_symbol)
            current_symbol.remove(value)
            column.append(value)

        columns.append(column)

    return columns

def print_slot_machine(columns):
    for rows in range(len(columns[0])):
        for i, column in enumerate(columns):
            if i != len(columns) - 1:
                print(column[rows], end=" | ")
            else:
                print(column[rows], end="")

        print()
    

def deposit():
    while True:
        amount=input("What would you like to deposit? $ ")
        if amount.isdigit():
            amount=int(amount)
            if amount>0:
                break;
            else:
                print("Please enter amount greater than 0.")
        else:
            print("Please enter the number.")
    return amount

def get_lines():
    while True:
        lines=input(f"Enter the number of lines you want to bet on (1 - {MAX_LINES}) : ")
        if lines.isdigit():
            lines=int(lines)
            if 0< lines <=MAX_LINES:
                break;
            else:
                print("Please enter the lines within the valid range.")
        else:
            print("Please enter the number.")
    return lines

def get_bet():
    while True:
        amount=input("How much amount would you like to bet? $ ")
        if amount.isdigit():
            amount=int(amount)
            if MIN_BET<= amount <=MAX_BET:
                break;
            else:
                print(f"Amount must be between ${MIN_BET} - ${MAX_BET} ")
        else:
            print("Please enter the number.")
    return amount

def game(balance):
    bet_lines= get_lines()
    while True:
        bet_amount= get_bet()
        total_bet= bet_amount * bet_lines
        if total_bet > balance:
            print(f"You don't have enough balance. You current balance is ${balance}")
        else:
            break
    print(f"You are betting ${bet_amount} on {bet_lines} lines. Total bet amount is ${total_bet}")

    slots= get_slot_machine_spin(ROWS, COLS, symbol_count)

    print_slot_machine(slots)

    winnings , winning_lines =check_winning(slots, bet_lines, bet_amount, symbol_value)

    print(f"You won ${winnings}.")
    print(f"You won on lines:", *winning_lines)

    return winnings - total_bet

def main():
    balance= deposit()
    while True:
        print(f"Current balance is ${balance}")
        spin= input("Press enter to play (q to quit)")
        if spin == 'q':
            break

        balance +=game(balance)

    
    print(f"You left with amount ${balance}")
        
        
    
    
main()
