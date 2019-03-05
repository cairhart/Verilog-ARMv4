module DPShiftType11(
    input   [7:0] shift_amt,
    input  [31:0] Rm_data,
    input         is_DPIS,
    input         is_DPRS,
    input         C,

    output [32:0] shift_res_11
);

wire [63:0] Rm_data_double = {Rm_data, Rm_data};
wire [63:0] rotate_output = Rm_data_double >> shift_amt;
wire [31:0] rot_res = rotate_output[31:0];

wire [32:0] mux1_res = (shift_amt == 0) ? {Rm_data[0], C, Rm_data[31:1]}
                                        : {Rm_data[shift_amt - 1], rot_res};

wire [32:0] mux2_res = (shift_amt == 0) ? {C, Rm_data}
                                        : {Rm_data[shift_amt - 1], rot_res};

wire [32:0] mux3_res = (shift_amt[7:5] != 0 && shift_amt[4:0] == 0)
                        ? {Rm_data[31], Rm_data}
                        : mux2_res;

assign shift_res_11 = (is_DPIS == 1) ? mux1_res : mux3_res;

endmodule