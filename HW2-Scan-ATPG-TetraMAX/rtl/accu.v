module accu
#(
    parameter input_bits = 16,
    parameter output_bits = 32
)
(
    input clk,
    input rst_n,
    input [input_bits-1:0] X,
    output reg [output_bits-1:0] AC
);

wire [output_bits-1:0] AC_n;

assign AC_n = AC + X;

always @(posedge clk ) begin
    if (~rst_n) begin
        AC <= 0;
    end
    else begin
        AC <= AC_n;
    end
end
endmodule

