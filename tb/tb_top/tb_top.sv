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
        repeat(4) @(posedge clk);
        PRESETn = 1;
    end
endmodule
