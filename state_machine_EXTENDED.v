`include "16_4_encoder.v"

module StateMachineEXTENDED(
    input           clk,
    input           rst,
    input   [3:0]   family_number,
    input           COND,
    input           ST,
    input           PL,
    input           A,
    input           IR_20,
    input           MEM_R,
    input           RM_CNTR_DONE,
    input   [1:0]   OP,
    input           Z,

    output [63:0]   CS_BITS
);

reg  [6:0] address;
reg [63:0] control_store [0:127];

initial begin
    address <= 7'd104;
    $readmemb("cs_bits.mem", control_store);
end

assign CS_BITS = control_store[address];
wire [7:0] J             = CS_BITS[63:57];
wire [1:0] MOD           = CS_BITS[56:55];
wire       DEC           = CS_BITS[54];
wire       EVCOND        = CS_BITS[53];
wire       CS            = CS_BITS[40];
wire       VEC_OP_BR     = CS_BITS[17];
wire       DOT_PROD_RST  = CS_BITS[16];
wire       RM_CNTR_JMP   = CS_BITS[15];
wire       RM_CNTR_LOOP  = CS_BITS[14];

wire J3_toggle =  DOT_PROD_RST &  Z;
wire J2_toggle =  (MOD[1] &  MOD[0] & ST) | (VEC_OP_BR & OP[1]);
wire J1_toggle =  (MOD[1] & ~MOD[0] & PL) | (VEC_OP_BR & OP[0]);
wire J0_toggle = ~MOD[1] &  MOD[0] & A;
wire [6:0] jump_target = {J[6:4], J[3] | J3_toggle, J[2] | J2_toggle, J[1] | J1_toggle, J[0] | J0_toggle};

wire [3:0] family_code = (family_number == 5 ||
                             family_number ==  6 ||
                             family_number ==  7 ||
                             family_number == 15)
                             ? 4'b1110
                             : (family_number == 8 ||
                                family_number ==  9 ||
                                family_number == 10 ||
                                family_number == 11)
                                ? 4'b0101
                                : (family_number == 12)
                                  ? 4'b1000
                                  : (family_number == 13)
                                    ? 4'b1001
                                    : (family_number == 14)
                                       ? 4'b0111
                                       : family_number;

wire [6:0] decode_target = {family_code, 3'b0};

wire [6:0] non_fetch_address = (DEC == 1) ? decode_target : jump_target;
wire [6:0] next_state_address = (COND == 0 && EVCOND == 1) ? 7'd104 : non_fetch_address;
wire [6:0] next_state_final = (RM_CNTR_JMP == 1 && RM_CNTR_DONE == 1) ? 7'd104: next_state_address;

always @(posedge clk) begin
    if (family_code == 4'b1111) $finish;
    if (rst == 1) begin
        address <= 7'd104; // Reset to fetch state
    end
    else if(!(CS && !MEM_R) && !(RM_CNTR_LOOP && !RM_CNTR_DONE)) begin
        address <= next_state_final;
    end
end

endmodule
