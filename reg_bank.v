module RegBank(
    input clk,
    input rst,
    input latch_reg,
    input [3:0] Rd,
    input [3:0] Rn,
    input [3:0] Rm,
    input [3:0] Rs,
    input [31:0] data_in,

    output [31:0] Rn_data,
    output [31:0] Rm_data,
    output [31:0] Rs_data,
    output [31:0] ST,
    output [31:0] PC
);

reg [31:0] REG_DATA [0:15];

assign Rn_data = REG_DATA[Rn];
assign Rm_data = REG_DATA[Rm];
assign Rs_data = REG_DATA[Rs];
assign ST = REG_DATA[12];
assign PC = REG_DATA[15];

always @(posedge clk) begin
    if (rst == 1) begin
        REG_DATA[13] = 16'h8000; // SP initial value
        REG_DATA[14] = 16'h0000; // LR initial value
        REG_DATA[15] = 16'h0000; // PC initial value
    end
    else if (latch_reg == 1) begin
        REG_DATA[Rd] = data_in;
        $display("Latching in %d value %d \n",Rd,data_in);
    end
end

endmodule
