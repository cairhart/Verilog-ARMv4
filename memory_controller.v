module mcu(
	input b,
	input h,
	input s,
	input [15:0] decode_families,
	input [31:0] data_from_mem,
  input ld_ir,
  input ld_mar_from_pc,
	
	output [1:0] data_size,
	output [31:0] data_to_cpu,

  // debugging signals
  output signed_data,
  output byte,
	output halfword,
  output word
);

wire [1:0] data_size;
wire [31:0] data_to_cpu;

wire word_ub, hw_sb, signed_data, byte, halfword, word;

wire [31:0] sext, zext;


assign hw_sb = decode_families[8] | decode_families[9];
assign word_ub = decode_families[10] | decode_families[11];
assign signed_data = (hw_sb & (~h | (h & s)));

assign byte = (word_ub & b) | (hw_sb & ~h);
assign halfword = (hw_sb & h);
assign word = (word_ub & ~b);

assign data_size = (ld_mar_from_pc | ld_ir) ? 2'b11 : { word, (halfword | word) }; //EDITED BY VICKIE

assign zext =   (data_size[1]) ? data_from_mem : 
                (data_size[0]) ? { 16'h0000, data_from_mem[15:0]} : 
                {24'h000000, data_from_mem[7:0]};

assign sext =   (data_size[1]) ? data_from_mem : 
                (data_size[0]) ? { {16{data_from_mem[15]}}, data_from_mem[15:0]} : 
                    { {24{data_from_mem[7]}}, data_from_mem[7:0]};
assign data_to_cpu = (signed_data) ? sext : zext;



endmodule 
