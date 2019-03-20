module file_to_ram(
	input clk,
	input [31:0] data_output,
	output [31:0] address,
	output [31:0] data_input,
	output cs,
	output we,
	output oe,
	output finished

);
integer               data_file    ; // file handler
integer               scan_file    ; // file handler
logic   signed [31:0] captured_data;
logic   signed [31:0] captured_data0;
logic   signed [31:0] captured_data1;
logic   signed [31:0] captured_data2;
logic   signed [31:0] captured_data3;

reg cs = 1;
reg we;
reg oe;
reg [31:0] data_input;
reg [31:0] mdr;
wire [31:0] data_output;
reg finished;
integer address = 0;
`define NULL 0    


initial begin
  finished = 0;
  data_file = $fopen("example_asm.obj", "r");
	$display("file opened %d", data_file);
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
	while(!$feof(data_file)) begin
		scan_file = $fscanf(data_file, "%c", captured_data0); 
		scan_file = $fscanf(data_file, "%c", captured_data1); 
		scan_file = $fscanf(data_file, "%c", captured_data2); 
		scan_file = $fscanf(data_file, "%c", captured_data3); 
		captured_data = (captured_data0 << 24) | 
								 (captured_data1 << 16) |
								 (captured_data2 << 8) 	|
								 (captured_data3);
		we = 1;
		oe = 0;
		data_input = captured_data;
#100
		address = address + 1;
	end
	we = 0;
	oe = 1;
	address = 0;
#100
	mdr = data_output;
	$display("mdr for the last address is %x\n", mdr);
	address = 1;
#100
	mdr = data_output;
	$display("mdr for the last address is %x\n", mdr);
	address = 2;
#100
	mdr = data_output;
	$display("mdr for the last address is %x\n", mdr);
	
	
    



	finished = 1;
end

endmodule
