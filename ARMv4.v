// This is the top module for the ARMv4 processor



module ARMv4(
	
	
);



/**************************************************
 ********         Top Level Registers   ***********
 **************************************************/
reg mrdr[31:0],mwdr[31:0]; // Memory Read and Memory Write registers
reg ir[31:0]; // Instruction register



/**************************************************
 ********         Control Signal        ***********
 **************************************************/
wire control_signals [63:0]; // Left generic to ease modificaiton. 
// Check the state machine spreadsheet to see descriptions of control signals



/**************************************************
 ********         Inter-connection      ***********
 **************************************************/
wire [31:0] mul_out;



/**************************************************
 ********         Busses                ***********
 **************************************************/
wire [31:0] a_bus, b_bus, c_bus;




/**************************************************
 ********         Tri-state buffers     ***********
 **************************************************/

// Naming convention: <gate_signal_name>_B

32_bit_tsb REG_GATE_B_B ( 
);

32_bit_tsb REG_GATE_C_B ( 

);

32_bit_tsb GATE_MUL_B ( 
    .in(mul_out),
    .gate(REG_GATE_B),
    .out(b_bus)
);

/**************************************************
 ********         Top Level Modules     ***********
 **************************************************/
addr_mode_1 ADDR_MODE_1(

);

alu ALU(

);

basic_ram BASIC_RAM(

);

decodeFamilies DECODE_FAMILIES(

);

multiply_unit MULTIPLY_UNIT(
	.B_In(b_bus),
	.C(c_bus),
	.MUL_HiLo(control_signals[45]),
	.LD_MUL(control_signals[46]),
	.U( ir[22]),
	.B_Out(mul_out))
);

reg_bank_encap REG_BANK_ENCAP(

);

state_machine STATE_MACHINE(

);










