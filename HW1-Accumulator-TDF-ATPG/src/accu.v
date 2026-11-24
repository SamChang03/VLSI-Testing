module accu
(
    input clk,
    input [1:0] X,
    output reg [3:0] AC
);

wire [3:0] AC_n;
wire [2:0] Cout;

HalfAdder HA_0(.A(AC[0]),.B(X[0]), .SUM(AC_n[0]),.Cout(Cout[0]));
FullAdder FA_0(.A(AC[1]),.B(X[1]),.Cin(Cout[0]),.SUM(AC_n[1]),.Cout(Cout[1]));
HalfAdder HA_1(.A(AC[2]),.B(Cout[1]), .SUM(AC_n[2]),.Cout(Cout[2]));
assign AC_n[3] = AC[3] ^ Cout[2];

always @(posedge clk ) begin
    AC <= AC_n;
end
endmodule

module FullAdder (
    input A,
    input B,
    input Cin,

    output SUM,
    output Cout
);
assign SUM = A ^ B ^ Cin;
assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule

module HalfAdder (
    input A,
    input B,

    output SUM,
    output Cout
);
assign SUM = A ^ B;
assign Cout = A & B;
endmodule
