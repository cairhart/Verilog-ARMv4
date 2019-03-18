`include "multiply_unit.v"

module mul_test;

integer failcount;

task check_status;
    input [31:0] expected;
    begin
        $write("t=%0t\t", $time);
        $write("A_Bus=%d\t", mult.A);
        $write("B_Bus=%d, ", mult.B);
        $write("Gate_MUL=%b, ", mult.Gate_MUL);
        $write("MUL_HiLo=%b, ", mult.MUL_HiLo);
        $write("LD_MUL=%b, ", mult.LD_MUL);
        $write("U=%b, ", mult.U);
        $write("\t");
        if (mult.A == expected) $write("+ passed");
        else begin $write("- FAILED"); failcount = failcount + 1;  end
        $write("\n");
    end
endtask

wire [31:0] A_input_value;
reg [31:0] A_output_value;
wire [31:0] A_value;
reg [31:0] B;                    
reg Gate_MUL, MUL_HiLo, LD_MUL, U;

mul mult(
    .A(A_value),
    .B(B),
    .Gate_MUL(Gate_MUL),
    .MUL_HiLo(MUL_HiLo),
    .LD_MUL(LD_MUL),
    .U(U)
);


assign A_input_value = A_value;
assign A_value = (Gate_MUL)? A_output_value : 32'hZZZZZZZZ;

initial begin
    Gate_MUL = 0;
    // use A_value as input here so you can read its current value
    $display ("Current value: %x\n", A_value);
    #100;
    // now we switch to output signal: we write value 10101010 in it
    Gate_MUL = 1;
    A_output_value = 8'hAA;
    #100;
    $finish;
end

//////

initial begin
    A = 32'h00000000;
    B = 32'h00000000;
    Gate_MUL = 1'b0;
    MUL_HiLo = 1'b0;
    LD_MUL = 1'b0;
    U = 1'b0;
    failcount = 0;

     #10 check_status(-1);

/*
    $display("skipping past decode");
    $display("testing data processing");
    #20 #20 #20 check_status(24);
    #20 check_status(25);
    #20 check_status(104);

    family_bits = 16'h0010;

    $display("skipping past decode");
    $display("testing multiply");
    #20 #20 #20 check_status(32);
    #20 check_status(34);
    #20 check_status(36);
    #20 check_status(104);

    A = 1;

    $display("skipping past decode");
    $display("testing multiply long");
    #20 #20 #20 check_status(32);
    #20 check_status(35);
    #20 check_status(34);
    #20 check_status(36);
    #20 check_status(104);

    family_bits = 16'h0020;

    $display("skipping past decode");
    $display("testing load/store word/unsigned byte (post-indexing)");
    #20 #20 #20 check_status(40);
    #20 check_status(41);
    #20 check_status(42);
    #20 check_status(44);
    #20 check_status(104);

    P = 1;

    $display("skipping past decode");
    $display("testing load/store word/unsigned byte (pre-indexing)");
    #20 #20 #20 check_status(40);
    #20 check_status(43);
    #20 check_status(44);
    #20 check_status(104);

    family_bits = 16'h0040;
    P = 0;

    $display("skipping past decode");
    $display("testing load/store halfword/signed byte (post-indexing)");
    #20 #20 #20 check_status(48);
    #20 check_status(49);
    #20 check_status(50);
    #20 check_status(52);
    #20 check_status(104);

    P = 1;

    $display("skipping past decode");
    $display("testing load/store halfword/signed byte (pre-indexing)");
    #20 #20 #20 check_status(48);
    #20 check_status(51);
    #20 check_status(52);
    #20 check_status(104);

    family_bits = 16'h0080;

    $display("skipping past decode");
    $display("testing branch");
    #20 #20 #20 check_status(56);
    #20 check_status(57);
    #20 check_status(104);

    L = 1;

    $display("skipping past decode");
    $display("testing branch and link");
    #20 #20 #20 check_status(56);
    #20 check_status(61);
    #20 check_status(57);
    #20 check_status(104);

    family_bits = 16'h0100;

    $display("skipping past decode");
    $display("testing swap");
    #20 #20 #20 check_status(64);
    #20 check_status(65);
    #20 check_status(104);
*/

    $write("\n");
    if (failcount > 0) $write("%d tests failed\n", failcount);
    else $write("          all tests passed! :)\n");

    $finish;
end

endmodule
