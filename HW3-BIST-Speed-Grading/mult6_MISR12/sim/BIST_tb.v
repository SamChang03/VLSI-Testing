`timescale 100ps/1ps

`define CYCLE_LOW 5
`define CYCLE_UP 20
`define END_CYCLE 100*(`CYCLE_UP-`CYCLE_LOW+1)

module BIST_tb;

//======input======
reg clk;
reg rst_n;
reg start_test;
//======output======
wire test_done,test_fail;

mul_BIST i_mul_BIST
(
    //======input======
    .clk(clk),
    .rst_n(rst_n),
    .start_test(start_test),
    //======output======
    .test_fail(test_fail),
    .test_done(test_done)
);


initial begin
    `ifdef GATESIM
        $sdf_annotate( "../syn/netlist/mul_BIST_syn.sdf", i_mul_BIST);
        $fsdbDumpfile("mul_BIST_syn.fsdb");
        $fsdbDumpvars;
        $fsdbDumpvars("+mda");
    `else
        $fsdbDumpfile("mul_BIST.fsdb");
        $fsdbDumpvars;
        $fsdbDumpvars("+mda");
    `endif
end

integer CYCLE;

initial begin
    if(`CYCLE_LOW > `CYCLE_UP || `CYCLE_LOW < 0 || `CYCLE_UP < 0  ) begin
        $display("%c[1;31m",27);
		$display("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		$display("X                                                        X");
		$display("X Error!! The Range of CYCLE_L and CYCLE_UP is not valid X");
		$display("X                                                        X");
		$display("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
        $display("%c[0m",27);
		$finish;		
	end
    for (CYCLE = `CYCLE_UP; CYCLE >= `CYCLE_LOW ;  CYCLE = CYCLE -1) begin
        #(CYCLE) rst_n = 0; start_test = 0;
        #(5*CYCLE) rst_n = 1; start_test = 1;

        wait (test_done);
        if (test_fail === 0) begin
            #(CYCLE*2);
            print_success;
        end 
        else begin
            #(CYCLE*2);
            print_fail;
        end
    end
    $finish;
end

initial begin
    clk = 0;
     while (1) begin
        #(CYCLE/2.0) clk = ~clk;
     end
end


initial begin
    #(CYCLE*`END_CYCLE);
    print_fail;
    $display("\n====================================\n");
    $display("    Simulation Time Is Too Long     \n");
    $display("   Stop Simulation Automatically    \n");
    $display("====================================\n");
    $finish;
end

task print_success;
    begin
        $display("%c[1;34m",27);
        $write("============================= \n");
        $write("    Timing = %3dns PASS !!!   \n", CYCLE*100);
        $write("============================= ");
        $display("%c[0m",27);
        //$finish;
    end
endtask

task print_fail;
    begin
        $display("%c[1;31m",27);
        $write("============================= \n");
        $write("      Simulation Fail !!!     \n");
        $write("      Wrong Timing = %3dns    \n", CYCLE*100);
        $write("============================= \n");
        $display("%c[0m",27);
        //$finish;
    end
endtask

endmodule
