`include "reg_bank.v"

module RegBankEncapsulationEXTENDED(
    input clk,
    input rst,
    input LATCH_REG,
    input WRITE_BACK,
    input IR_RD_MUX,
    input IR_RN_MUX,
    input [1:0] IR_RM_MUX,
    input [1:0] RD_MUX,
    input PC_MUX,
    input DATA_MUX,
    input REG_GATE_B,
    input REG_GATE_C,
    input [31:0] IR,
    input [31:0] ALU_BUS,
    input is_DPI,
    input is_DPIS,
    input is_DPRS,
    input [1:0] RST_RM_CNTR,
    input RST_RS_CNTR,
    input [1:0] RST_RD_CNTR,
    input LATCH_RM_CNTR,
    input LATCH_RD_CNTR,
    input LATCH_RS_CNTR,
    input RN_MUX,
    input RS_MUX,
    input RST_REG,

    output [31:0] A_BUS,
    output [31:0] B_BUS,
    output [31:0] C_BUS,

    output [31:0] ST,
    output [31:0] PC,

    output RM_CNTR_DONE
);

reg [3:0] Rm_counter;
reg [3:0] Rs_counter;
reg [3:0] Rd_counter;

wire [3:0] Rn = (RN_MUX == 1)
                ?   Rd_counter
                :   (PC_MUX == 1)
                    ?   4'd15
                    :   (IR_RN_MUX == 1)
                        ?   IR[19:16]
                        :   IR[15:12];

wire [3:0] Rm = (IR_RM_MUX == 0)
                ?   IR[3:0]
                :   (IR_RM_MUX == 1)
                    ?   IR[15:12]
                    :   (IR_RM_MUX == 2)
                        ?   IR[19:16]
                        :   Rm_counter;

wire [3:0] Rd = (RD_MUX == 0)
                ?   (IR_RD_MUX == 1)
                    ?   IR[15:12]
                    :   IR[19:16]
                :   (RD_MUX == 1)
                    ?   4'd15
                    :   (RD_MUX == 2)
                        ?   4'd14
                        :   Rd_counter;

wire [3:0] Rs = (RS_MUX == 1)
                ?   Rs_counter
                :   IR[11:8];

wire [31:0] data_in =   (RST_REG == 1)
                        ?   32'd0
                        :   (DATA_MUX == 1)
                            ?   ALU_BUS
                            :   PC + 4;

wire is_CMP_Family = (is_DPI | is_DPIS | is_DPRS) & IR[24] & ~IR[23];
wire latch_signal = (LATCH_REG & ~is_CMP_Family) | (WRITE_BACK & IR[21]);

wire [3:0] next_Rs_counter_val =    (RST_RS_CNTR == 0)
                                    ?   Rs_counter + 1
                                    :   (IR[24:23] == 2'd2)
                                        ?   4'd11
                                        :   (IR[21] == 1)
                                            ?   4'd0
                                            :   4'd5;

reg [3:0] next_Rm_counter_val;
reg [3:0] next_Rd_counter_val;

always @(*) begin
    case (RST_RM_CNTR)
        2'd0: next_Rm_counter_val <= Rm_counter + 1;
        2'd1: next_Rm_counter_val <= 4'd0;
        2'd2: next_Rm_counter_val <= 4'd5;
        2'd3: next_Rm_counter_val <= 4'd0;
    endcase

    case (RST_RD_CNTR)
        2'd0: next_Rd_counter_val <= Rd_counter + 1;
        2'd1: next_Rd_counter_val <= 4'd0;
        2'd2: next_Rd_counter_val <= 4'd10;
        2'd3: next_Rd_counter_val <= 4'd0;
    endcase
end

always @(posedge clk) begin
    if (LATCH_RM_CNTR) Rm_counter <= next_Rm_counter_val;
    if (LATCH_RS_CNTR) Rs_counter <= next_Rs_counter_val;
    if (LATCH_RD_CNTR) Rd_counter <= next_Rd_counter_val;
end

wire [31:0] Rn_data, Rm_data, Rs_data;

RegBank reg_bank(
    // Inputs
    .clk(clk),
    .latch_reg(latch_signal),
    .rst(rst),
    .Rd(Rd),
    .Rn(Rn),
    .Rm(Rm),
    .Rs(Rs),
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

assign RM_CNTR_DONE = (Rm_counter == 4) || (Rm_counter == 8);

endmodule
