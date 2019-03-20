module file_to_ram;
integer               data_file    ; // file handler
integer               scan_file    ; // file handler
logic   signed [31:0] captured_data;
logic   signed [31:0] captured_data0;
logic   signed [31:0] captured_data1;
logic   signed [31:0] captured_data2;
logic   signed [31:0] captured_data3;

reg clk = 0;
reg cs = 1;
reg we = 1;
reg oe = 0;
reg [31:0] data_input;
wire [31:0] data_output;
reg finished = 0;
integer address = 3000;
`define NULL 0    
always #5 clk = !clk;


initial begin
  data_file = $fopen("example_asm.obj", "r");
	$display("file opened %d", data_file);
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
end

basic_ram ram(clk,
							address,
							data_output,
							data_input,
							cs,
							we,
							oe);

always @(posedge clk) begin
	 scan_file = $fscanf(data_file, "%c", captured_data0); 
	 scan_file = $fscanf(data_file, "%c", captured_data1); 
	 scan_file = $fscanf(data_file, "%c", captured_data2); 
	 scan_file = $fscanf(data_file, "%c", captured_data3); 
	 captured_data = (captured_data0 << 24) | 
	 								 (captured_data1 << 16) |
									 (captured_data2 << 8) 	|
									 (captured_data3);
	 if (!$feof(data_file)) begin
		 data_input = captured_data;
		 address = address + 1;
	 end
	 else
		 $finish;
end
endmodule
