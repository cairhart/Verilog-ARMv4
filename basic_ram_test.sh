rm test_files/basic_ram_test.txt
rm basic_ram_test.vvp
iverilog -obasic_ram_test.vvp file_to_ram.v basic_ram.v

vvp -n basic_ram_test.vvp > test_files/basic_ram_test.txt
diff test_files/basic_ram_test.txt test_files/ram_test_correct.txt --brief
