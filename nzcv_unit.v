module nzcv_unit(
		input [3:0] nzcv_input,// ALU Selection
		input s_input,
		input [3:0] opcode_input,
		input clk,
		output operated
    );
    reg [3:0] nzcv = 4'b0000;

	always @(posedge clk)
		nzcv = s_input ? nzcv_input : nzcv;

	reg always_1 = 1;
	reg always_0 = 0;
	assign operated = always_1;
/*	
	assign operated = opcode_input[3] ? 
						(opcode_input[2] ? 
							(opcode_input[1]? 
								(opcode_input[0]? always_0 : always_1)
								:(opcode_input[0]?  
										(nzcv[2] || (nzcv[3] && !nzcv[0])) || (!nzcv[3] && nzcv[0])
										: (nzcv[2] && (nzcv[3] || nzcv[0])) || (!nzcv[3] && !nzcv[0])))
							:(opcode_input[1]?
								(opcode_input[0]? 
										(nzcv[3] && !nzcv[0]) || (!nzcv[3] && nzcv[0])
										: (nzcv[3] && nzcv[0]) || (!nzcv[3] && !nzcv[0]))
								:(opcode_input[0]? !nzcv[1] || nzcv[2] : nzcv[1] && !nzcv[2])))
						:(opcode_input[2] ? 
							(opcode_input[1]? 
								(opcode_input[0]? !nzcv[0] : nzcv[0])
								:(opcode_input[0]? !nzcv[3] : nzcv[3]))
							:(opcode_input[1]?
								(opcode_input[0]? !nzcv[1] : nzcv[1])
								:(opcode_input[0]? !nzcv[2] : nzcv[2])));
*/
 /*   always @(*)
    begin
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
	*/
endmodule
