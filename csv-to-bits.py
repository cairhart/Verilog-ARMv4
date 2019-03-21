import requests
import csv

response = requests.get('https://docs.google.com/spreadsheet/ccc?key=1rhBQTt5oVPLroZRGhvyMz-OPA4Pmn0lJI50SvAEbL9s&output=csv')
assert response.status_code == 200, 'Wrong status code'
states_csv = open('states.csv','wb')
states_csv.write(response.content)
states_csv.close()

def stoi(str):
    return int(str) if str != '' else 0

f = open('cs_bits.mem', 'w')

with open('states.csv') as csvfile:
    csvreader = csv.reader(csvfile)
    next(csvreader)
    num_signals = int(next(csvreader)[2])
    signal_widths = [int(w) for w in next(csvreader)[2:num_signals+2]]
    next(csvreader)
    for row in csvreader:
        for i in range(num_signals):
            signal_width = signal_widths[i]
            signal_data = stoi(row[2+i])
            f.write('{data:0{width}b}'.format(width=signal_width, data=signal_data))
        f.write('\n')

f.close()
