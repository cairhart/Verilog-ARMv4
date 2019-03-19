// 32 bit tri-state buffer used for driving 32-bit busses

module tsb_32_bit (
	input [31:0] in ,
	input gate,
	output [31:0] out
);

assign out = gate ? in : {32{1'bz}};

endmodule
