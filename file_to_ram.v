integer               data_file    ; // file handler
integer               scan_file    ; // file handler
logic   signed [31:0] captured_data;

reg clk = 0;
reg address [31:0];
`define NULL 0    

initial begin
	always #5 clk = !clk;
  data_file = $fopen("sample_asm.obj", "r");
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
end

always @(posedge clk) begin
  scan_file = $fscanf(data_file, "%d\n", captured_data); 
  if (!$feof(data_file)) begin
		basic_ram ram(clk,address,captured_data,1,1,0);
  end
end
