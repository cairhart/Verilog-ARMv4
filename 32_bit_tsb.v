// 32 bit tri-state buffer used for driving 32-bit busses

module 32_bit_tsb(
	input [31:0] 	in;
	input 			gate;
	output [31:0]	out;
)

assign out = enable ? in : {32{1'bz}};

endmodule
