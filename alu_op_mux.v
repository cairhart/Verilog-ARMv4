
module alu_operation_mux(
	input [1:0] alu_op_mux,
	input [3:0] ir_op,
	input [3:0] cs_op,
	input u,
	output [3:0] alu_operation 

);

wire [3:0] alu_op_1;
wire [3:0] alu_op_0;
assign alu_op_1 = {4{alu_op_mux[1]}};
assign alu_op_0 = {4{alu_op_mux[0]}};
wire [3:0] u_x = {4{u}};

wire [3:0] alu_operation;


assign alu_operation = (((~alu_op_1 & ~ alu_op_0) & ir_op ) | ( (~alu_op_1 & alu_op_0) & cs_op) | ((alu_op_1) & ((u_x & 4'd2) | (~u_x & 4'd4)  ) ) );


endmodule

