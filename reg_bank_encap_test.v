`include "reg_bank_encap.v"

module RegBankEncapsulation_Test;

integer failcount;
wire [31:0] A_BUS, B_BUS, C_BUS;

task check_status;
input [511:0] expected_reg_bits;
input [31:0] expected_A_BUS;
input [31:0] expected_B_BUS;
input [31:0] expected_C_BUS;
reg [511:0] expected_reg_bits_shifted;
reg [31:0] expected_reg_data;
integer i;
begin
    $write("t=%0t\n", $time);
    $write("--------\n");
    $write("\tRn=%0d, Rm=%0d, Rs=%0d\n", reg_bank_encap.reg_bank.Rn, reg_bank_encap.reg_bank.Rm, reg_bank_encap.reg_bank.Rs);
    $write("\tRn_data=0x%0H, Rm_data=0x%0H, Rs_data=0x%0H, PC=0x%0H\n", reg_bank_encap.reg_bank.Rn_data, reg_bank_encap.reg_bank.Rm_data, reg_bank_encap.reg_bank.Rs_data, reg_bank_encap.reg_bank.PC);
    $write("\tRd=%0d, latch_reg=%0b, data_in=0x%0H\n", reg_bank_encap.reg_bank.Rd, reg_bank_encap.reg_bank.latch_reg, reg_bank_encap.reg_bank.data_in);
    $write("\n");
    for (i = 0; i < 13; i = i + 1) begin
        expected_reg_bits_shifted = expected_reg_bits >> ((15-i) * 32);
        expected_reg_data = expected_reg_bits_shifted[31:0];
        $write("\t     R%-2d = 0x%H = %-d\t", i, reg_bank_encap.reg_bank.REG_DATA[i], reg_bank_encap.reg_bank.REG_DATA[i]);
        if (expected_reg_data == reg_bank_encap.reg_bank.REG_DATA[i]) $write("+ passed\n");
        else begin $write("- FAILED (expected 0x%H)\n", expected_reg_data); failcount = failcount + 1; end
    end
    $write("\t(SP) R13 = 0x%H\t\t\t", reg_bank_encap.reg_bank.REG_DATA[13]);
    if (expected_reg_bits[95:64] == reg_bank_encap.reg_bank.REG_DATA[13]) $write("+ passed\n");
    else begin $write("- FAILED (expected 0x%H)\n", expected_reg_bits[95:64]); failcount = failcount + 1; end
    $write("\t(LR) R14 = 0x%H\t\t\t", reg_bank_encap.reg_bank.REG_DATA[14]);
    if (expected_reg_bits[63:32] == reg_bank_encap.reg_bank.REG_DATA[14]) $write("+ passed\n");
    else begin $write("- FAILED (expected 0x%H)\n", expected_reg_bits[63:32]); failcount = failcount + 1; end
    $write("\t(PC) R15 = 0x%H\t\t\t", reg_bank_encap.reg_bank.REG_DATA[15]);
    if (expected_reg_bits[31:0] == reg_bank_encap.reg_bank.REG_DATA[15]) $write("+ passed\n");
    else begin $write("- FAILED (expected 0x%H)\n", expected_reg_bits[31:0]); failcount = failcount + 1; end
    $write("\n");
    $write("\t   A_BUS = 0x%H\t\t\t", A_BUS);
    if (expected_A_BUS === A_BUS) $write("+ passed\n");
    else begin $write("- FAILED (expected 0x%H)\n", expected_A_BUS); failcount = failcount + 1; end
    $write("\t   B_BUS = 0x%H\t\t\t", B_BUS);
    if (expected_B_BUS === B_BUS) $write("+ passed\n");
    else begin $write("- FAILED (expected 0x%H)\n", expected_B_BUS); failcount = failcount + 1; end
    $write("\t   C_BUS = 0x%H\t\t\t", C_BUS);
    if (expected_C_BUS === C_BUS) $write("+ passed\n");
    else begin $write("- FAILED (expected 0x%H)\n", expected_C_BUS); failcount = failcount + 1; end
    $write("\n");
end
endtask

reg clk;
reg LATCH_REG;
reg PC_MUX;
reg RD_MUX;
reg DATA_MUX;
reg REG_GATE_A;
reg REG_GATE_B;
reg REG_GATE_C;
reg [31:0] IR;
reg [31:0] ALU_BUS;

RegBankEncapsulation reg_bank_encap(
    // Inputs
    .clk(clk),
    .LATCH_REG(LATCH_REG),
    .PC_MUX(PC_MUX),
    .RD_MUX(RD_MUX),
    .DATA_MUX(DATA_MUX),
    .REG_GATE_A(REG_GATE_A),
    .REG_GATE_B(REG_GATE_B),
    .REG_GATE_C(REG_GATE_C),
    .IR(IR),
    .ALU_BUS(ALU_BUS),
    // Outputs
    .A_BUS(A_BUS),
    .B_BUS(B_BUS),
    .C_BUS(C_BUS)
);

always #10 clk = ~clk;

initial begin
    failcount = 0;
    clk = 0;

    $display("check initial state where Ri = i+1 and PC (R15) = 0x3000\n");

    IR = 32'h00000000;
    LATCH_REG = 1;
    REG_GATE_A = 0;
    REG_GATE_B = 0;
    REG_GATE_C = 0;
    ALU_BUS = 32'hDEADBEEF;
    RD_MUX = 1;
    PC_MUX = 0;
    DATA_MUX = 1;

    #1

    check_status({
        32'd1,        // R0
        32'd2,        // R1
        32'd3,        // R2
        32'd4,        // R3
        32'd5,        // R4
        32'd6,        // R5
        32'd7,        // R6
        32'd8,        // R7
        32'd9,        // R8
        32'd10,       // R9
        32'd11,       // R10
        32'd12,       // R11
        32'd13,       // R12
        32'd14,       // R13
        32'd15,       // R14
        32'h3000      // R15
    },
        32'bZ,        // A_BUS
        32'bZ,        // B_BUS
        32'bZ         // C_BUS
    );

    $display("increment PC by 4 and gating it onto B_BUS only (i.e. Rm = 15)\n");

    IR = 32'h0000000F;
    LATCH_REG = 1;
    REG_GATE_A = 0;
    REG_GATE_B = 1;
    REG_GATE_C = 0;
    ALU_BUS = 32'hDEADBEEF;
    RD_MUX = 1;
    PC_MUX = 1;
    DATA_MUX = 0;

    #20

    check_status({
        32'd1,        // R0
        32'd2,        // R1
        32'd3,        // R2
        32'd4,        // R3
        32'd5,        // R4
        32'd6,        // R5
        32'd7,        // R6
        32'd8,        // R7
        32'd9,        // R8
        32'd10,       // R9
        32'd11,       // R10
        32'd12,       // R11
        32'd13,       // R12
        32'd14,       // R13
        32'd15,       // R14
        32'h3004      // R15
    },
        32'bZ,        // A_BUS
        32'h3004,     // B_BUS
        32'bZ         // C_BUS
    );

    $display("repeat previous test one more time but put PC on A_BUS only (i.e. Rn = 15)\n");


    IR = 32'h000F0000;
    LATCH_REG = 1;
    REG_GATE_A = 1;
    REG_GATE_B = 0;
    REG_GATE_C = 0;
    ALU_BUS = 32'hDEADBEEF;
    RD_MUX = 1;
    PC_MUX = 1;
    DATA_MUX = 0;

    #20

    check_status({
        32'd1,        // R0
        32'd2,        // R1
        32'd3,        // R2
        32'd4,        // R3
        32'd5,        // R4
        32'd6,        // R5
        32'd7,        // R6
        32'd8,        // R7
        32'd9,        // R8
        32'd10,       // R9
        32'd11,       // R10
        32'd12,       // R11
        32'd13,       // R12
        32'd14,       // R13
        32'd15,       // R14
        32'h3008      // R15
    },
        32'h3008,     // A_BUS
        32'bZ,        // B_BUS
        32'bZ         // C_BUS
    );

    $display("keep params same but set LATCH_REG=0 to make sure PC isn't incremented. Also put PC on C_BUS (i.e. Rs = 15)\n");

    IR = 32'h00000F00;
    LATCH_REG = 0;
    REG_GATE_A = 0;
    REG_GATE_B = 0;
    REG_GATE_C = 1;
    ALU_BUS = 32'hDEADBEEF;
    RD_MUX = 1;
    PC_MUX = 1;
    DATA_MUX = 0;

    #20

    check_status({
        32'd1,        // R0
        32'd2,        // R1
        32'd3,        // R2
        32'd4,        // R3
        32'd5,        // R4
        32'd6,        // R5
        32'd7,        // R6
        32'd8,        // R7
        32'd9,        // R8
        32'd10,       // R9
        32'd11,       // R10
        32'd12,       // R11
        32'd13,       // R12
        32'd14,       // R13
        32'd15,       // R14
        32'h3008      // R15
    },
        32'bZ,        // A_BUS
        32'bZ,        // B_BUS
        32'h3008      // C_BUS
    );

    $display("try to put spoofed data from ALU (0xDEADBEEF) into R11. Gate nothing onto the buses\n");

    IR = 32'h0000B000;
    LATCH_REG = 1;
    REG_GATE_A = 0;
    REG_GATE_B = 0;
    REG_GATE_C = 0;
    ALU_BUS = 32'hDEADBEEF;
    RD_MUX = 1;
    PC_MUX = 0;
    DATA_MUX = 1;

    #20

    check_status({
        32'd1,        // R0
        32'd2,        // R1
        32'd3,        // R2
        32'd4,        // R3
        32'd5,        // R4
        32'd6,        // R5
        32'd7,        // R6
        32'd8,        // R7
        32'd9,        // R8
        32'd10,       // R9
        32'd11,       // R10
        32'hDEADBEEF, // R11
        32'd13,       // R12
        32'd14,       // R13
        32'd15,       // R14
        32'h3008      // R15
    },
        32'bZ,        // A_BUS
        32'bZ,        // B_BUS
        32'bZ         // C_BUS
    );

    $display("now we're going to simulate R5 <- R8 + R1");
    $display("first we put R8 on the A_BUS and R1 on the B_BUS");
    $display("(notice that only a little time has passed since this whole operation needs to happen in one cycle)\n");

    IR = 32'h00085001;
    LATCH_REG = 1;
    REG_GATE_A = 1;
    REG_GATE_B = 1;
    REG_GATE_C = 0;
    ALU_BUS = 32'hDEADBEEF;
    RD_MUX = 1;
    PC_MUX = 0;
    DATA_MUX = 1;

    #1

    check_status({
        32'd1,        // R0
        32'd2,        // R1
        32'd3,        // R2
        32'd4,        // R3
        32'd5,        // R4
        32'd6,        // R5
        32'd7,        // R6
        32'd8,        // R7
        32'd9,        // R8
        32'd10,       // R9
        32'd11,       // R10
        32'hDEADBEEF, // R11
        32'd13,       // R12
        32'd14,       // R13
        32'd15,       // R14
        32'h3008      // R15
    },
        32'd9,        // A_BUS
        32'd2,        // B_BUS
        32'bZ         // C_BUS
    );

    $display("now we'll spoof the ALU operation by loading the ALU_BUS with the expected value");
    $display("after that we'll latch it into Rd=R5\n");

    IR = 32'h00085001;
    LATCH_REG = 1;
    REG_GATE_A = 1;
    REG_GATE_B = 1;
    REG_GATE_C = 0;
    ALU_BUS = A_BUS + B_BUS;
    RD_MUX = 1;
    PC_MUX = 0;
    DATA_MUX = 1;

    #20

    check_status({
        32'd1,        // R0
        32'd2,        // R1
        32'd3,        // R2
        32'd4,        // R3
        32'd5,        // R4
        32'd11,       // R5
        32'd7,        // R6
        32'd8,        // R7
        32'd9,        // R8
        32'd10,       // R9
        32'd11,       // R10
        32'hDEADBEEF, // R11
        32'd13,       // R12
        32'd14,       // R13
        32'd15,       // R14
        32'h3008      // R15
    },
        32'd9,        // A_BUS
        32'd2,        // B_BUS
        32'bZ         // C_BUS
    );

    $display("now we're going to simulate R14 (LR) <- R2 + R7");
    $display("(this instruction reverses Rn and Rd in the bit layout)");
    $display("first we put R2 on the A_BUS and R7 on the B_BUS");
    $write("(note that a multiply takes 2 cycles, and we're going to simulate that by delaying latching even");
    $write("  though we aren't actually using a multiply unit to accurate spoof it's functionality)\n\n");

    IR = 32'h000E2007;
    LATCH_REG = 0;
    REG_GATE_A = 1;
    REG_GATE_B = 1;
    REG_GATE_C = 0;
    ALU_BUS = 32'hDEADBEEF;
    RD_MUX = 0;
    PC_MUX = 0;
    DATA_MUX = 1;

    #20

    check_status({
        32'd1,        // R0
        32'd2,        // R1
        32'd3,        // R2
        32'd4,        // R3
        32'd5,        // R4
        32'd11,       // R5
        32'd7,        // R6
        32'd8,        // R7
        32'd9,        // R8
        32'd10,       // R9
        32'd11,       // R10
        32'hDEADBEEF, // R11
        32'd13,       // R12
        32'd14,       // R13
        32'd15,       // R14
        32'h3008      // R15
    },
        32'd3,        // A_BUS
        32'd8,        // B_BUS
        32'bZ         // C_BUS
    );

    IR = 32'h000E2007;
    LATCH_REG = 1;
    REG_GATE_A = 1;
    REG_GATE_B = 1;
    REG_GATE_C = 0;
    ALU_BUS = A_BUS * B_BUS;
    RD_MUX = 0;
    PC_MUX = 0;
    DATA_MUX = 1;

    $display("A cycle has passed, so now, we latch!\n");

    #20

    check_status({
        32'd1,        // R0
        32'd2,        // R1
        32'd3,        // R2
        32'd4,        // R3
        32'd5,        // R4
        32'd11,       // R5
        32'd7,        // R6
        32'd8,        // R7
        32'd9,        // R8
        32'd10,       // R9
        32'd11,       // R10
        32'hDEADBEEF, // R11
        32'd13,       // R12
        32'd14,       // R13
        32'd24,       // R14
        32'h3008      // R15
    },
        32'd3,        // A_BUS
        32'd8,        // B_BUS
        32'bZ         // C_BUS
    );

    $write("\n");
    if (failcount > 0) $write("%d test(s) failed\n", failcount);
    else $write("          all tests passed! 🎉\n");

    $finish;
end

endmodule