rm main_test.vvp
iverilog -omain_test.vvp top_module_test.v

vvp -n main_test.vvp 
