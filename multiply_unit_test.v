`include "multiply_unit.v"

module mul_test;

integer failcount;

task check_status;
    input [31:0] expected;
    begin
        $write("t=%0t\t", $time);
        $write("B_In=%d, ", mult.B_In);
        $write("C=%d, ", mult.C);
        $write("B_Out=%d, ", mult.B_Out);
        $write("MUL_HiLo=%b, ", mult.MUL_HiLo);
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
    $display("\nSet LD_MUL to 0");
    B_In = 0;
    C    = 0;
    MUL_HiLo = 1'b0;
    LD_MUL = 1'b0;
    U = 1'b0;
    failcount = 0;
    #10 check_status(-1);

    $display("\nTest changing inputs has no effect when LD_MUL is 0");
    B_In = 5;
    C    = 5;
    #10 check_status(-1);

    B_In = -4000000;
    C    = 4000000;
    #10 check_status(-1);

    B_In = 20;
    C    = -5000;
    #10 check_status(-1);

    B_In = -1234;
    C    = -5678;
    #10 check_status(-1);

    $display("\nTest changing U or HiLo has no effect when LD_MUL is 0");
    MUL_HiLo = 1'b1;
    U = 1'b0;
    #10 check_status(-1);

    MUL_HiLo = 1'b0;
    U = 1'b1;
    #10 check_status(-1);

    MUL_HiLo = 1'b1;
    U = 1'b1;
    #10 check_status(-1);

    $display("\nSet LD_MUL to 1, HiLo = 0 (Lo), U = 0 (unsigned)");
    LD_MUL = 1'b1;
    MUL_HiLo = 1'b0;
    U = 1'b0;

    //5*5 = 25
    B_In = 5;
    C    = 5;
    #10 check_status(25);

    //2,000*2,000 = 4,000,000
    B_In = 2000;
    C    = 2000;
    #10 check_status(4000000);

    //4,000,000*4,000,000 = 1,246,822,400 = h(4A51 0000) 
    B_In = 4000000;
    C    = 4000000;
    #10 check_status(32'h4A510000);

    //2,000,000,000*1,000,000,000 = 1,321,730,048 = h(4EC8 0000)
    B_In = 2000000000;
    C    = 1000000000;
    #10 check_status(32'h4EC80000);

    $display("\nSet LD_MUL to 1, HiLo = 1 (Hi), U = 0 (unsigned)");
    LD_MUL = 1'b1;
    MUL_HiLo = 1'b1;
    U = 1'b0;

    //5*5 = 0
    B_In = 5;
    C    = 5;
    #10 check_status(0);

    //2,000*2,000 = 0
    B_In = 2000;
    C    = 2000;
    #10 check_status(0);

    //4,000,000*4,000,000 = 3,725 = h(0000 0E8D)
    B_In = 4000000;
    C    = 4000000;
    #10 check_status(32'h00000E8D);

    //2,000,000,000*1,000,000,000 = 465,661,287 = h(1BC1 6D67)   
    B_In = 2000000000;
    C    = 1000000000;
    #10 check_status(32'h1BC16D67);

    $display("\nSet LD_MUL to 1, HiLo = 0 (Lo), U = 1 (signed)");
    LD_MUL = 1'b1;
    MUL_HiLo = 1'b0;
    U = 1'b1;

    //-3*3 = -9
    B_In = -3;
    C    = 3;
    #10 check_status(-9);

    //4*-4 = -16
    B_In = 4;
    C    = -4;
    #10 check_status(-16);

    //-5*-5 = 25
    B_In = -5;
    C    = -5;
    #10 check_status(25);

    //-4,000,000 * 4,000,000 = -1,246,822,400 = h(B5AF 0000)
    B_In = -4000000;
    C    = 4000000;
    #10 check_status(32'hB5AF0000);

    //1,000,000,000 * -20 = 1,474,836,480 = h(57E8 3800) 
    B_In = 1000000000;
    C    = -20;
    #10 check_status(32'h57E83800);

    //-2,000,000,000*-1,000,000,000 = 1,321,730,048 = h(4EC8 0000)
    B_In = -2000000000;
    C    = -1000000000;
    #10 check_status(32'h4EC80000);

    $display("\nSet LD_MUL to 1, HiLo = 1 (Hi), U = 1 (signed)");
    LD_MUL = 1'b1;
    MUL_HiLo = 1'b1;
    U = 1'b1;

    //-3*3 = 0
    B_In = -3;
    C    = 3;
    #10 check_status(32'hFFFFFFFF);

    //4*-4 = 0
    B_In = 4;
    C    = -4;
    #10 check_status(32'hFFFFFFFF);

    //-5*-5 = 0
    B_In = -5;
    C    = -5;
    #10 check_status(0);

    //-4,000,000 * 4,000,000 = h(FFFF F172) 
    B_In = -4000000;
    C    = 4000000;
    #10 check_status(32'hFFFFF172);

    //1,000,000,000 * -20 = h(FFFF FFFB)
    B_In = 1000000000;
    C    = -20;
    #10 check_status(32'hFFFFFFFB);

    //-2,000,000,000*-1,000,000,000 = 465,661,287 = h(1BC1 6D67)  
    B_In = -2000000000;
    C    = -1000000000;
    #10 check_status(32'h1BC16D67);

    $write("\n");
    if (failcount > 0) $write("%d tests failed\n", failcount);
    else $write("          all tests passed! :)\n");

    $finish;
end

endmodule
