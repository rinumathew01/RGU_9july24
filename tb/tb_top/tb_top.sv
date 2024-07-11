import uvm_pkg::*;
`include "uvm_macros.svh"

import rgu_test_lib_pkg::*;

module tb_top;
    bit PCLK,PRESETn;

    apb_if apb_if0( .PCLK(PCLK),
                    .PRESETn(PRESETn));

    

    initial begin
        PCLK = 0;
        forever #10 PCLK = !PCLK;
    end

    initial begin
        PRESETn = 0;
        repeat(4) @(posedge PCLK);
        PRESETn = 1;
        #100 $finish;
    end

    initial begin
        run_test();
    end
endmodule
