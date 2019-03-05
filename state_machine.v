`include "16_4_encoder.v"

module StateMachine(
    input clk,
    input [15:0] family_bits
);

reg   [6:0] address;
reg  [63:0] control_store [0:127];

wire [63:0] CS_BITS = control_store[address];
wire  [7:0] J       = CS_BITS[12:6];
wire  [1:0] COND    = CS_BITS[5:4];
wire        DEC     = CS_BITS[3];
wire        L       = CS_BITS[2];
wire        P       = CS_BITS[1];
wire        A       = CS_BITS[0];

wire J2_toggle =  COND[1] &  COND[0] & L;
wire J1_toggle =  COND[1] & ~COND[0] & P;
wire J0_toggle = ~COND[1] &  COND[0] & A;
wire [6:0] jump_target = {J[6:3], J[2] | J2_toggle, J[1] | J1_toggle, J[0] | J0_toggle};

wire [3:0] family_number;
Encoder16To4 inst(
    .bits(family_bits),
    .number(family_number)
);
wire [6:0] decode_target = {family_number, 3'b0};

always @(posedge clk) begin
    address <= (DEC == 1) ? decode_target : jump_target;
end

endmodule