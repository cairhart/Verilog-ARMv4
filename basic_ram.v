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
mem_done_out, // memory is finished reading or writing
cs          , // Chip Select
we          , // Write Enable/Read Enable
oe          , // Output Enable
data_size
); 

parameter DATA_WIDTH = 8 ;
parameter ADDR_WIDTH = 14 ;
parameter RAM_DEPTH = 1 << ADDR_WIDTH;
parameter WORD_SIZE = 4; // In Bytes (probably)
parameter DATA_OUT_SIZE = DATA_WIDTH * WORD_SIZE;

//--------------Input Ports----------------------- 
input                     clk        ;
input [DATA_OUT_SIZE-1:0] data_input ;
input [ADDR_WIDTH-1:0]    address    ;
input                     cs         ;
input                     we         ;
input                     oe         ; 
input[1:0]			          data_size  ;

//--------------Output Ports----------------------- 
output 					mem_done_out;
output [DATA_OUT_SIZE-1:0] data_output;

//--------------Internal variables---------------- 
reg [DATA_WIDTH-1:0] data_out0 ;
reg [DATA_WIDTH-1:0] data_out1 ;
reg [DATA_WIDTH-1:0] data_out2 ;
reg [DATA_WIDTH-1:0] data_out3 ;
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
reg                  oe_r;
reg					         mem_done;

//--------------Code Starts Here------------------ 

// Tri-State Buffer control 
// output : When we = 0, oe = 1, cs = 1
assign data_output = (cs && oe && !we) ? 
			{data_out3,data_out2,data_out1,data_out0} : 8'bz; 

assign mem_done_out = mem_done;

// Memory Write Block 
// Write Operation : When we = 1, cs = 1
always @ (posedge clk)
begin : MEM_WRITE
  mem_done = 0;
  if ( cs && we ) begin
    case(data_size)
      2'b11:begin
        mem[address] <= data_input[7:0];
    		mem[address+1] <= data_input[15:8];
    		mem[address+2] <= data_input[23:16];
    		mem[address+3] <= data_input[31:24];
  		end
	    2'b10:begin
    	 	mem[address] <= data_input[7:0];
    		mem[address+1] <= data_input[15:8];
    		mem[address+2] <= mem[address+2];
    		mem[address+3] <= mem[address+3];
		  end
	    2'b00:begin
	    	mem[address] <= data_input[7:0];
  	   	mem[address+1] <= mem[address+2];
  	   	mem[address+2] <= mem[address+2];
  	   	mem[address+3] <= mem[address+3];
      end
	    default:begin
        mem[address]   <= mem[address];
		    mem[address+1] <= mem[address+2];
		    mem[address+2] <= mem[address+2];
		    mem[address+3] <= mem[address+3];
		  end
	  endcase;
  end
  mem_done = 1;
end

// Memory Read Block 
// Read Operation : When we = 0, oe = 1, cs = 1
always @ (posedge clk)
begin : MEM_READ
  mem_done = 0;
  if (cs && !we && oe) begin
    case(data_size)
      2'b11: begin
        data_out0 = mem[address];
        data_out1 = mem[address+1];
        data_out2 = mem[address+2];
        data_out3 = mem[address+3];
      end
      2'b10:begin
        data_out0 = mem[address];
        data_out1 = mem[address+1];
        data_out2 = 8'h00;
        data_out3 = 8'h00;
      end
      2'b00:begin
        data_out0 = mem[address];
        data_out1 = 8'h00;
        data_out2 = 8'h00;
        data_out3 = 8'h00;
      end
      default:begin
        data_out0 = 8'h00;
        data_out1 = 8'h00;
        data_out2 = 8'h00;
        data_out3 = 8'h00;
      end
  	endcase;
    oe_r = 1;
  end else begin
    oe_r = 0;
  end
  mem_done = 1;
end

endmodule // End of Module ram_sp_sr_sw
