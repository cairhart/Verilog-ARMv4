/* Decode Logic for Identifying Decode Families
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

module decodeFamily (
	input [31:0] ir,
	output reg [15:0] f_signals,
  output reg [3:0] f_num
);

wire [15:0] mask  = 16'h0001;

initial begin 
  f_signals = 16'h0000;
  f_num = 0;
end

always @ (ir, mask) 
    case (ir[27:25]) 
        3'b000 : begin 
                    if ((ir[24:22] == 3'b000) && (ir[7:4] == 4'b1001)) begin //f3 
                      f_signals = (mask << 3); 
                      f_num = 3;
                    end
                    else if ((ir[24:23] == 2'b01) && (ir[7:4] == 4'b1001)) begin //f4
                      f_signals = (mask << 4); 
                      f_num = 4;
                    end
                    else if ((ir[24:23] == 2'b10) && (ir[21:20] == 2'b00)) begin
                      if (ir[7:4] == 4'b1001) begin //f12
                        f_signals = (mask << 12); 
                        f_num = 12;
                      end
                      else begin //f5
                        f_signals = (mask << 5); 
                        f_num = 5;
                      end
                    end
                    else if (((ir[24:23] == 2'b10)  && (ir[21:20] == 2'b10)) && (ir[4] == 1'b0)) begin //f7 
                      f_signals = (mask << 7); 
                      f_num = 7;
                    end
                    else if (ir[4] == 1'b0) begin //f1
                      f_signals = (mask << 1); 
                      f_num = 1;
                    end
                    else begin
                        if (ir[7] == 1'b0) begin //f2
                          f_signals = (mask << 2); 
                          f_num = 2;
                        end
                        else begin
                            if (ir[22] == 1'b0) begin //f11
                              f_signals = (mask << 11); 
                              f_num = 11;
                            end
                            else begin //f10
                              f_signals = (mask << 10); 
                              f_num = 10;
                            end
                        end
                    end
                end

        3'b001 : begin
                    if ((ir[24:23] == 2'b10) && (ir[21:20] == 2'b10)) begin //f6
                      f_signals = (mask << 6); 
                      f_num = 6;
                    end
                    else begin //f0
                      f_signals = (mask << 0); 
                      f_num = 0;
                    end
                 end

        3'b010 : begin //f8
                  f_signals = (mask << 8); 
                  f_num = 8;
                end

        3'b011 : begin
                    if (ir[4] == 1'b0) begin //f9
                      f_signals = (mask << 9); 
                      f_num = 9;
                    end
                    else begin //f15
                      f_signals = (mask << 15); 
                      f_num = 15;
                    end
                 end

        3'b100 : begin //f13
                   f_signals = (mask << 13); 
                   f_num = 13;
                 end

        3'b101 : begin //f14
                   f_signals = (mask << 14); 
                   f_num = 14;
                 end

        3'b110 : begin //not implementing these coprocessor instructions
                   f_signals = 16'h0000; 
                   f_num = 0;
                 end

        3'b111 : begin //not implementing these coprocessor instructions
                   f_signals = 16'h0000; 
                   f_num = 0;
                 end
    endcase 
endmodule

