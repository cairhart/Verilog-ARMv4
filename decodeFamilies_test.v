`include "decodeFamilies.v"

/* Decode Families Key:
 * Index  Testcase  Formula                             Description
 * f[0]   32'bxxxx  001x xxxx xxxx xxxx xxxx xxxx xxxx  Data Processing Immediate 
 * f[1]   32'bxxxx  000x xxxx xxxx xxxx xxxx xxx0 xxxx  Data Processing Immediate Shift 
 * f[2]   32'bxxxx  000x xxxx xxxx xxxx xxxx 0xx1 xxxx  Data Processing Register Shift
 * f[3]   32'bxxxx  0000 00xx xxxx xxxx xxxx 1001 xxxx  Multiply
 * f[4]   32'bxxxx  0000 1xxx xxxx xxxx xxxx 1001 xxxx  Multiply Long
 * f[5]   32'bxxxx  0001 0x00 xxxx xxxx xxxx xxxx xxxx  Move from Status Register
 * f[6]   32'bxxxx  0011 0x10 xxxx xxxx xxxx xxxx xxxx  Move Immediate to Status Register
 * f[7]   32'bxxxx  0001 0x10 xxxx xxxx xxxx xxx0 xxxx  Move Register to Status Register
 * f[8]   32'bxxxx  010x xxxx xxxx xxxx xxxx xxxx xxxx  Load/Store Immediate Offset
 * f[9]   32'bxxxx  011x xxxx xxxx xxxx xxxx xxx0 xxxx  Load/Store Register Offset
 * f[10]  32'bxxxx  000x x1xx xxxx xxxx xxxx 1xx1 xxxx  Load/Store Halfword/Signed Byte Combined Offset
 * f[11]  32'bxxxx  000x x0xx xxxx xxxx xxxx 1xx1 xxxx  Load/Store Halfword/Signed Byte Shifted Offset
 *                                            `->note f[11][6] & f[11][5] CANNOT both be 0 at the same time   
 * f[12]  32'bxxxx  0001 0x00 xxxx xxxx xxxx 1001 xxxx  Swap/Swap Byte
 * f[13]  32'bxxxx  100x xxxx xxxx xxxx xxxx xxxx xxxx  Load/Store Multiple
 * f[14]  32'bxxxx  101x xxxx xxxx xxxx xxxx xxxx xxxx  Branch and Branch with Link
 * f[15]  32'bxxxx  011x xxxx xxxx xxxx xxxx xxx1 xxxx  Undefined Instruction
 */

module testDecodeFamilies;

integer failcount;

task check_status;
    input [15:0] expected;
    begin
        $write("t=%0t\t", $time);
        $write("ir=%h, ", DECODE_FAMILY.ir);
        $write("f=%h ", DECODE_FAMILY.f);
        $write("\t");
        if (DECODE_FAMILY.f == expected) $write("+ passed");
        else begin $write("- FAILED"); failcount = failcount + 1;  end
        $write("\n");
    end
endtask

reg [31:0] ir;
wire [15:0] f;

decodeFamily DECODE_FAMILY (ir, f);

initial begin
    failcount = 0;
    $display("<< Starting the Testbench >>");
   
    $display("\n<< Testing all testing formulas with x = 0 >>");
    /* testing these testcases:
    f0  32'b0000 0010 0000 0000 0000 0000 0000 0000
    f1  32'b0000 0000 0000 0000 0000 0000 0000 0000
    f2  32'b0000 0000 0000 0000 0000 0000 0001 0000
    f3  32'b0000 0000 0000 0000 0000 0000 1001 0000
    f4  32'b0000 0000 1000 0000 0000 0000 1001 0000
    f5  32'b0000 0001 0000 0000 0000 0000 0000 0000
    f6  32'b0000 0011 0010 0000 0000 0000 0000 0000
    f7  32'b0000 0001 0010 0000 0000 0000 0000 0000
    f8  32'b0000 0100 0000 0000 0000 0000 0000 0000
    f9  32'b0000 0110 0000 0000 0000 0000 0000 0000
    f10 32'b0000 0000 0100 0000 0000 0000 1001 0000
    f11 32'b0000 0000 0000 0000 0000 0000 1101 0000
    f12 32'b0000 0001 0000 0000 0000 0000 1001 0000
    f13 32'b0000 1000 0000 0000 0000 0000 0000 0000
    f14 32'b0000 1010 0000 0000 0000 0000 0000 0000
    f15 32'b0000 0110 0000 0000 0000 0000 0001 0000 */

    ir = 32'b00000010000000000000000000000000;  // f[0]   Data Processing Immediate 
    #10 check_status(16'h0001);
    
    ir = 32'b00000000000000000000000000000000;  // f[1]   Data Processing Immediate Shift 
    #10 check_status(16'h0002);
    
    ir = 32'b00000000000000000000000000010000;  // f[2]   Data Processing Register Shift
    #10 check_status(16'h0004);
    
    ir = 32'b00000000000000000000000010010000;  // f[3]   Multiply
    #10 check_status(16'h0008);
    
    ir = 32'b00000000100000000000000010010000;  // f[4]   Multiply Long
    #10 check_status(16'h0010);
    
    ir = 32'b00000001000000000000000000000000;  // f[5]   Move from Status Register
    #10 check_status(16'h0020);
    
    ir = 32'b00000011001000000000000000000000;  // f[6]   Move Immediate to Status Register
    #10 check_status(16'h0040);
    
    ir = 32'b00000001001000000000000000000000;  // f[7]   Move Register to Status Register
    #10 check_status(16'h0080);
    
    ir = 32'b00000100000000000000000000000000;  // f[8]   Load/Store Immediate Offset
    #10 check_status(16'h0100);
    
    ir = 32'b00000110000000000000000000000000;  // f[9]   Load/Store Register Offset
    #10 check_status(16'h0200);
    
    ir = 32'b00000000010000000000000010010000;  // f[10]  Load/Store Halfword/Signed Byte Combined Offset
    #10 check_status(16'h0400);
    
    ir = 32'b00000000000000000000000011010000;  // f[11]  Load/Store Halfword/Signed Byte Shifted Offset
    #10 check_status(16'h0800);
    
    ir = 32'b00000001000000000000000010010000;  // f[12]  Swap/Swap Byte
    #10 check_status(16'h1000);
    
    ir = 32'b00001000000000000000000000000000;  // f[13]  Load/Store Multiple
    #10 check_status(16'h2000);

    ir = 32'b00001010000000000000000000000000;  // f[14]  Branch and Branch with Link
    #10 check_status(16'h4000);
    
    ir = 32'b00000110000000000000000000010000;  // f[15]  Undefined Instruction
    #10 check_status(16'h8000);

    $display("\n<< Testing all testing formulas with x = 1 >>");
    /* testing these testcases:
    32'b1111 0011 1111 1111 1111 1111 1111 1111  f0   Data Processing Immediate 
    32'b1111 0001 1111 1111 1111 1111 1110 1111  f1   Data Processing Immediate Shift 
    32'b1111 0001 1111 1111 1111 1111 0111 1111  f2   Data Processing Register Shift
    32'b1111 0000 0011 1111 1111 1111 1001 1111  f3   Multiply
    32'b1111 0000 1111 1111 1111 1111 1001 1111  f4   Multiply Long
    32'b1111 0001 0100 1111 1111 1111 1111 1111  f5   Move from Status Register
    32'b1111 0011 0110 1111 1111 1111 1111 1111  f6   Move Immediate to Status Register
    32'b1111 0001 0110 1111 1111 1111 1110 1111  f7   Move Register to Status Register
    32'b1111 0101 1111 1111 1111 1111 1111 1111  f8   Load/Store Immediate Offset
    32'b1111 0111 1111 1111 1111 1111 1110 1111  f9   Load/Store Register Offset
    32'b1111 0001 1111 1111 1111 1111 1111 1111  f10  Load/Store Halfword/Signed Byte Combined Offset
    32'b1111 0001 1011 1111 1111 1111 1111 1111  f11  Load/Store Halfword/Signed Byte Shifted Offset
    32'b1111 0001 0100 1111 1111 1111 1001 1111  f12  Swap/Swap Byte
    32'b1111 1001 1111 1111 1111 1111 1111 1111  f13  Load/Store Multiple
    32'b1111 1011 1111 1111 1111 1111 1111 1111  f14  Branch and Branch with Link
    32'b1111 0111 1111 1111 1111 1111 1111 1111  f15  Undefined Instruction
    */

    ir = 32'b11110011111111111111111111111111;  // f0   Data Processing Immediate 
    #10 check_status(16'h0001);
    
    ir = 32'b11110001111111111111111111101111;  // f1   Data Processing Immediate Shift 
    #10 check_status(16'h0002);
    
    ir = 32'b11110001111111111111111101111111;  // f2   Data Processing Register Shift
    #10 check_status(16'h0004);
    
    ir = 32'b11110000001111111111111110011111;  // f3   Multiply
    #10 check_status(16'h0008);
    
    ir = 32'b11110000111111111111111110011111;  // f4   Multiply Long
    #10 check_status(16'h0010);
    
    ir = 32'b11110001010011111111111111111111;  // f5   Move from Status Register
    #10 check_status(16'h0020);
    
    ir = 32'b11110011011011111111111111111111;  // f6   Move Immediate to Status Register
    #10 check_status(16'h0040);
    
    ir = 32'b11110001011011111111111111101111;  // f7   Move Register to Status Register
    #10 check_status(16'h0080);
    
    ir = 32'b11110101111111111111111111111111;  // f8   Load/Store Immediate Offset
    #10 check_status(16'h0100);
    
    ir = 32'b11110111111111111111111111101111;  // f9   Load/Store Register Offset
    #10 check_status(16'h0200);
    
    ir = 32'b11110001111111111111111111111111;  // f10  Load/Store Halfword/Signed Byte Combined Offset
    #10 check_status(16'h0400);
    
    ir = 32'b11110001101111111111111111111111;  // f11  Load/Store Halfword/Signed Byte Shifted Offset
    #10 check_status(16'h0800);
    
    ir = 32'b11110001010011111111111110011111;  // f12  Swap/Swap Byte
    #10 check_status(16'h1000);
    
    ir = 32'b11111001111111111111111111111111;  // f13  Load/Store Multiple
    #10 check_status(16'h2000);
    
    ir = 32'b11111011111111111111111111111111;  // f14  Branch and Branch with Link
    #10 check_status(16'h4000);
    
    ir = 32'b11110111111111111111111111111111;  // f15  Undefined Instruction
    #10 check_status(16'h8000);
    
    $display("\n<< Testing instructions from ./top_module_test.v >>");
    ir = 32'h2000A0E3;
    #10 check_status(16'h0000);

    ir = 32'h1010A0E3;
    #10 check_status(16'h0000);

    ir = 32'h0100A1E0;
    #10 check_status(16'h0000);

    $write("\n");
    if (failcount > 0) $write("%d tests failed\n", failcount);
    else $write("          all tests passed! :)\n");

    $finish;
end

endmodule
