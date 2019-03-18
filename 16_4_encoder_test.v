`include "16_4_encoder.v"

module Encoder16To4_Test;

reg [15:0] bits;
wire  [3:0] number;
Encoder16To4 _(.bits(bits), .number(number));

integer i;
initial begin
    bits = 16'd0;
    #10
    $write("bits=%h, number=%d\t", bits, number);
    if (number == 4'd0) $write("passed\n");
    else $write("FAILED!\n");
    for (i = 0;  i <= 15;  i = i + 1) begin
        bits = 16'd1 << i;
        #10
        $write("bits=%h, number=%d\t", bits, number);
        if (number == i[3:0]) $write("passed!\n");
        else $write("FAILED!!!\n");
    end
end

endmodule