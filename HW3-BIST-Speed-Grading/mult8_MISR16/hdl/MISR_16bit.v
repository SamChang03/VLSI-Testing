module MISR_16bit 
#(
    parameter M = 16
)
(
    input clk,
    input rst_n,         // Active low reset
    input enable,        // Enable signature accumulation
    input [M-1:0] data_in, // Data from CUT (multiplier product)
    output reg [M-1:0] signature // Current signature
);

reg [M-1:0] signature_n;
reg [M-1:0] data_in_FF ;

// Polynomial: x^16 + x^5 + x^3 + x^2 + 1.
always @(*) begin
    signature_n = signature;
    if (enable) begin
        signature_n[0]  = signature[15] ^ data_in_FF[0];
        signature_n[1]  = signature[0]  ^ data_in_FF[1];
        signature_n[2]  = signature[1]  ^ data_in_FF[2];
        signature_n[3]  = signature[2]  ^ data_in_FF[3];
        signature_n[4]  = signature[3]  ^ data_in_FF[4];
        signature_n[5]  = signature[4]  ^ data_in_FF[5];
        signature_n[6]  = signature[5]  ^ data_in_FF[6];
        signature_n[7]  = signature[6]  ^ data_in_FF[7];
        signature_n[8]  = signature[7]  ^ data_in_FF[8];
        signature_n[9]  = signature[8]  ^ data_in_FF[9];
        signature_n[10] = signature[9]  ^ data_in_FF[10];
        signature_n[11] = signature[10] ^ data_in_FF[11] ^ signature[15];  // for x^5
        signature_n[12] = signature[11] ^ data_in_FF[12];
        signature_n[13] = signature[12] ^ data_in_FF[13] ^ signature[15];   // for x^3
        signature_n[14] = signature[13] ^ data_in_FF[14] ^ signature[15];  // for x^2
        signature_n[15] = signature[14] ^ data_in_FF[15];
    end
end

always @(posedge clk) begin
    if (~rst_n) begin
        signature <= 16'd0; // Initialize signature to 0
    end 
    else begin
        signature <= signature_n;
    end
end

always @(posedge clk) begin
    data_in_FF <= data_in;
end

endmodule