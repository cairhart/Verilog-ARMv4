/* Multiply Unit for Multiply and Multiply Long Families
 * Started By: Vickie, March 5th, 2019
 * Last Modified: March 18th, 2019
 * Last Modified By: Vickie
 */

/************* MULTIPLY UNIT ********************* 
 * Inputs:
 *      B_In -----> data input from the B Bus
 *      C --------> data input from the C Bus
 *      MUL_HiLo -> control signal; decides whether the Hi or Low half of
 *                  the internal MUL register are sent to the output
 *      LD_MUL ---> control signal; decides whether to store the resulting
 *                  multiplication in the internal MUL register or not
 *      U --------> IR[22]; in multiply instructions, IR[22] is the U signal
 *                  which determines whether the mult is signed or not (1
 *                  means signed)
 * Outputs:
 *      B_Out ----> Output of the Multiply Unit on to the B Bus
 */
module mul(
    input [31:0] B_In,
    input [31:0] C,                    
    input MUL_HiLo, LD_MUL, U,
    output [31:0] B_Out                    
);
    reg [63:0] op1, op2;
    reg [63:0] MUL;

    initial begin 
        MUL = -1;
    end

    always @(*) begin
        op1 = (({{32{B_In[31]}}, {B_In}} & {64{U}}) | ({{32{1'b0}}, {B_In}} & {64{!U}})); //B_In is sext or zext
        op2 = (({{32{C[31]}}, {C}} & {64{U}}) | ({{32{1'b0}}, {C}} & {64{!U}})); //C is sext or zext
        MUL = (LD_MUL)? op1 * op2 : MUL;
    end

    assign B_Out = (({32{MUL_HiLo}} & MUL[63:32]) | ({32{!MUL_HiLo}} & MUL[31:0]));
endmodule
