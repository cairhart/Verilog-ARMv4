`include "state_machine_EXTENDED.v"

module StateMachine_Test;

integer failcount;

task check_status;
input [6:0] expected;
begin
    $write("t=%0t\t", $time);
    $write("state=%d\t", state_machine.address);
    $write("IR=%h, ", IR);
    $write("EVCOND=%d, ", state_machine.EVCOND);
    $write("COND=%d, ", state_machine.COND);
    $write("MOD=%b, ", state_machine.MOD);
    $write("DEC=%b, ", state_machine.DEC);
    $write("P/L=%b, ", state_machine.PL);
    $write("A=%b, ", state_machine.A);
    $write("MEM_R=%b", state_machine.MEM_R);
    $write("\t\t\t\t");
    if (state_machine.address == expected) $write("+ pass");
    else begin
        $write("- FAIL (expected state=%0d)", expected);
        failcount = failcount + 1;
    end
    $write("\n");
    $write("\t\t\t");
    $write("is_VEC=%b, ", state_machine.is_VEC);
    $write("OP=%b, ", state_machine.OP);
    $write("VEC_OP_BR=%b", state_machine.VEC_OP_BR);
    $write("\n");
    $write("\t\t\t");
    $write("DOT_PROD_RST=%b, ", state_machine.DOT_PROD_RST);
    $write("RM_CNTR=%d, ", RM_CNTR);
    $write("RM_CNTR_DONE=%b, ", state_machine.RM_CNTR_DONE);
    $write("RM_CNTR_JMP=%b, ", state_machine.RM_CNTR_JMP);
    $write("RM_CNTR_LOOP=%b", state_machine.RM_CNTR_LOOP);
    $write("\n");
    $write("\t\t\t");
    $write("J3_toggled=%b, ", state_machine.J3_toggled);
    $write("J2_toggled=%b, ", state_machine.J2_toggled);
    $write("J1_toggled=%b, ", state_machine.J1_toggled);
    $write("J0_toggled=%b", state_machine.J0_toggled);
    $write("\n");
    $write("\t\t\t");
    $write("J=%d, ", state_machine.J);
    $write("jump_target=%d", state_machine.jump_target);
    $write("\n");
    $write("\t\t\t");
    $write("DT2_toggled=%b, ", state_machine.dt2_toggled);
    $write("DT1_toggled=%b", state_machine.dt1_toggled);
    $write("\n");
    $write("\t\t\t");
    $write("family_number=%d, ", state_machine.family_number);
    $write("decode_target=%d, ", state_machine.decode_target);
    $write("decode_target_modified=%d", state_machine.decode_target_modified);
    $write("\n");
    $write("\t\t\t");
    $write("decode_mux=%d, ", state_machine.decode_mux);
    $write("cond_mux=%d, ", state_machine.cond_mux);
    $write("vec_loop_mux=%d", state_machine.vec_loop_mux);
    $write("\n\n");
end
endtask

reg clk;
reg rst;
reg [31:0] IR;
reg [3:0] family_number;
reg COND;
reg MEM_R;
reg is_VEC;
reg [3:0] RM_CNTR;

wire ST = IR[20];
wire P = IR[24];
wire A = IR[21];
wire [1:0] OP = IR[24:23];
wire Z = IR[22];
wire RM_CNTR_DONE = (RM_CNTR == 4 || RM_CNTR == 9);

StateMachineEXTENDED state_machine(
    // Inputs
    .clk(clk),
    .rst(rst),
    .COND(COND),
    .ST(ST),
    .PL(P),
    .A(A),
    .MEM_R(MEM_R),
    .family_number(family_number),
    .OP(OP),
    .Z(Z),
    .RM_CNTR_DONE(RM_CNTR_DONE),
    .is_VEC(is_VEC)
);

always #10 clk = ~clk;

initial begin
    family_number = 4'd15;
    COND = 1;
    clk = 0;
    rst = 0;
    MEM_R = 1;
    is_VEC = 1;
    RM_CNTR = 0;
    failcount = 0;

    $display("testing dot poduct (with zeroing Rd)\n");
    #1  check_status(104);
    #20 check_status(105);
    #20 IR = 32'h06C00010;
    #0  check_status(106);
    #20 check_status(114);
    #20 RM_CNTR = 0;
    #0  check_status(121);
    #20 check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(104);

    $display("resetting to fetch");
    $display("testing dot poduct (without zeroing Rd)\n");
    rst = 1; #20 rst = 0;
    check_status(104);
    #20 check_status(105);
        IR = 32'h06800010;
    #20 check_status(106);
    #20 check_status(114);
    #20 RM_CNTR = 0;
    #0  check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(115);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(104);

    $display("resetting to fetch");
    $display("testing vector/scalar multiplication\n");
    rst = 1; #20 rst = 0;
    check_status(104);
    #20 check_status(105);
        IR = 32'h07000010;
    #20 check_status(106);
    #20 check_status(116);
    #20 RM_CNTR = 0;
    #0  check_status(113);
    #20 check_status(117);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(117);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(117);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(117);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(113);
    #20 check_status(117);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(104);

    $display("resetting to fetch");
    $display("testing vector addition\n");
    rst = 1; #20 rst = 0;
    check_status(104);
    #20 check_status(105);
        IR = 32'h07800010;
    #20 check_status(106);
    #20 check_status(118);
    #20 RM_CNTR = 5;
    #0  check_status(119);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(119);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(119);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(119);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(119);
    #20 RM_CNTR = RM_CNTR + 1;
    #0  check_status(104);

    $write("\n");
    if (failcount > 0) $write("%d tests failed\n", failcount);
    else $write("          all tests passed! 🎉\n");

    $finish;
end

endmodule