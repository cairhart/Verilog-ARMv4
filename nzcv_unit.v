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

assign operated = (opcode_input == 4'b0000) ? nzcv[2] :
				  (opcode_input == 4'b0001) ? !nzcv[2]:
				  (opcode_input == 4'b0010) ? nzcv[1]:
				  (opcode_input == 4'b0011) ? !nzcv[1]:
				  (opcode_input == 4'b0100) ? nzcv[3]:
				  (opcode_input == 4'b0101) ? !nzcv[3]:
				  (opcode_input == 4'b0110) ? nzcv[0]:
				  (opcode_input == 4'b0111) ? !nzcv[0]:
				  (opcode_input == 4'b1000) ? nzcv[1] && !nzcv[2]:
				  (opcode_input == 4'b1001) ? !nzcv[1] || nzcv[2]:
				  (opcode_input == 4'b1010) ? 
				  	(nzcv[3] && nzcv[0]) || (!nzcv[3] && !nzcv[0]):
				  (opcode_input == 4'b1011) ? 
					(nzcv[3] && !nzcv[0]) || (!nzcv[3] && nzcv[0]):
				  (opcode_input == 4'b1100) ? 
					(nzcv[2] && (nzcv[3] || nzcv[0])) || (!nzcv[3] && !nzcv[0]):
				  (opcode_input == 4'b1101) ? 
					(nzcv[2] || (nzcv[3] && !nzcv[0])) || (!nzcv[3] && nzcv[0]):
				  (opcode_input == 4'b1111) ? 0 : 1;
/*
   always @(*)
    begin
        case(opcode_input)
        4'b0000: // 
			operated = nzcv[2];
        4'b0001: // 
			operated = !nzcv[2];
        4'b0010: // 
			operated = nzcv[1];
        4'b0011: // 
			operated = !nzcv[1];
        4'b0100: // 
			operated = nzcv[3];
        4'b0101: // 
			operated = !nzcv[3];
        4'b0110: // 
			operated = nzcv[0];
        4'b0111: // 
			operated = !nzcv[0];
        4'b1000: //
			operated = nzcv[1] && !nzcv[2];
        4'b1001: //
			operated = !nzcv[1] || nzcv[2];
        4'b1010: //
			operated = (nzcv[3] && nzcv[0]) || (!nzcv[3] && !nzcv[0]);
        4'b1011: //
			operated = (nzcv[3] && !nzcv[0]) || (!nzcv[3] && nzcv[0]);
        4'b1100: //
			operated = (nzcv[2] && (nzcv[3] || nzcv[0])) || (!nzcv[3] && !nzcv[0]);
        4'b1101: //
			operated = (nzcv[2] || (nzcv[3] && !nzcv[0])) || (!nzcv[3] && nzcv[0]);
        4'b1110: //
			operated = 1'b1;
        4'b1111: //
			operated = 1'b0;
        endcase
    end
*/
endmodule
