/* Multiply Unit for Multiply and Multiply Long Families
 * Started By: Vickie
 * Last Modified: March 5th, 2019
 * Last Modified By: Vickie
 */

/* Multiply Unit */
module mul(
    inout [31:0] A,
    input [31:0] B,                    
    input Gate_MUL, MUL_HiLo, LD_MUL, U
);
    reg [63:0] opA, opB;
    reg [63:0] MUL;

    initial begin 
        MUL = -1;
    end

    always @(*) begin
        opA = (({{32{A[31]}}, {A}} & {64{U}}) | ({{32{1'b0}}, {A}} & {64{!U}})); //A is sext or zext
        opB = (({{32{B[31]}}, {B}} & {64{U}}) | ({{32{1'b0}}, {B}} & {64{!U}})); //B is sext or zext
        MUL = ({64{LD_MUL}} & (opA * opB));
    end

    assign A = (Gate_MUL)? (({32{MUL_HiLo}} & MUL[63:32]) | ({32{!MUL_HiLo}} & MUL[31:0])) : 32'bz; //result or high z 
// not proper format...?    assign A = ({32{Gate_MUL}} & (({32{MUL_HiLo}} & MUL[63:32]) | ({32{!MUL_HiLo}} & MUL[31:0]))); 

endmodule
