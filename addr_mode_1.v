`include "dp_shift_type_00.v"
`include "dp_shift_type_01.v"
`include "dp_shift_type_10.v"
`include "dp_shift_type_11.v"

module AddrMode1 (
    input  [31:0] IR,
    input   [7:0] Rs_LSB,
    input  [31:0] Rm_data,
    input         is_DPI,       // data processing immediate
    input         is_DPIS,      // data processing immediate shift
    input         is_DPRS,      // data processing register shift
    input         is_LSIO,      // load/store immediate offset
    input         is_LSHSBCO,   // load/store halfword/signed byte combined offset
    input         is_LSHSBSO,   // load/store halfword/signed byte shifted offset
    input         is_BL,        // branch/branch and link
    input         is_pass_thru, // pass Rm_data through
    input         C,

    output [31:0] shifter_operand,
    output        shifter_carry
);

wire [7:0]  shift_amt = (is_DPRS == 1) ? Rs_LSB : {{3{1'b0}}, IR[11:7]};
wire [1:0]  shift_code = IR[6:5];

// Generate DPI shifter operand

wire [7:0] imm = IR[7:0];
wire [63:0] imm_double = {{24{1'b0}}, IR[7:0], {24{1'b0}}, IR[7:0]};
wire [4:0] rot_amt = IR[11:8] << 1;
wire [63:0] rot_intermediate = imm_double >> rot_amt;
wire [31:0] rot_value = rot_intermediate[31:0];
wire rot_carry = (rot_amt == 0) ? C : rot_value[31];
wire [32:0] rot_res = {rot_carry, rot_value};

// DPIS and DPRS shifter operands

wire [32:0] shift_res_00;
wire [32:0] shift_res_01;
wire [32:0] shift_res_10;
wire [32:0] shift_res_11;

DPShiftType00 inst1(
    // Inputs
    .shift_amt(shift_amt),
    .Rm_data(Rm_data),
    .is_DPIS(is_DPIS),
    .is_DPRS(is_DPRS),
    .C(C),
    // Outputs
    .shift_res_00(shift_res_00)
);

DPShiftType01 inst2(
    // Inputs
    .shift_amt(shift_amt),
    .Rm_data(Rm_data),
    .is_DPIS(is_DPIS),
    .is_DPRS(is_DPRS),
    .C(C),
    // Outputs
    .shift_res_01(shift_res_01)
);

DPShiftType10 inst3(
    // Inputs
    .shift_amt(shift_amt),
    .Rm_data(Rm_data),
    .is_DPIS(is_DPIS),
    .is_DPRS(is_DPRS),
    .C(C),
    // Outputs
    .shift_res_10(shift_res_10)
);

DPShiftType11 inst4(
    // Inputs
    .shift_amt(shift_amt),
    .Rm_data(Rm_data),
    .is_DPIS(is_DPIS),
    .is_DPRS(is_DPRS),
    .C(C),
    // Outputs
    .shift_res_11(shift_res_11)
);

// Select correct shifter operand

reg [32:0] shift_res;
always @(*) begin
    case (shift_code)
        2'b00: shift_res = shift_res_00;
        2'b01: shift_res = shift_res_01;
        2'b10: shift_res = shift_res_10;
        2'b11: shift_res = shift_res_11;
    endcase
end

wire [31:0] load_imm = (is_LSIO == 1) ? {20'b0, IR[11:0]} : {24'b0, IR[11:8], IR[3:0]};

wire [31:0] mux1 =  (is_DPI == 1)
                    ? rot_res[31:0]
                    : shift_res[31:0];

wire [31:0] mux2 =  ((is_LSIO == 1) || (is_LSHSBCO == 1))
                    ? load_imm
                    : mux1;

wire [31:0] mux3 =  (is_BL == 1)
                    ? {8'b0, IR[23:0]}
                    : mux2;

wire [31:0] mux4 =  (is_pass_thru == 1)
                    ? Rm_data
                    : mux3;

assign shifter_operand = mux4;

assign shifter_carry = (is_DPI == 1) ? rot_res[32]
                                     : shift_res[32];

endmodule
