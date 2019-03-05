module DPShiftType01(
    input   [7:0] shift_amt,
    input  [31:0] Rm_data,
    input         is_DPIS,
    input         is_DPRS,
    input         C,

    output [32:0] shift_res_01
);

wire [32:0] mux1_res = (is_DPIS == 1) ? {Rm_data[31], 32'b0} : {C, Rm_data};

wire [32:0] mux2_res = (shift_amt == 0) ? mux1_res
                                        : {Rm_data[shift_amt - 1], Rm_data >> shift_amt};

wire mux3_res = (shift_amt > 32) ? 0 : Rm_data[0];

wire [32:0] mux4_res = (shift_amt >= 32) ? {mux3_res, 32'b0} : mux2_res;

assign shift_res_01 = (is_DPIS == 1) ? mux2_res : mux4_res;

endmodule