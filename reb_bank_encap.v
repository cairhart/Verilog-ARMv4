`include "reg_bank.v"

module RegBankEncapsulation(
    input clk,
    input LATCH_REG,
    input PC_MUX,
    input RD_MUX,
    input DATA_MUX,
    input REG_GATE_A,
    input REG_GATE_B,
    input REG_GATE_C,
    input [31:0] IR,
    input [31:0] ALU_BUS,

    output [31:0] A_BUS,
    output [31:0] B_BUS,
    output [31:0] C_BUS
);

wire [31:0] Rn_data, Rm_data, Rs_data, PC;

wire [3:0] Rn = (RD_MUX == 1) ? IR[19:16] : IR[15:12];
wire [3:0] Rd = (PC_MUX == 1) ? 4'd15
              : (RD_MUX == 1) ? IR[15:12]
                              : IR[19:16];

wire [31:0] data_in = (DATA_MUX == 1) ? ALU_BUS : PC + 4;

RegBank _(
    // Inputs
    .clk(clk),
    .latch_reg(LATCH_REG),
    .Rd(Rd),
    .Rn(Rn),
    .Rm(IR[3:0]),
    .Rs(IR[11:8]),
    .data_in(data_in),
    // Outputs
    .Rn_data(Rn_data),
    .Rm_data(Rm_data),
    .Rs_data(Rs_data),
    .PC(PC)
);

endmodule