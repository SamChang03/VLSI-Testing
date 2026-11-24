module mul_BIST
#(
    parameter N = 6, // # of bits in the input register
    parameter P = 30,  // # of patterns to be applied
    parameter M = 2*N, // # of bits in the output register
    parameter N_bits = 4, // # of  bits of the "counter" in the input register
    parameter P_bits = 5, // # of bits of the "counter" in the input register
    parameter golden = 12'hb05
)
(
    input clk,
    input rst_n,
    input start_test,

    output test_fail,
    output test_done
);

// Controll signal
wire LFSR_en, MISR_en,last_pattern;

///***************** FSM *********************///
FSM 
#(
    .N(N), // # of bits in the input register
    .P(P),  // # of patterns to be applied
    .N_bits(N_bits),
    .P_bits(P_bits) 
)
FSM
(
    .clk(clk),
    .rst_n(rst_n),
    .start_test(start_test),

    .LFSR_en(LFSR_en),
    .MISR_en(MISR_en),
    .last_pattern(last_pattern),
    .test_done(test_done)
);

///***************** LFSR *********************///
wire [5:0] lfsr_state;

LFSR_6bit LFSR(
    .clk(clk),
    .rst_n(rst_n),         // Active low reset
    .enable(LFSR_en),        // Enable generation of next pattern

    .lfsr_state(lfsr_state)
);

///***************** Input Registers *********************///
wire [N-1:0] R1_in, R2_in;

register_in
#(
   .N(N)
)
R1
(
    .clk(clk),
    .data_in(lfsr_state[5]),

    .pattern_in(R1_in)
);

register_in
#(
   .N(N)
)
R2
(
    .clk(clk),
    .data_in(R1_in[N-1]),

    .pattern_in(R2_in)
);

///***************** Circuit Under Test *********************///
wire [M-1:0] out_mul;

multiplier 
#(
    .num_bits(N)
)
multiplier_6bits
(
    .in_a(R1_in),
    .in_b(R2_in),

    .out_mul(out_mul)
);

///***************** MISR *********************///
wire [M-1:0] signature;

MISR_12bit 
#(
    .M(M)
)
MISR
(
    .clk(clk),
    .rst_n(rst_n),         // Active low reset
    .enable(MISR_en),        // Enable generation of next pattern
    .data_in(out_mul),

    .signature(signature)
);

///***************** MISR *********************///

check_test
#(
    .M(M),
    .golden(golden)
)
check_test
(
    .clk(clk),
    .rst_n(rst_n),
    .last_pattern(last_pattern),
    .signature(signature),

    .test_fail(test_fail)
);

endmodule

