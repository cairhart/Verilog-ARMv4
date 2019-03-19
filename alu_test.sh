iverilog -oalu_test.vvp alu_test.v alu.v
vvp -n alu_test.vvp > test_files/alu_test.txt
diff test_files/alu_test.txt test_files/alu_test_correct.txt --brief
