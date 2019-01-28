module decoder(out,clk,ir);
input [31:0] ir, clk;
output [16:0] out;
always @ ir
if( ir[27:25] == 3'b010 ) begin
 out = 1;
end
endmodule // counter
