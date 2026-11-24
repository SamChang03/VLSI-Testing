`timescale 1ns/1ps

module accu_tb;

localparam  N = 544,
            K = 514;
//======test pattern para======
reg [15:0] inputs [0:999];
reg [31:0] golden [0:999];
//======input======
reg clk;
reg rst_n;
reg [15:0] X;
//======output======
wire [31:0] AC;

integer j, i, err;
reg [31:0] ac_ref;

accu i_accu (
    //======input======
    .clk(clk),
    .rst_n(rst_n),
    .X(X),
    //======output======
    .AC(AC)
);

parameter CYCLE = 2.0;
parameter END_CYCLE = 1500;
parameter pattern_num = 1000;

always #(CYCLE/2.0) clk = ~clk;

initial begin
    `ifdef GATESIM
        $sdf_annotate( "../syn/netlist/accu_syn.sdf", i_accu);
        $fsdbDumpfile("accu_syn.fsdb");
        $fsdbDumpvars;
        $fsdbDumpvars("+mda");
    `else
        $fsdbDumpfile("accu.fsdb");
        $fsdbDumpvars;
        $fsdbDumpvars("+mda");
    `endif
end

initial begin
    clk = 0;
    rst_n = 1;
    ac_ref = 0;
    err = 0;
    #(CYCLE) rst_n = 0;
    #(CYCLE) rst_n = 1;  
end

//===============================================
//	READ TEST PATTERN
//===============================================
initial begin
    $readmemh("../pattern/pattern_input_16bits.data", inputs);
    $readmemh("../pattern/expected_output_32bits.data", golden);
end


//===============================================
//	VALIDATE RESULTS
//===============================================
initial begin
        wait(rst_n == 0);
        wait(rst_n == 1);

        for (i = 0; i < pattern_num; i = i + 1) begin
            X = inputs[i];
            
            @(negedge clk); 
            ac_ref = ac_ref + X;  

            if (AC !== golden[i]) begin
                err = err + 1;
                $display("   Pattern %0d failed!", i);
                $display("   Input  : X = %h", X);
                $display("   Output : AC = %h", AC);
                $display("   Expect : AC = %h", golden[i]);
                $finish; 
            end
        end

    if (err === 0) begin
        #(CYCLE*10);
        print_success;
    end else begin
        #(CYCLE*10);
        print_fail;
    end
end


initial begin
    #(CYCLE*END_CYCLE);
    $display("\n====================================\n");
    $display("     EXCEED %7d CYCLES !!!     \n", END_CYCLE);
    $display("====================================\n");
    $finish;
end

task print_success;
    begin
        $display("%c[1;34m",27);
        $write("\n");
        $write("=============================            ");$write("|__||\n");
        $write("                                       ");$write(" / ^.^  |\n");
        $write("    Congratulation !!!                ");$write("/_____   |\n");
        $write("    All Simulations PASS            ");$write(" /^ ^ ^ \\  |\n");
        $write("                                  ");$write("  |^ ^ ^ ^ |W|\n");
        $write("=============================    ");$write("    \\m___m__|_|\n");
        $write("\n");
        $display("%c[0m",27);
        $finish;
    end
endtask

task print_fail;
    begin
        $display("%c[1;31m",27);
        $write("\n");
        $write("=============================            ");$write("|__||\n");
        $write("                                       ");$write(" / @.@  |\n");
        $write("   Simulation Fail !!!                ");$write("/_____   |\n");
        $write("                                    ");$write(" /^ ^ ^ \\  |\n");
        $write("=============================     ");$write("  |^ ^ ^ ^ |W|\n");
        $write("                                ");$write("    \\m___m__|_|\n");
        $write("\n");
        $display("%c[0m",27);
        $finish;
    end
endtask

endmodule
