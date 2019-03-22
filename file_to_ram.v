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
reg we;
reg oe;
reg [31:0] data_input;
reg [31:0] mdr;
wire [31:0] data_output;
wire mem_done;
reg finished = 0;
integer address = 0;
`define NULL 0    
always #5 clk = !clk;


initial begin
  data_file = $fopen("example_asm.obj", "r");
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
end

basic_ram ram(clk,
							address,
							data_output,
							data_input,
							mem_done,
							cs,
							we,
							oe);

always @(negedge clk) begin
	 scan_file = $fscanf(data_file, "%c", captured_data0); 
	 scan_file = $fscanf(data_file, "%c", captured_data1); 
	 scan_file = $fscanf(data_file, "%c", captured_data2); 
	 scan_file = $fscanf(data_file, "%c", captured_data3); 
	 captured_data = (captured_data3 << 24) | 
	 								 (captured_data2 << 16) |
									 (captured_data1 << 8) 	|
									 (captured_data0);
	 if (!$feof(data_file)) begin
		 we = 1;
		 oe = 0;
		 data_input = captured_data;
#100
		 address = address + 1;
	 end
	 else
	 begin
		 $finish;
	 end
end
endmodule
