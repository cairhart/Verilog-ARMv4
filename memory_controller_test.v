`include "memory_controller.v"


module test; 

integer failcount;

reg b, h, s;
reg [15:0] decode;
reg [31:0] data;

wire [1:0] size_output;
wire [31:0] data_output;

wire signed_data, byte, halfword, word;

mcu MCU(
	.b(b),
	.h(h),
	.s(s),
	.decode_families(decode),
	.data_from_mem(data),

	.data_size(size_output),
    .data_to_cpu(data_output)

    ,
    .signed_data(signed_data),
    .byte(byte),
    .halfword(halfword),
    .word(word)
);


task check_status;
input [1:0]     expected_size;
input           expected_sign;
input [31:0]    expected_data;
begin
    
    #10
    $display("size = %d, byte = %d, halfword = %d, word = %d, signed = %d", size_output, byte, halfword, word, signed_data);
    $display("memory out = %4x", data_output);
    if((size_output != expected_size) || (expected_data != data_output) || (signed_data != expected_sign)) begin
        $display("Error: expected size = %d data = %4x, sign = %d", expected_size, expected_data, expected_sign);
        failcount = failcount + 1;
    end

end
endtask


initial begin
    failcount = 0;
    b = 0;
    data = 0;
    ////////////////////////// Halfword/ signed byte
    decode = 16'b1 << 8; 
    
    // halfword
    h = 1;
    s = 0;
    data = 32'h0088;
    check_status(1, 0, 32'h0088);
    s = 1;
    data = 32'h0000FFFF;
    check_status(1, 1, 32'hFFFFFFFF);
    b = 1;
    check_status(1, 1, 32'hFFFFFFFF);
    b = 0;
    
    data = 0;
    // signed byte
    h = 0;
    s = 0;
    data = 32'h0088;
    check_status(0, 1, 32'hFFFFFF88);
    s = 1;
    data = 32'h0033;
    check_status(0, 1, 32'h0033);
    data = 0;
    b = 1; 
    check_status(0, 1, 0);

    decode = 16'b1 << 9;
    // halfword
    h = 1;
    s = 0;
    check_status(1, 0, 0);
    s = 1;
    check_status(1, 1, 0);
    b = 1;
    check_status(1, 1, 0);
    b = 0;

    // signed byte
    h = 0;
    s = 0;
    check_status(0, 1, 0);
    s = 1;
    check_status(0, 1, 0);
    b = 1; 
    check_status(0, 1, 0);

    /////////////////////////////////////// Word/ unsigned byte
    decode = 16'b1 << 10;

    // word
    b = 0;
    check_status(3, 0, 0);
    h = 1;
    check_status(3, 0, 0);
    s = 0;
    check_status(3, 0, 0);
    h = 0; 
    s = 0;

    // unsigned byte
    b = 1;
    check_status(0, 0, 0);
    h = 1;
    check_status(0, 0, 0);
    s = 1;
    check_status(0, 0, 0);


    decode = 16'b1 << 11;

    // word
    b = 0;
    check_status(3, 0, 0);
    h = 1;
    check_status(3, 0, 0);
    s = 0;
    check_status(3, 0, 0);
    h = 0; 
    s = 0;

    // unsigned byte
    b = 1;
    check_status(0, 0, 0);
    h = 1;
    check_status(0, 0, 0);
    s = 1;
    check_status(0, 0, 0);





    if(failcount > 0) $display("THIS TEST EXITED WITH ERRORS");
    else $display("All tests passed");
end

endmodule
