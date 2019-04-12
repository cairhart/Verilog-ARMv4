`include "alu_op_mux.v"

module test;

reg [1:0] alu_op_mux; 
reg [3:0] ir_op;
reg [3:0] cs_op;
reg u;
wire [3:0] alu_operation;

alu_operation_mux MUX(
	.alu_op_mux(alu_op_mux),
	.ir_op(ir_op),
	.cs_op(cs_op),
	.u(u),
	.alu_operation(alu_operation)
);

integer failcount = 0;

task assert;
input [3:0]     expected;
input [3:0]     actual;
begin
    
    if(expected != actual)  begin
        $display("Error: expected = %d actual  = %d", expected, actual);
        failcount = failcount + 1;
    end

end
endtask


initial begin
    $display("Begin testing");
    alu_op_mux = 0;
    ir_op = 15;
    cs_op = 10;
    u = 0;
    
    #10
    assert(15, alu_operation); 
    ir_op = 9;

    #10
    assert(9, alu_operation);


    alu_op_mux = 1;
    #10
    assert(10, alu_operation);

    alu_op_mux = 2;
    #10
    assert(4, alu_operation);

    u = 1;
    #10
    assert(2, alu_operation);

    ir_op = 14;
    alu_op_mux = 0;
    #10
    assert(14, alu_operation);


    if(failcount > 0) 
    $display("Test failed: %d times", failcount);
    if(failcount == 0)
    $display("All tests pass");
    $display("Finished testing");

    end


endmodule

