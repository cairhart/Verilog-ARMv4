`include "multiply_unit.v"

module mul_test;

integer failcount;

task check_status;
    input [31:0] expected;
    begin
        $write("t=%0t\t", $time);
        $write("B_In=%d, ", mult.B_In);
        $write("C=%d, ", mult.C);
        $write("B_Out=%d\n", mult.B_Out);
        $write("\tMUL_HiLo=%b, ", mult.MUL_HiLo);
        $write("LD_MUL=%b, ", mult.LD_MUL);
        $write("U=%b, ", mult.U);
        $write("\t");
        if (mult.B_Out == expected) $write("+ passed");
        else begin $write("- FAILED"); failcount = failcount + 1;  end
        $write("\n");
    end
endtask

reg [31:0] B_In, C;                    
reg MUL_HiLo, LD_MUL, U;
wire [31:0] B_Out;

mul mult(
    .B_In(B_In),
    .C(C),                    
    .MUL_HiLo(MUL_HiLo), 
    .LD_MUL(LD_MUL), 
    .U(U),
    .B_Out(B_Out)               
);

initial begin
    $display("Set LD_MUL to 0");
    B_In = 0;
    C    = 0;
    MUL_HiLo = 1'b0;
    LD_MUL = 1'b0;
    U = 1'b0;
    failcount = 0;
    #10 check_status(-1);

    $display("Test changing inputs has no effect when LD_MUL is 0");
    $display("Test changing U or HiLo has no effect when LD_MUL is 0");
    $display("Set LD_MUL to 1, HiLo = 0 (Lo), U = 0 (unsigned)");
    //5*5 = 25
    //2,000*2,000 = 4,000,000
    //4,000,000*4,000,000 = 1,246,822,400 
    //                    = (0100 1010 0101 0001 0000 0000 0000 0000)_2
    //2,500,000,000*2,000,000,000 = 1,156,841,472   
    //                         = (0100 0100 1111 0100 0000 0000 0000 0000)_2
    $display("Set LD_MUL to 1, HiLo = 1 (Hi), U = 0 (unsigned)");
    //5*5 = 0
    //2,000*2,000 = 0
    //4,000,000*4,000,000 = 3,725 = (1110 1000 1101)_2
    //2,500,000,000*2,000,000,000 = 1,164,153,218 
    //                            = (0100 0101 0110 0011 1001 0001 1000 0010)_2
    $display("Set LD_MUL to 1, HiLo = 0 (Lo), U = 1 (signed)");
    //-3*3 = -9
    //4*-4 = -16
    //-5*-5 = 25
    //-4,000,000 * 4,000,000 = -1,246,822,400 
    //                       = (1011 0101 1010 1111 0000 0000 0000 0000)_2
    //1,000,000,000 * -20 = -2,820,130,816 
    //                   = (1010 0111 1110 1000 0011 1000 0000 0000)_2
    //-2,500,000,000*-2,000,000,000 = 1,156,841,472   
    //                         = (0100 0100 1111 0100 0000 0000 0000 0000)_2
    $display("Set LD_MUL to 1, HiLo = 1 (Hi), U = 1 (signed)");
    //-3*3 = -9
    //4*-4 = -16
    //-5*-5 = 25
    //-4,000,000 * 4,000,000 = -3,725 
    //                       = (1111 1111 1111 1111 1111 0001 0111 0011)_2
    //1,000,000,000 * -20 = -4 = (1111 1111 1111 1111 1111 1111 1111 1100)_2
    //-2,500,000,000*-2,000,000,000 = 1,164,153,218 
    //                              = (0100 0101 0110 0011 1001 0001 1000 0010)_2

    //FUCK SIGNED NUMBERS
    LD_MUL = 1'b1;
    MUL_HiLo = 1'b1;
    U = 1'b1;
    #10 check_status(1164153218);

    $write("\n");
    if (failcount > 0) $write("%d tests failed\n", failcount);
    else $write("          all tests passed! :)\n");

    $finish;
end

endmodule
