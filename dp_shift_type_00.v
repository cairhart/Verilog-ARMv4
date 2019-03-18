module DPShiftType00(
    input   [7:0] shift_amt,
    input  [31:0] Rm_data,
    input         is_DPIS,
    input         is_DPRS,
    input         C,

    output [32:0] shift_res_00
);

wire [32:0] mux1_res = (shift_amt == 0) ? {C, Rm_data}
                                        : {Rm_data[32 - shift_amt], Rm_data << shift_amt};


wire mux2_res = (shift_amt > 32) ? 0 : Rm_data[0];

wire [32:0] mux3_res = (shift_amt >= 32) ? {mux2_res, 32'b0} : mux1_res;

assign shift_res_00 = (is_DPIS == 1) ? mux1_res : mux3_res;

endmodule