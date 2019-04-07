import requests
import csv
import os

response = requests.get('https://docs.google.com/spreadsheet/ccc?key=1rhBQTt5oVPLroZRGhvyMz-OPA4Pmn0lJI50SvAEbL9s&output=csv')
assert response.status_code == 200, 'Wrong status code'
states_csv = open('tmp.csv','wb')
states_csv.write(response.content)
states_csv.close()

def stoi(str):
    return int(str) if str != '' else 0

mem_file = open('cs_bits.mem', 'w')
def_file = open('control_signal_defs.v', 'w')

with open('tmp.csv') as csvfile:
    csvreader = csv.reader(csvfile)
    num_signals = int(next(csvreader)[2])
    bit_positions = [x for x in next(csvreader)[2:num_signals+2]]
    signal_widths = [int(x) for x in next(csvreader)[2:num_signals+2]]
    signal_names = [x for x in next(csvreader)[2:num_signals+2]]
    next(csvreader)
    state = 0
    for i in range(num_signals):
        def_file.write('`define CTRL_ST_{name} control_signals[{pos}]\n'.format(name=signal_names[i], pos=bit_positions[i]))
    for row in csvreader:
        for i in range(num_signals):
            signal_width = signal_widths[i]
            signal_data = stoi(row[2+i])
            mem_file.write('{data:0{width}b}'.format(width=signal_width, data=signal_data))
        mem_file.write('\n')
        state = state + 1

mem_file.close()
def_file.close()
os.remove(csvfile.name);
