module check_test
#(
    parameter M = 12,
    parameter golden = 12'hb05
)
(
    input clk,
    input rst_n,
    input last_pattern,
    input [M-1:0] signature,
    output reg test_fail
);

wire test_fail_n = (last_pattern) ? signature != golden : 1'b1;

always @(posedge clk) begin
    if (~rst_n) begin
        test_fail <= 1'b1;
    end
    else begin
        test_fail <= test_fail_n;
    end
end

endmodule

