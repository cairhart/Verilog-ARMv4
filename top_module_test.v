//`timescale 1 ns / 1 ps

`include "ARMv4.v"
`include "basic_ram.v"
`include "top_test_file_to_ram.v"

module top_module_test;


// Clock 
reg clock = 0;
always #5 clock = !clock;

// Testing control signals
reg ld_file;
wire finished;
reg reset;



// Testing output reads
wire [31:0] ir;
wire [63:0] control_signals;
wire [15:0] decode_fam;


// RAM Wires
wire [31:0]  ram_addr;
wire [31:0]  ram_d_in;
wire [31:0] ram_d_out;
wire		    ram_cs, ram_we, ram_oe;
wire        ram_m_ready;


wire [31:0] ld_addr, ld_d_in, ld_d_out;
wire        ld_cs, ld_we, ld_oe;


wire [31:0] arm_addr, arm_d_in, arm_d_out;
wire        arm_cs, arm_we, arm_oe;



// RAM Connections
assign ld_d_out = ram_d_out;
assign arm_d_out = ram_d_out;
assign ram_addr = ld_file ? ld_addr : arm_addr;
assign ram_d_in = ld_file ? ld_d_in : arm_d_in;
assign ram_cs = ld_file ? ld_cs : arm_cs;
assign ram_we = ld_file ? ld_we : arm_we;
assign ram_oe = ld_file ? ld_oe : arm_oe;


// Module instances
ARMv4 ARMV4(
	.clk(clock),
	.address(arm_addr),
	.ram_data_in(arm_d_in),
	.ram_data_out(arm_d_out),
	.cs(arm_cs),
	.we(arm_we),
	.oe(arm_oe),
	.rst(reset),
	.ir_out(ir)
);

file_to_ram FILE_TO_RAM(
	.clk(clock),
	.data_output(ld_d_out),
	.address(ld_addr),
	.data_input(ld_d_in),
	.cs(ld_cs),
	.we(ld_we),
	.oe(ld_oe),
    .finished(finished)
);


basic_ram BASIC_RAM(
	.clk(clock),
	.address(ram_addr),
	.data_output(ram_d_out),
	.data_input(ram_d_in),
	.mem_done(ram_m_ready),
	.cs(ram_cs),
	.we(ram_we),
	.oe(ram_oe)
);


initial begin
    $display("Start\n");
    reset = 1;
    ld_file = 1;    
    $display("Loading memory\n");

    while(!finished) begin
        #200
        $display("Finished = %d\n", finished);
    end
    $display("Finished loading memory\n");

    ld_file = 0;
    reset = 0;
    #300
    $display("IR = 0x%4x\n", ir);
    $display("Decode family = 0x%4x\n", decode_fam);
    
    $finish;
end

endmodule
 
