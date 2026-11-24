module multiplier
#(
    parameter num_bits = 6
)
(
    input [num_bits-1:0] in_a,
    input [num_bits-1:0] in_b,

    output [2*num_bits-1:0] out_mul
);

assign out_mul = in_a*in_b;

endmodule

