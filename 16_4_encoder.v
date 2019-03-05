module Encoder16To4(
    input [15:0] bits,
    output reg [3:0] number
);

always @(*) begin
    case (bits)
        16'h0001 : number <= 4'd0;
        16'h0002 : number <= 4'd1;
        16'h0004 : number <= 4'd2;
        16'h0008 : number <= 4'd3;
        16'h0010 : number <= 4'd4;
        16'h0020 : number <= 4'd5;
        16'h0040 : number <= 4'd6;
        16'h0080 : number <= 4'd7;
        16'h0100 : number <= 4'd8;
        16'h0200 : number <= 4'd9;
        16'h0400 : number <= 4'd10;
        16'h0800 : number <= 4'd11;
        16'h1000 : number <= 4'd12;
        16'h2000 : number <= 4'd13;
        16'h4000 : number <= 4'd14;
        16'h8000 : number <= 4'd15;
    endcase
end

endmodule