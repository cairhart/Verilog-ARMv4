`include "mar.v"



module mar_test;

reg ld, mux1, mux2;
reg [31:0] pc, alu;
wire [31:0] address;


mar MAR(
	.LATCH_MAR(ld),
	.MARMUX1(mux1),
	.MARMUX2(mux2),
	.PC(pc),
	.ALU_bus(alu),
	.address(address)
);



initial begin
	ld = 0;
	pc = 32'h1111;
	alu = 32'h2222;
	mux1 = 0;
	mux2 = 0;
    $display("MAR = %4x\n", address);
	// check load from PC
	mux1 = 1;

    ld = 1;
    #10
    $display("MAR = %4x\n", address);
    ld = 0;
	// check load from ALU
	mux2 = 1; 

    ld = 1;
    #10
    $display("MAR = %4x\n", address);
    ld = 0;
	
	// check increment
    mux1 = 0;
    mux2 = 0;

    ld = 1;
    #10
    $display("MAR = %4x\n", address);
    ld = 0;
    ld = 1;
    #10
    $display("MAR = %4x\n", address);
    ld = 0;

end



endmodule
