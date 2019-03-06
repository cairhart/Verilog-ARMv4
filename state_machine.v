`include "16_4_encoder.v"

module StateMachine(
    input clk,
    input [15:0] family_bits,
    input COND,
    input L,
    input P,
    input A,

    output [63:0] CS_BITS
);

reg   [6:0] address;
reg  [63:0] control_store [0:127];

initial begin
    address <= 7'd104;
    $readmemb("cs_bits.mem", control_store);
end

assign CS_BITS = control_store[address];
wire  [7:0] J       = CS_BITS[63:57];
wire  [1:0] MOD     = CS_BITS[56:55];
wire        DEC     = CS_BITS[54];
wire        EVCOND  = CS_BITS[53];

wire J2_toggle =  MOD[1] &  MOD[0] & L;
wire J1_toggle =  MOD[1] & ~MOD[0] & P;
wire J0_toggle = ~MOD[1] &  MOD[0] & A;
wire [6:0] jump_target = {J[6:3], J[2] | J2_toggle, J[1] | J1_toggle, J[0] | J0_toggle};

wire [3:0] family_number;
Encoder16To4 _(
    .bits(family_bits),
    .number(family_number)
);
wire [6:0] decode_target = {family_number, 3'b0};

wire [6:0] non_fetch_address = (DEC == 1) ? decode_target : jump_target;
wire [6:0] next_state_address = (COND == 0 && EVCOND == 1) ? 7'd104 : non_fetch_address;

always @(posedge clk) begin
    address <= next_state_address;
end

endmodule