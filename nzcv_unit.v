module nzcv_unit(
           input [3:0] nzcv_input,// ALU Selection
					 input s_input,
					 input [3:0] opcode_input,
					 output operated
    );
    reg [3:0] nzcv;
		reg operate;
		assign operated = operate;
    always @(*)
    begin
				nzcv = s_input ? nzcv_input : nzcv;
        case(opcode_input)
        4'b0000: // 
					operate = nzcv[2];
        4'b0001: // 
					operate = !nzcv[2];
        4'b0010: // 
					operate = nzcv[1];
        4'b0011: // 
					operate = !nzcv[1];
        4'b0100: // 
					operate = nzcv[3];
        4'b0101: // 
					operate = !nzcv[3];
        4'b0110: // 
					operate = nzcv[0];
        4'b0111: // 
					operate = !nzcv[0];
        4'b1000: //
					operate = nzcv[1] && !nzcv[2];
        4'b1001: //
					operate = !nzcv[1] || nzcv[2];
        4'b1010: //
					operate = (nzcv[3] && nzcv[0]) || (!nzcv[3] && !nzcv[0]);
        4'b1011: //
					operate = (nzcv[3] && !nzcv[0]) || (!nzcv[3] && nzcv[0]);
        4'b1100: //
					operate = (nzcv[2] && (nzcv[3] || nzcv[0])) || (!nzcv[3] && !nzcv[0]);
        4'b1101: //
					operate = (nzcv[2] || (nzcv[3] && !nzcv[0])) || (!nzcv[3] && nzcv[0]);
        4'b1110: //
					operate = 1;
        4'b1111: //
					operate = 0;
        endcase
    end
endmodule
