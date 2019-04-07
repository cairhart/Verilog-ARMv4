`include "state_machine.v"

module StateMachine_Test;

integer failcount;

task check_status;
input [6:0] expected;
begin
    $write("t=%0t\t", $time);
    $write("state=%d\t", state_machine.address);
    $write("EVCOND=%d, ", state_machine.EVCOND);
    $write("COND=%d, ", state_machine.COND);
    $write("MOD=%b, ", state_machine.MOD);
    $write("DEC=%b, ", state_machine.DEC);
    $write("P/L=%b, ", state_machine.PL);
    $write("A=%b, ", state_machine.A);
    $write("IR_20=%b, ", state_machine.IR_20);
    $write("MEM_R=%b", state_machine.MEM_R);
    $write("\t\t");
    if (state_machine.address == expected) $write("+ pass");
    else begin
        $write("- FAIL (expected state=%0d)", expected);
        failcount = failcount + 1;
    end
    $write("\n");
    $write("\t\t\t");
    $write("J=%d, ", state_machine.J);
    $write("jump_target=%d, ", state_machine.jump_target);
    $write("decode_target=%d, ", state_machine.decode_target);
    $write("non_fetch_address=%d, ", state_machine.non_fetch_address);
    $write("\n");
    $write("\t\t\t");
    $write("next_state_address=%d, ", state_machine.next_state_address);
    $write("next_state_final=%d", state_machine.next_state_final);
    $write("\n\n");
end
endtask

reg clk;
reg rst;
reg [3:0] family_number;
reg COND;
reg P;
reg A;
reg IR_20;
reg MEM_R;

StateMachine state_machine(
    // Inputs
    .clk(clk),
    .rst(rst),
    .COND(COND),
    .PL(P),
    .A(A),
    .IR_20(IR_20),
    .MEM_R(MEM_R),
    .family_number(family_number)
);

always #10 clk = ~clk;

initial begin
    family_number = 4'd0;
    COND = 1;
    P = 0;
    A = 0;
    clk = 0;
    rst = 0;
    IR_20 = 0;
    MEM_R = 1;
    failcount = 0;

    $display("testing fetching, decode, and data processing\n");
     #1 check_status(104);
    #20 check_status(105);
    #20 check_status(106);
    #20 check_status(0);
    #20 check_status(104);

    family_number = 4'd3;

    $display("\ntesting reset to fetch\n");
    rst = 1;
    #20 check_status(104);
    rst = 0;

    $display("\nNOTE: from here on out, we are going to skip testing resetting to fetch and the individual fetch states");

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing multiply\n");
    #20 #20 #20 check_status(24);
    #20 check_status(26);
    #20 check_status(104);

    A = 1;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing multiply accumulate\n");
    #20 #20 #20 check_status(24);
    #20 check_status(27);
    #20 check_status(104);

    A = 0;

    family_number = 4'd4;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing multiply long\n");
    #20 #20 #20 check_status(32);
    #20 check_status(34);
    #20 check_status(36);
    #20 check_status(104);

    A = 1;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing multiply long\n");
    #20 #20 #20 check_status(32);
    #20 check_status(35);
    #20 check_status(37);
    #20 check_status(104);

    family_number = 4'd8;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing load/store word/unsigned byte (post-indexing)\n");
    #20 #20 #20 check_status(40);
    #20 check_status(41);
    #20 check_status(42);
    #20 check_status(44);
    #20 check_status(45);
    #20 check_status(104);

    P = 1;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing load/store word/unsigned byte (pre-indexing)\n");
    #20 #20 #20 check_status(40);
    #20 check_status(43);
    #20 check_status(44);
    #20 check_status(45);
    #20 check_status(104);

    family_number = 4'd9;
    P = 0;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing load/store halfword/signed byte (post-indexing)\n");
    #20 #20 #20 check_status(40);
    #20 check_status(41);
    #20 check_status(42);
    #20 check_status(44);
    #20 check_status(45);
    #20 check_status(104);

    P = 1;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing load/store halfword/signed byte (pre-indexing)\n");
    #20 #20 #20 check_status(40);
    #20 check_status(43);
    #20 check_status(44);
    #20 check_status(45);
    #20 check_status(104);

    family_number = 4'd14;

    P = 0;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing branch\n");
    #20 #20 #20 check_status(56);
    #20 check_status(57);
    #20 check_status(104);

    P = 1;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing branch and link\n");
    #20 #20 #20 check_status(56);
    #20 check_status(59);
    #20 check_status(57);
    #20 check_status(104);

    family_number = 4'd12;

    $display("\nresetting to fetch");
    rst = 1; #20 rst = 0;
    $display("skipping past decode");
    $display("testing swap\n");
    #20 #20 #20 check_status(64);
    #20 check_status(65);
    #20 check_status(66);
    #20 check_status(104);

    $write("\n");
    if (failcount > 0) $write("%d tests failed\n", failcount);
    else $write("          all tests passed! 🎉\n");

    $finish;
end

endmodule