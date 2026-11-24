module LFSR_6bit (
    input clk,
    input rst_n,         // Active low reset
    input enable,        // Enable generation of next pattern
    output reg [5:0] lfsr_state
);

wire [5:0] lfsr_state_n;
wire feadback_bit;
assign feadback_bit = lfsr_state[5]^lfsr_state[0];

// Polynomial: x^6 + x + 1.
// Feedback bit is lfsr_reg[5] XOR lfsr_reg[1].
assign lfsr_state_n = enable ? {lfsr_state[4:0], feadback_bit} : lfsr_state;

always @(posedge clk) begin
    if (!rst_n) begin
        lfsr_state <= 6'b000001; // Initial non-zero seed
    end 
    else begin
        lfsr_state <= lfsr_state_n;
    end
end

endmodule