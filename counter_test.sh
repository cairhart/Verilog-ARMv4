iverilog -ocounter_test.vvp counter_test.v counter.v
vvp -n counter_test.vvp > test_files/counter_test.txt
diff test_files/counter_test.txt test_files/counter_test_correct.txt --brief
