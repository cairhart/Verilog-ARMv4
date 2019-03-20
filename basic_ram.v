//-----------------------------------------------------
// Design Name : basic_ram
// File Name   : basic_ram.v
// Function    : Synchronous read write RAM 
// Coder       : Carter Airhart
//-----------------------------------------------------
module basic_ram (
clk         , // Clock Input
address     , // Address Input
data_output , // Data out
data_input	, // Data in
mem_done		, // memory is finished reading or writing
cs          , // Chip Select
we          , // Write Enable/Read Enable
oe            // Output Enable
); 

parameter DATA_WIDTH = 32 ;
parameter ADDR_WIDTH = 10 ;
parameter RAM_DEPTH = 1 << ADDR_WIDTH;

//--------------Input Ports----------------------- 
input                  clk         ;
input [DATA_WIDTH-1:0]  data_input ;
input [ADDR_WIDTH-1:0] address     ;
input                  cs          ;
input                  we          ;
input                  oe          ; 

//--------------Output Ports----------------------- 
output 									 mem_done;
output [DATA_WIDTH-1:0]  data_output;

//--------------Internal variables---------------- 
reg [DATA_WIDTH-1:0] data_out ;
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
reg                  oe_r;

//--------------Code Starts Here------------------ 

// Tri-State Buffer control 
// output : When we = 0, oe = 1, cs = 1
assign data_output = (cs && oe && !we) ? data_out : 8'bz; 

// Memory Write Block 
// Write Operation : When we = 1, cs = 1
always @ (posedge clk)
begin : MEM_WRITE
   if ( cs && we ) begin
       mem[address] = data_input;
   end
end

// Memory Read Block 
// Read Operation : When we = 0, oe = 1, cs = 1
always @ (posedge clk)
begin : MEM_READ
  if (cs && !we && oe) begin
    data_out = mem[address];
    oe_r = 1;
  end else begin
    oe_r = 0;
  end
end

endmodule // End of Module ram_sp_sr_sw
