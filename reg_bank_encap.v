`include "reg_bank.v"

module RegBankEncapsulation(
    input clk,
    input rst,
    input LATCH_REG,
    input WRITE_BACK,
    input IR_RD_MUX,
    input IR_RN_MUX,
    input IR_RM_MUX,
    input LSM_RD_MUX,
    input [1:0] RD_MUX,
    input PC_MUX,
    input DATA_MUX,
    input REG_GATE_B,
    input REG_GATE_C,
    input [31:0] IR,
    input [31:0] ALU_BUS,
    input [ 3:0] REG_COUNTER,

    output [31:0] A_BUS,
    output [31:0] B_BUS,
    output [31:0] C_BUS,

    output [31:0] ST,
    output [31:0] PC
);

wire [31:0] Rn_data, Rm_data, Rs_data;

wire [3:0] Rn = (PC_MUX == 1)
                ? 4'd15
                : (IR_RN_MUX == 1)
                    ? IR[19:16]
                    : IR[15:12];

wire [3:0] Rm = (IR_RM_MUX == 1)
                ? IR[15:12]
                : IR[3:0];

wire [3:0] Rd = (RD_MUX == 0)
                ?   (IR_RD_MUX == 1)
                    ?   IR[15:12]
                    :   IR[19:16]
                :   (RD_MUX == 1)
                    ?   4'd15
                    :   (RD_MUX == 2)
                        ?   4'd14
                        :   4'd14;

wire [31:0] data_in = (DATA_MUX == 1) ? ALU_BUS : PC + 4;

wire latch_signal = LATCH_REG || (WRITE_BACK && IR[21]);

RegBank reg_bank(
    // Inputs
    .clk(clk),
    .latch_reg(latch_signal),
    .rst(rst),
    .Rd(Rd),
    .Rn(Rn),
    .Rm(Rm),
    .Rs(IR[11:8]),
    .data_in(data_in),
    // Outputs
    .Rn_data(Rn_data),
    .Rm_data(Rm_data),
    .Rs_data(Rs_data),
    .ST(ST),
    .PC(PC)
);

assign A_BUS = Rn_data;
assign B_BUS = (REG_GATE_B == 1) ? Rm_data : 32'bZ;
assign C_BUS = (REG_GATE_C == 1) ? Rs_data : 32'bZ;

endmodule
