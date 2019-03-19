module test;

  /* Make a reset that pulses once. */
  reg [31:0] A,B;
	reg [3:0] ALU_Sel;
	wire [63:0] ALU_out;
	wire [3:0] nzcv;
	reg reset = 0;
  initial begin
					A = 1;
					B = 1;
					ALU_Sel = 4;
     # 17 reset = 1;
     # 11 reset = 0;
     # 29 reset = 1;
     # 11 reset = 0;
     # 100 $stop;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #5 clk = !clk;

  alu alu1(A,B,ALU_Sel, ALU_out, nzcv);

  initial
     $monitor("At time %t, a = %h (%0d), b = %h (%0d), alu_out = %h",
              $time, A, A, B, B, ALU_out);
endmodule // test
