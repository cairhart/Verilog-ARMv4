module DPShiftType10(
    input   [7:0] shift_amt,
    input  [31:0] Rm_data,
    input         is_DPIS,
    input         is_DPRS,
    input         C,

    output [32:0] shift_res_10
);

wire [63:0] Rm_data_sext = {{32{Rm_data[31]}}, Rm_data};
wire [63:0] asr_output = Rm_data_sext >> shift_amt;
wire [31:0] shift_res = asr_output[31:0];

wire [31:0] mux1_res = (Rm_data[31] == 1) ? 32'hffffffff : 32'h0;

wire [32:0] mux2_res = ((is_DPIS == 1 && shift_amt == 0) || (is_DPRS == 1 && shift_amt >= 32))
                        ? {Rm_data[31], mux1_res} : {Rm_data[shift_amt - 1], shift_res};

assign shift_res_10 = (is_DPRS == 1 && shift_amt == 0) ? {C, Rm_data} : mux2_res;

endmodule