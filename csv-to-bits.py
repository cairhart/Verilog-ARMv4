import csv

def stoi(str):
    return int(str) if str != '' else 0

f = open('cs_bits.mem', 'w')

with open('states.csv') as csvfile:
    csvreader = csv.reader(csvfile)
    next(csvreader)
    next(csvreader)
    for row in csvreader:
        state_num = stoi(row[0])
        EVCOND = stoi(row[3])
        J = stoi(row[4])
        MOD = stoi(row[5])
        DEC = stoi(row[6])
        f.write('{:054b}{:1b}{:07b}{:02b}{:1b}\n'.format(0, EVCOND, J, MOD, DEC))

f.close()