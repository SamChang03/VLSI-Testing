module FSM
#(
    parameter N = 6, // # of bits in the input register
    parameter P = 30,  // # of patterns to be applied
    parameter N_bits = 4,
    parameter P_bits = 5
)
(
    input clk,
    input rst_n,
    input start_test,
    output reg LFSR_en,
    output reg MISR_en,
    output reg last_pattern,
    output reg test_done
);

localparam START = 0;
localparam SCAN_SHIFTING = 1;
localparam LAUNCH_OFF_SHIFTING = 2;
localparam LAST_CAPTURE = 3;
localparam CHECK_RESULT = 4;

reg [2:0] state, state_n;
reg [P_bits-1:0] pattern_cnt, pattern_cnt_n;
reg [N_bits-1:0] scan_cnt, scan_cnt_n;

always @(*) begin
    state_n = state;
    scan_cnt_n = scan_cnt;
    pattern_cnt_n = pattern_cnt;
    LFSR_en = 0;
    MISR_en = 0;
    test_done = 0;
    last_pattern = 0;
    case (state)
        START: begin
            if (start_test) begin
                state_n = SCAN_SHIFTING;
                scan_cnt_n = 0;
                pattern_cnt_n = 0;
            end
        end
        SCAN_SHIFTING: begin
            scan_cnt_n = scan_cnt + 1;
            LFSR_en = 1;
            if (scan_cnt == 2*N) begin
                state_n = LAUNCH_OFF_SHIFTING;
            end
        end
        LAUNCH_OFF_SHIFTING: begin
            LFSR_en = 1;
            MISR_en = 1;
            pattern_cnt_n = pattern_cnt + 1;
            if (pattern_cnt == P) begin
                state_n = LAST_CAPTURE;
            end
        end
        LAST_CAPTURE: begin
            state_n = CHECK_RESULT;
            last_pattern = 1;
        end
        CHECK_RESULT: begin
            state_n = START;
            test_done = 1;
        end
    endcase
end

always @(posedge clk ) begin
    if (!rst_n) begin
        state <= START;
        pattern_cnt <= 0;
        scan_cnt <= 0;
    end
    else begin
        state <= state_n;
        pattern_cnt <= pattern_cnt_n;
        scan_cnt <= scan_cnt_n;
    end
end

endmodule

