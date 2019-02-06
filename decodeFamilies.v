/* Rough Decode Logic for identifying decode families
 * Started By: Vickie
 */

/* Decode Families Key:
 * Index  Description
 * f[0]   Data Processing Immediate 
 * f[1]   Data Processing Immediate Shift 
 * f[2]   Data Processing Register Shift
 * f[3]   Multiply
 * f[4]   Multiply Long
 * f[5]   Move from Status Register
 * f[6]   Move Immediate to Status Register
 * f[7]   Move Register to Status Register
 * f[8]   Load/Store Immediate Offset
 * f[9]   Load/Store Register Offset
 * f[10]  Load/Store Halfword/Signed Byte Combined Offset
 * f[11]  Load/Store Halfword/Signed Byte Shifted Offset
 * f[12]  Swap/Swap Byte
 * f[13]  Load/Store Multiple
 * f[14]  Branch and Branch with Link
 * f[15]  Undefined Instruction
 */

module decodeFamily (ir, f);
input [31:0] ir; 
output reg [15:0] f; 
  
wire [15:0] mask  = 16'h0001;

always @ (ir) 
    case (ir[27:25]) 
        3'b000 : begin 
                    if ((ir[24:22] == 3'b000) && (ir[7:4] == 4'b1001)) f = (mask << 3); //f3
                    else if ((ir[24:23] == 2'b01) && (ir[7:4] == 4'b1001)) f = (mask << 4); //f4
                    else if ((ir[24:23] == 2'b10) && (ir[21:20] == 2'b00)) begin
                        if (ir[7:4] == 4'b1001) f = (mask << 12); //f12
                        else f = (mask << 5); //f5
                    end
                    else if (((ir[24:23] == 2'b10)  && (ir[21:20] == 2'b10)) && (ir[4] == 1'b0)) f = (mask << 7); //f7
                    else if (ir[4] == 1'b0) f = (mask << 1); //f1
                    else begin
                        if (ir[7] == 1'b0) f = (mask << 2); //f2
                        else begin
                            if (ir[22] == 1'b0) f = (mask << 11); //f11
                            else f = (mask << 10); //f10
                        end
                    end
                end

        3'b001 : begin
                    if ((ir[24:23] == 2'b10) && (ir[21:20] == 2'b10)) f = (mask << 6); //f6
                    else f = (mask << 0); //f0
                 end

        3'b010 : f = (mask << 8); //f8

        3'b011 : begin
                    if (ir[4] == 1'b0) f = (mask << 9); //f9
                    else f = (mask << 15); //f15
                 end

        3'b100 : f = (mask << 13); //f13

        3'b101 : f = (mask << 14); //f14

        3'b110 : f = 16'h0000; //not implementing these coprocessor instructions
        3'b111 : f = 16'h0000; //not implementing these coprocessor instructions
    endcase 
endmodule
/*
module decodeFamilySubcatagory000 (ir, f);
input [31:0] ir;
output reg [15:0] f;

wire [15:0] mask  = 16'h0001;

always @ (ir) begin
    if ((ir[24:22] == 3'b000) && (ir[7:4] == 4'b1001)) f = (mask << 3); //f3
    else if ((ir[24:23] == 2'b01) && (ir[7:4] == 4'b1001)) f = (mask << 4); //f4
    else if ((ir[24:23] == 2'b10) && (ir[21:20] == 2'b00)) begin
        if (ir[7:4] == 4'b1001) f = (mask << 12); //f12
        else f = (mask << 5); //f5
    end
    else if (((ir[24:23] == 2'b10)  && (ir[21:20] == 2'b10)) && (ir[4] == 1'b0)) f = (mask << 7); //f7
    else if (ir[4] == 1'b0) f = (mask << 1); //f1
    else begin
        if (ir[7] == 1'b0) f = (mask << 2); //f2
        else begin
            if (ir[22] == 1'b0) f = (mask << 11); //f11
            else f = (mask << 10); //f10
        end
    end
end

endmodule
*/
