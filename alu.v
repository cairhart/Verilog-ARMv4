module alu(
        input [31:0] A,B,  // ALU 8-bit Inputs                 
        input [3:0] ALU_Sel,// ALU Selection
        input rst,
        output [63:0] ALU_Out, // ALU 8-bit Output
        output [3:0] NZCV
);
    reg [63:0] ALU_Result;
    reg [3:0] nzcv; // Carryout flag

    assign ALU_Out = ALU_Result; // ALU out
		assign NZCV = nzcv;


    always @(*)
    begin
        case(ALU_Sel)
        4'b0000: // Logical and
           ALU_Result = A & B ; 
        4'b0001: // xor
           ALU_Result = A ^ B ;
        4'b0010: // 
           ALU_Result = A - B;
        4'b0011: // 
           ALU_Result = B - A;
        4'b0100: // 
           ALU_Result = A+B;
         4'b0101: // 
           ALU_Result = A+B+nzcv[1];
         4'b0110: // SBC
           ALU_Result = A-B-~(nzcv[1]);
         4'b0111: // RSC
           ALU_Result = B-A-~(nzcv[1]);
          4'b1000: //  TST
           ALU_Result = A & B;
          4'b1001: //  TESTEQ
           ALU_Result = A ^ B;
          4'b1010: // Compare
           ALU_Result = A - B;
          4'b1011: //  Compare Negative
           ALU_Result = A + B;
          4'b1100: // Logical OR
           ALU_Result = A | B;
          4'b1101: // MOV
           ALU_Result = B;
          4'b1110: // BitClear
           ALU_Result = A & ~(B);
          4'b1111: // REVMOV   
            ALU_Result = A;
          default: ALU_Result = A + B ; 
        endcase
            if(rst) begin
                nzcv = 4'b0000;
            end
            else begin
				nzcv[3] = ALU_Result[31];
				if(ALU_Result == 32'h0000)
					nzcv[2] = 1;
				else
					nzcv[2] = 0;
				if(A > 0 && B > 0 && ALU_Result>>31 != 0)
					nzcv[0] = 1;
				else
					nzcv[0] = 0;
				if(ALU_Result >> 32 != 0)
					nzcv[1] = 1;
				else
				 	nzcv[0] = 0;
            end
    end
endmodule
