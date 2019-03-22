// This is the top module for the ARMv4 processor

`include "32_bit_tsb.v"
`include "addr_mode_1.v"
`include "alu.v"
//`include "basic_ram.v"
`include "decodeFamilies.v"
`include "mar.v"
`include "multiply_unit.v"
`include "nzcv_unit.v"
`include "reg_bank_encap.v"
`include "state_machine.v"



/**************************************************
 ********         Macros                ***********
 **************************************************/
// Misc. Macros
`define START_ADDRESS 32'h0000
// Control Signal Macros


module ARMv4(
	input clk,
	input [31:0] ram_data_out,
	input rst,

	output [31:0] ram_data_in, 
	output cs, we, oe,
	output [31:0] address,
  output [31:0] ir_out,
  output [63:0] cs_out,
  output [15:0] dec_fam_out
);

wire [31:0] address;
wire [31:0] data_out;
wire cs, we, oe;

//C*O*D*E R*E*V*I*E*W
//TODO Maybe we should add signals for this
//assign cs = control_signals[40];
assign cs = 1;
assign we = 0;
assign oe = 1;
assign data_out = mwdr;
assign cs_out = control_signals;
assign ir_out = ir;

/**************************************************
 ********         Top Level Registers   ***********
 **************************************************/
reg [31:0] mrdr,mwdr; // Memory Read and Memory Write registers
reg [31:0] ir; // Instruction register



/**************************************************
 ********         Control Signals       ***********
 **************************************************/
wire [63:0] control_signals; // Left generic to ease modificaiton. 
// Check the state machine spreadsheet to see descriptions of control signals



/**************************************************
 ********         Decode Signals       ***********
 **************************************************/
wire [15:0] decoder_fam_signals; // See decodeFamilies.v for description of this signal
wire [3:0] decoder_fam_num; // See decodeFamilies.v for description of this signal
	

/**************************************************
 ********         Inter-connection      ***********
 **************************************************/
 // The following signals are misc. interconntections between modules.
 // These signals aren't part of the main signal or bus set.
wire [31:0] mul_out;                                // ouput from the multiply unit
wire [31:0] am1_to_alu;                             // bus from addr1 module to ALU
wire        am1_carry_in, am1_carry_out;            // addr1 carry in and out
wire [3:0]  reg_counter_to_rb;                      // register counter to register bank
wire [31:0] pc;                                     // Program counter output from the register bank (i.e. R15)
wire [31:0] st;                                     
wire        cond;                                   // COND signal based on condition codes
wire [3:0] nzcv_signals;



/**************************************************
 ********         Busses                ***********
 **************************************************/
wire [31:0] a_bus, b_bus, c_bus;
wire [31:0] alu_bus;
wire [31:0] alu_bus_hi_UNUSED; // High 32 bits padding for the unused portion of the ALU output




/**************************************************
 ********         Tri-state buffers     ***********
 **************************************************/

// Naming convention: <gate_signal_name>_B


tsb_32_bit GATE_MUL_B ( 
    .in(mul_out),
    .gate(control_signals[44]),
    .out(b_bus)
);

/**************************************************
 ********         Top Level Modules     ***********
 **************************************************/
AddrMode1 ADDR_MODE_1(
	.IR(ir),
	.Rs_LSB(c_bus[7:0]),
	.Rm_data(b_bus),
    .is_DPI(decoder_fam_signals[0]),       // data processing immediate
    .is_DPIS(decoder_fam_signals[1]),      // data processing immediate shift
    .is_DPRS(decoder_fam_signals[2]),      // data processing register shift
    .is_LSIO(decoder_fam_signals[8]),      // load/store immediate offset
    .is_LSHSBCO(decoder_fam_signals[10]),   // load/store halfword/signed byte combined offset
    .is_LSHSBSO(decoder_fam_signals[11]),   // load/store halfword/signed byte shifted offset
    .is_BL(decoder_fam_signals[14]),        // branch/branch and link
    .is_pass_thru(control_signals[43]), // pass all 32 IR bits through
    .C(am1_carry_in),

    .shifter_operand(am1_to_alu),
    .shifter_carry(am1_carry_out)

);

alu ALU(
    .A(a_bus),
    .B(am1_to_alu),
    .ALU_Sel(ir[24:21]),
    .ALU_Out({alu_bus_hi_UNUSED, alu_bus} ),
    .NZCV(nzcv_signals)

);


nzcv_unit NZCV_UNIT(
	.nzcv_input(nzcv_signals),
	.s_input(ir[20]),
	.opcode_input(ir[31:28]),
	.clk(clk),
	.operated(cond)
);

/*
basic_ram BASIC_RAM(

);
*/

decodeFamily DECODE_FAMILY(
	.ir(ir),
	.f_signals(decoder_fam_signals),
  .f_num(decoder_fam_num)
);


mar MAR(
	.LD_MAR(control_signals[34]),
    .MARMUX1(control_signals[33]),
    .MARMUX2(control_signals[32]),
    .PC(pc),
    .ALU_bus(alu_bus),
    .address(address)
);


mul MUL(
	.B_In(b_bus),
	.C(c_bus),
	.MUL_HiLo(control_signals[45]),
	.LD_MUL(control_signals[46]),
	.U( ir[22]),
	.B_Out(mul_out)
);



RegBankEncapsulation REG_BANK_ENCAP(
	.clk(clk),     // TODO
	.LATCH_REG(control_signals[52]),
	.IR_RD_MUX(control_signals[42]),
	.LSM_RD_MUX(control_signals[41]),
	.RD_MUX(control_signals[51]),
	.PC_MUX(control_signals[50]),
	.DATA_MUX(control_signals[49]),
	.REG_GATE_B(control_signals[48]),
	.REG_GATE_C(control_signals[47]),
	.IR(ir), 
	.ALU_BUS(alu_bus),
	.REG_COUNTER(reg_counter_to_rb),    // TODO  will probably remove this signal
	.A_BUS(a_bus),
	.B_BUS(b_bus),
	.C_BUS(c_bus),
	.ST(st), 
	.PC(pc)

);


StateMachine STATE_MACHINE(
	.clk(clk),		// TODO 
	.rst(rst),		// TODO 
	.family_number(decoder_fam_num),
	.COND(cond),
	.L(ir[20]),
	.P(ir[24]),
	.A(ir[21]),
	.IR_20(ir[20]),
	.CS_BITS(control_signals)
);
// D*E*B*U*G N*O*T*E
// If you print ir here its set to the right ir value
// which means something is breaking when we try to set ir_out I think


/**************************************************
 ********         Top Level Logic       ***********
 **************************************************/
// Top level registers


always @ (posedge clk) begin
    ir = (control_signals[37]) ? ram_data_out : ir;
    mrdr = (control_signals[36]) ? ram_data_out : mrdr;
    mwdr = (control_signals[35]) ? b_bus : mwdr;
end 

// Top Level initializaion
initial begin
    

end


endmodule

