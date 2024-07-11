module tb_top;
    bit clk;
    rgu_main dut(clk);

    initial begin
        clk = 0;
        #10 clk = !clk;
        #10 clk = !clk;
        #10 clk = !clk;
        #10 clk = !clk;
        #10 $finish;
    end
endmodule