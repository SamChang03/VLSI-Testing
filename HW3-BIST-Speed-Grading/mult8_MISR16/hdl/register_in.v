module register_in
#(
    parameter N = 6
)
(
    input clk,
    input data_in,
    output reg [N-1:0] pattern_in
);

always @(posedge clk) begin
    pattern_in <= {pattern_in[N-2:0],data_in};
end

endmodule

