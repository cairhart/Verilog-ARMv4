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
`include "memory_controller.v"
`include "macro_definitions.v"
`include "alu_op_mux.v"


/**************************************************
 ********         Macros                ***********
 **************************************************/


module ARMv4(
	input clk,
	input [31:0] ram_data_into_mcu,
	input rst,

	output [31:0] ram_data_in,
	input ram_ready,
	output cs, we, oe,
	output [31:0] address,
  output [31:0] ir_out,
  output [63:0] cs_out,
  output [15:0] dec_fam_out,
  output [1:0] data_size
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
reg [31:0] mrdr, mwdr; // Memory Read and Memory Write registers
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
wire [1:0] data_size;
wire [3:0] alu_operation;


/**************************************************
 ********         Busses                ***********
 **************************************************/
wire [31:0] a_bus, b_bus, c_bus;
wire [31:0] alu_bus;
wire [31:0] alu_bus_hi_UNUSED; // High 32 bits padding for the unused portion of the ALU output
wire [31:0] ram_data_out; // see bottom right of the main hardware diagram cön

assign b_bus = (`CTRL_ST_GATE_MRDR == 1) ? mrdr : 32'bz;



/**************************************************
 ********         Tri-state buffers     ***********
 **************************************************/

// Naming convention: <gate_signal_name>_B


tsb_32_bit GATE_MUL_B (
    .in(mul_out),
    .gate(`CTRL_ST_GATE_MUL),
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
    .is_pass_thru(`CTRL_ST_AM1_PASS_THRU), // pass Rm_data through
    .C(am1_carry_in),

    .shifter_operand(am1_to_alu),
    .shifter_carry(am1_carry_out)

);

alu_operation_mux ALU_OPERATION_MUX(
    .alu_op_mux(`CTRL_ST_ALU_OP_MUX),
    .ir_op(ir[24:21]),
    .cs_op(`CTRL_ST_ALU_OP),
    .u(ir[23]),
    .alu_operation(alu_operation)
);

alu ALU(
    .A(a_bus),
    .B(am1_to_alu),
    .ALU_Sel(alu_operation),
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

mcu MCU(
	.b(ir[22]),
	.h(ir[5]),
	.s(ir[6]),
	.decode_families(decoder_fam_signals),
	.data_from_mem(ram_data_into_mcu),
  .ld_ir(`CTRL_ST_LD_IR),
  .ld_mar_from_pc(`CTRL_ST_MARMUX1),
	.data_size(data_size),
	.data_to_cpu(ram_data_out)
);


mar MAR(
	.LD_MAR(`CTRL_ST_LD_MAR),
    .MARMUX1(`CTRL_ST_MARMUX1),
    .MARMUX2(`CTRL_ST_MARMUX2),
    .PC(pc),
    .ALU_bus(alu_bus),
    .address(address)
);


mul MUL(
	.B_In(b_bus),
	.C(c_bus),
	.MUL_HiLo(`CTRL_ST_MUL_HILO),
	.LD_MUL(`CTRL_ST_LD_MUL),
	.U( ir[22]),
	.B_Out(mul_out)
);



RegBankEncapsulation REG_BANK_ENCAP(
	.clk(clk),     // TODO
	.rst(rst),		// TODO
	.LATCH_REG(`CTRL_ST_LATCH_REG),
    .IR_RD_MUX(`CTRL_ST_IR_RD_MUX),
    .IR_RN_MUX(`CTRL_ST_IR_RN_MUX),
	.IR_RM_MUX(`CTRL_ST_IR_RM_MUX),
	.RD_MUX(`CTRL_ST_RD_MUX),
	.PC_MUX(`CTRL_ST_PC_MUX),
	.DATA_MUX(`CTRL_ST_DATA_MUX),
	.REG_GATE_B(`CTRL_ST_REG_GATE_B),
	.REG_GATE_C(`CTRL_ST_REG_GATE_C),
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
    .ST(ir[20]),
	.PL(ir[24]),
	.A(ir[21]),
	.MEM_R(ram_ready),
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
    ir = (`CTRL_ST_LD_IR) ? ram_data_out : ir;
    mrdr = (`CTRL_ST_LD_MRDR) ? ram_data_out : mrdr;
    mwdr = (`CTRL_ST_LD_MWDR) ? b_bus : mwdr;
	//$display("Family signal is %d\n",decoder_fam_num);
    $display("decoder family is %d\n",decoder_fam_num);
    if(`CTRL_ST_LATCH_REG) begin
     // $display("A: %d, B: %d, C: %d, ALU: %d", a_bus, am1_to_alu, nzcv_signals[1], alu_bus);
    end
end

// Top Level initializaion
initial begin


end


endmodule

