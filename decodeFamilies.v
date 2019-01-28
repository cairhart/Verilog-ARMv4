/* Rough Decode Logic for identifying decode families
 * Started By: Vickie
 */

/* Decode Families Key:
 * HexMask    Index  Description
 * 17'h00001  f[0]   Data Processing Immediate 
 * 17'h00002  f[1]   Data Processing Immediate Shift 
 * 17'h00004  f[2]   Data Processing Register Shift
 * 17'h00008  f[3]   Multiply
 * 17'h00010  f[4]   Multiply Long
 * 17'h00020  f[5]   Move from Status Register
 * 17'h00040  f[6]   Move Immediate to Status Register
 * 17'h00080  f[7]   Move Register to Status Register
 * 17'h00100  f[8]   Branch/Exchange Instruction Set
 * 17'h00200  f[9]   Load/Store Immediate Offset
 * 17'h00400  f[10]  Load/Store Register Offset
 * 17'h00800  f[11]  Load/Store Halfword/Signed Byte Combined Offset
 * 17'h01000  f[12]  Load/Store Halfword/Signed Byte Shifted Offset
 * 17'h02000  f[13]  Swap/Swap Byte
 * 17'h04000  f[14]  Load/Store Multiple
 * 17'h08000  f[15]  Branch and Branch with Link
 * 17'h10000  f[16]  Undefined Instruction
 */

module decodeFamily (ir, f);
input [31:0] ir; 
output reg [16:0] f; 
  
always @ (ir) 
    case (ir[27:25]) 
        3'b000 : decodeFamilySubcatagory000 (ir, f); 

        3'b001 : begin
                    if ((ir[24:23] == 2'b10) && (ir[21:20] == 2'b10)) f = 17'h00040; //f6
                    else f = 17'h00001; //f0
                 end

        3'b010 : f = 17'h00200; //f9

        3'b011 : begin
                    if (ir[4] == 1'b0) f = 17'h00400; //f10
                    else f = 17'h10000; //f16
                 end

        3'b100 : f = 17'h04000; //f14

        3'b101 : f = 17'h08000; //f15

        3'b110 : f = 17'h00000; //not implementing these coprocessor instructions
        3'b111 : f = 17'h00000; //not implementing these coprocessor instructions
    endcase 
endmodule

module decodeFamilySubcatagory000 (ir, f);
input [31:0] ir;
output reg [16:0] f;
    //blah
endmodule

