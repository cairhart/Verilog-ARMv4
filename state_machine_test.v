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
    $write("J=%d, ", state_machine.J);
    $write("MOD=%b, ", state_machine.MOD);
    $write("DEC=%b, ", state_machine.DEC);
    $write("L=%b, ", state_machine.L);
    $write("P=%b, ", state_machine.P);
    $write("A=%b", state_machine.A);
    $write("\t");
    if (state_machine.address == expected) $write("+ passed");
    else begin $write("- FAILED"); failcount = failcount + 1;  end
    $write("\n");
end
endtask

reg clk;
reg [15:0] family_bits;
reg COND;
reg L;
reg P;
reg A;

StateMachine state_machine(
    // Inputs
    .clk(clk),
    .family_bits(family_bits),
    .COND(COND),
    .L(L),
    .P(P),
    .A(A)
);

always #10 clk = ~clk;

initial begin
    family_bits = 0;
    COND = 1;
    L = 0;
    P = 0;
    A = 0;
    clk = 0;
    failcount = 0;

     #1 check_status(104);
    #20 check_status(105);
    #20 check_status(106);
    #20 check_status(0);
    #20 check_status(104);

    family_bits = 16'h0008;

    $display("skipping past decode");
    $display("testing data processing");
    #20 #20 #20 check_status(24);
    #20 check_status(25);
    #20 check_status(104);

    family_bits = 16'h0010;

    $display("skipping past decode");
    $display("testing multiply");
    #20 #20 #20 check_status(32);
    #20 check_status(34);
    #20 check_status(36);
    #20 check_status(104);

    A = 1;

    $display("skipping past decode");
    $display("testing multiply long");
    #20 #20 #20 check_status(32);
    #20 check_status(35);
    #20 check_status(34);
    #20 check_status(36);
    #20 check_status(104);

    family_bits = 16'h0020;

    $display("skipping past decode");
    $display("testing load/store word/unsigned byte (post-indexing)");
    #20 #20 #20 check_status(40);
    #20 check_status(41);
    #20 check_status(42);
    #20 check_status(44);
    #20 check_status(104);

    P = 1;

    $display("skipping past decode");
    $display("testing load/store word/unsigned byte (pre-indexing)");
    #20 #20 #20 check_status(40);
    #20 check_status(43);
    #20 check_status(44);
    #20 check_status(104);

    family_bits = 16'h0040;
    P = 0;

    $display("skipping past decode");
    $display("testing load/store halfword/signed byte (post-indexing)");
    #20 #20 #20 check_status(48);
    #20 check_status(49);
    #20 check_status(50);
    #20 check_status(52);
    #20 check_status(104);

    P = 1;

    $display("skipping past decode");
    $display("testing load/store halfword/signed byte (pre-indexing)");
    #20 #20 #20 check_status(48);
    #20 check_status(51);
    #20 check_status(52);
    #20 check_status(104);

    family_bits = 16'h0080;

    $display("skipping past decode");
    $display("testing branch");
    #20 #20 #20 check_status(56);
    #20 check_status(57);
    #20 check_status(104);

    L = 1;

    $display("skipping past decode");
    $display("testing branch and link");
    #20 #20 #20 check_status(56);
    #20 check_status(61);
    #20 check_status(57);
    #20 check_status(104);

    family_bits = 16'h0100;

    $display("skipping past decode");
    $display("testing swap");
    #20 #20 #20 check_status(64);
    #20 check_status(65);
    #20 check_status(104);

    $write("\n");
    if (failcount > 0) $write("%d tests failed\n", failcount);
    else $write("          all tests passed! 🎉\n");

    $finish;
end

endmodule