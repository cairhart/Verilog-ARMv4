module RegBank(
    input clk,
    input latch_reg,
    input [3:0] Rd,
    input [3:0] Rn,
    input [3:0] Rm,
    input [3:0] Rs,
    input [31:0] data_in,

    output [31:0] Rn_data,
    output [31:0] Rm_data,
    output [31:0] Rs_data,
    output [31:0] PC
);

reg [31:0] REG_DATA [0:15];

initial begin
    REG_DATA[ 0] = 16'd0;
    REG_DATA[ 1] = 16'd0;
    REG_DATA[ 2] = 16'd0;
    REG_DATA[ 3] = 16'd0;
    REG_DATA[ 4] = 16'd0;
    REG_DATA[ 5] = 16'd0;
    REG_DATA[ 6] = 16'd0;
    REG_DATA[ 7] = 16'd0;
    REG_DATA[ 8] = 16'd0;
    REG_DATA[ 9] = 16'd0;
    REG_DATA[10] = 16'd0;
    REG_DATA[11] = 16'd0;
    REG_DATA[12] = 16'd0;
    REG_DATA[13] = 16'd0;
    REG_DATA[14] = 16'd0;
    REG_DATA[15] = 16'd0;
end

assign Rn_data = REG_DATA[Rn];
assign Rm_data = REG_DATA[Rm];
assign Rs_data = REG_DATA[Rs];
assign PC = REG_DATA[15];

always @(posedge clk) begin
    if (latch_reg == 1) REG_DATA[Rd] <= data_in;
end

endmodule