import uvm_pkg::*;
`include "uvm_macros.svh"

import rgu_test_lib_pkg::*;

module tb_top;
    bit PCLK,PRESETn;

    apb_if apb_if0( .PCLK(PCLK),
                    .PRESETn(PRESETn));

    apb_driver_bfm apb_driver_bfm0( .PCLK(apb_if0.PCLK),
                                    .PRESETn(apb_if0.PRESETn),
                                    .PADDR(apb_if0.PADDR),
                                    .PRDATA(apb_if0.PRDATA),
                                    .PWDATA(apb_if0.PWDATA),
                                    .PSEL(apb_if0.PSEL),
                                    .PENABLE(apb_if0.PENABLE),
                                    .PWRITE(apb_if0.PWRITE),
                                    .PREADY(apb_if0.PREADY));
    
    apb_monitor_bfm apb_monitor_bfm0( .PCLK(apb_if0.PCLK),
                                      .PRESETn(apb_if0.PRESETn),
                                      .PADDR(apb_if0.PADDR),
                                      .PRDATA(apb_if0.PRDATA),
                                      .PWDATA(apb_if0.PWDATA),
                                      .PSEL(apb_if0.PSEL),
                                      .PENABLE(apb_if0.PENABLE),
                                      .PWRITE(apb_if0.PWRITE),
                                      .PREADY(apb_if0.PREADY));

    initial begin
        uvm_config_db#(virtual apb_driver_bfm)::set(null,"uvm_test_top","APB_drv_bfm",apb_driver_bfm0);
        uvm_config_db#(virtual apb_monitor_bfm)::set(null,"uvm_test_top","APB_mon_bfm",apb_monitor_bfm0);
    end

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
