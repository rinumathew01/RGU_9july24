module APB_rgu(

    input clk,
    input sys_pwrgd,
    input sys_reset_n,
    input sb_wdt_rst_n,
    input [3:0] wdt_rst_n,

    input PCLK,
    input PRESETn,
    input [11:0] PADDR,
    input PWRITE,
    input [31:0] PWDATA,
    input PSEL,
    input PENABLE,

    output reg [31:0] PRDATA,
    output reg PREADY,
    output reg PSLVERR,

    output reg rst_sb_sys_n,
    output reg rst_sb_dmac_n,
    output reg rst_sb_qspi_n,
    output reg rst_sb_i2c_n,
    output reg rst_sb_uart_n,
    output reg rst_sb_gpio_n,
    output reg rst_sb_sram_n,
    output reg rst_sb_wdt_n,
    output reg rst_sb_cpu_n,
    output reg rst_sys_n,
    output reg rst_wdt_n,
    output reg rst_gpt_n,
    output reg rst_sram_n,
    output reg rst_ddr_n,
    output reg rst_usb_n,
    output reg rst_mmc_n,
    output reg rst_dmac_n,
    output reg rst_qspi_n,
    output reg rst_spi_n,
    output reg rst_i2c_n,
    output reg rst_uart_n,
    output reg rst_gpio_n,
    output reg rst_pwm_n,
    output reg rst_i2s_n,
    output reg rst_gpu_n,
    output reg rst_videc_n,
    output reg rst_vicod_n,
    output reg rst_camera_n,
    output reg rst_display_n,
    output reg rst_llc_n,
    output reg rst_cpu_n
);


always_ff @(posedge PCLK or negedge PRESETn)

    if(!PRESETn)
    begin
        PRDATA <= 32'b0;
        PREADY <= 1'b0;
        PSLVERR <= 1'b0;
    end
    else
    begin
        PREADY <= PREADY_reg && ~PREADY;
    end

always_ff @(posedge clk)
    PREADY_reg <= PENABLE && PSEL && ~PREADY_reg && ~PREADY;

always_ff @(posedge clk)
        if(PENABLE && PSEL)
            if(PWRITE)
                case(PADDR);
                12'h000: RGU_GLB <= PWDATA;
                12'h004: RGU_RST_STATUS <= PWDATA;
                12'h008: RGU_TIMER0 <= PWDATA;
                12'h00C: RGU_TIMER1 <= PWDATA;
                12'h010: RGU_SB_SWRST <= PWDATA;
                12'h014: RGU_SYS_SWRST <= PWDATA;
                12'h018: RGU_SRAM_SWRST <= PWDATA;
                12'h01C: RGU_DDR_SWRST <= PWDATA;
                12'h020: RGU_USB_SWRST <= PWDATA;
                12'h024: RGU_MMC_SWRST <= PWDATA;
                12'h028: RGU_DMAC_SWRST <= PWDATA;
                12'h02C: RGU_QSPI_SWRST <= PWDATA;
                12'h030: RGU_SPI_SWRST <= PWDATA;
                12'h034: RGU_I2C_SWRST <= PWDATA;
                12'h038: RGU_UART_SWRS <= PWDATA;
                12'h03C: RGU_GPIO_SWRS <= PWDATA;
                12'h040: RGU_I2S_SWRST <= PWDATA;
                12'h044: RGU_GPU_SWRST <= PWDATA;
                12'h048: RGU_VIDEC_SWRS <= PWDATA;
                12'h04C: RGU_VICOD_SWRS <= PWDATA;
                12'h050: RGU_CAMERA_SWR <= PWDATA;
                12'h054: RGU_DISPLAY_SW <= PWDATA;
                12'h058: RGU_LLC_SWRST <= PWDATA;
                12'h05C: RGU_CPU_SWRST <= PWDATA;
                12'h060: RGU_PWM_SWRST  <= PWDATA;
                12'h064: RGU_CPU_PWRUP_SWRST <= PWDATA;
                12'h068: RGU_CPU_PWRUP_HEAVY_­SWRST <= PWDATA;
                default: begin
                             PSLVERR<=1;
                         end 
                endcase
            else
                case(PADDR);
                12'h000: PRDATA <= RGU_GLB;
                12'h004: PRDATA <= RGU_RST_STATUS;
                12'h008: PRDATA <= RGU_TIMER0;
                12'h00C: PRDATA <= RGU_TIMER1;
                12'h010: PRDATA <= RGU_SB_SWRST;
                12'h014: PRDATA <= RGU_SYS_SWRST;
                12'h018: PRDATA <= RGU_SRAM_SWRST;
                12'h01C: PRDATA <= RGU_DDR_SWRST;
                12'h020: PRDATA <= RGU_USB_SWRST;
                12'h024: PRDATA <= RGU_MMC_SWRST;
                12'h028: PRDATA <= RGU_DMAC_SWRST;
                12'h02C: PRDATA <= RGU_QSPI_SWRST;
                12'h030: PRDATA <= RGU_SPI_SWRST;
                12'h034: PRDATA <= RGU_I2C_SWRST;
                12'h038: PRDATA <= RGU_UART_SWRS;
                12'h03C: PRDATA <= RGU_GPIO_SWRS;
                12'h040: PRDATA <= RGU_I2S_SWRST;
                12'h044: PRDATA <= RGU_GPU_SWRST;
                12'h048: PRDATA <= RGU_VIDEC_SWRS;
                12'h04C: PRDATA <= RGU_VICOD_SWRS;
                12'h050: PRDATA <= RGU_CAMERA_SWR;
                12'h054: PRDATA <= RGU_DISPLAY_SW;
                12'h058: PRDATA <= RGU_LLC_SWRST;
                12'h05C: PRDATA <= RGU_CPU_SWRST;
                12'h060: PRDATA <= RGU_PWM_SWRST ;
                12'h064: PRDATA <= RGU_CPU_PWRUP_SWRST;
                12'h068: PRDATA <= RGU_CPU_PWRUP_HEAVY_­SWRST;
                default: begin
                             PSLVERR<=1;
                         end 
                endcase


    // if(!sys_pwrgd)
    //     begin
    //          rst_sb_sys_n <= 0;
    //          rst_sb_dmac_n <= 0;
    //          rst_sb_qspi_n <= 0;
    //          rst_sb_i2c_n <= 0;
    //          rst_sb_uart_n <= 0;
    //          rst_sb_gpio_n <= 0;
    //          rst_sb_sram_n <= 0;
    //          rst_sb_wdt_n <= 0;
    //          rst_sb_cpu_n <= 0;
    //          rst_sys_n <= 0;
    //          rst_wdt_n <= 0;
    //          rst_gpt_n <= 0;
    //          rst_sram_n <= 0;
    //          rst_ddr_n <= 0;
    //          rst_usb_n <= 0;
    //          rst_mmc_n <= 0;
    //          rst_dmac_n <= 0;
    //          rst_qspi_n <= 0;
    //          rst_spi_n <= 0;
    //          rst_i2c_n <= 0;
    //          rst_uart_n <= 0;
    //          rst_gpio_n <= 0;
    //          rst_pwm_n <= 0;
    //          rst_i2s_n <= 0;
    //          rst_gpu_n <= 0;
    //          rst_videc_n <= 0;
    //          rst_vicod_n <= 0;
    //          rst_camera_n <= 0;
    //          rst_display_n <= 0;
    //          rst_llc_n <= 0;
    //          rst_cpu_n <= 0;
    //          rst_cpu_pwrup_n <= 0;
    //          rst_cpu_pwrup_heavy_n <= 0;
    //     end
    // else
    always_ff @(posedge clk)
        begin
             rst_sb_sys_n <= stage0_done;
             rst_sb_dmac_n <= stage0_done & ~SB_DMAC_SWRST;
             rst_sb_qspi_n <= stage0_done & ~SB_QSPI_SWRST
             rst_sb_i2c_n <= stage0_done & ~SB_I2C_SWRST;
             rst_sb_uart_n <= stage0_done & ~SB_UART_SWRST;
             rst_sb_gpio_n <= stage0_done & ~SB_GPIO_SWRST;
             rst_sb_sram_n <= stage0_done & ~SB_SRAM_SWRST;

             rst_sb_wdt_n <= stage1_done;
             rst_sb_cpu_n <= stage1_done;

             rst_sys_n <= stage1_done & ~SYS_SWRST;
             rst_wdt_n <= {4'{stage1_done & ~SYS_SWRST}};
             rst_gpt_n <= {8'{stage1_done & ~SYS_SWRST}};
             rst_sram_n <= stage1_done & ~SRAM_SWRST;
             rst_ddr_n <= stage1_done & ~DDR_SWRST;
             rst_usb_n <= stage1_done & ~USB_SWRST;
             rst_mmc_n <= stage1_done & ~MMC_SWRST;
             rst_dmac_n <= stage1_done & ~DMAC_SWRST;
             rst_qspi_n <= stage1_done & ~QSPI_SWRST;
             rst_spi_n <= stage1_done & ~SPI_SWRST;
             rst_i2c_n <= stage1_done & ~I2C_SWRST;
             rst_uart_n <= stage1_done & ~UART_SWRST;
             rst_gpio_n <= stage1_done & ~GPIO_SWRST;
             rst_pwm_n <= stage1_done & ~PWM_SWRST;
             rst_i2s_n <= stage1_done & ~I2S_SWRST;
             rst_gpu_n <= stage1_done & ~GPU_SWRST;
             rst_videc_n <= stage1_done & ~VIDEC_SWRST;
             rst_vicod_n <= stage1_done & ~VICOD_SWRST;
             rst_camera_n <= stage1_done & ~CAMERA_SWRST;
             rst_display_n <= stage1_done & ~DISPLAY_SWRST;
             rst_llc_n <= stage1_done & ~LLC_SWRST;
             rst_cpu_n <= stage1_done & ~CPU_SWRST;
             rst_cpu_pwrup_n <= stage1_done & ~CPU_PWRUP_SWRST;
             rst_cpu_pwrup_heavy_n <= stage1_done & ~CPU_PWRUP_HEAVY_SWRST;
        end


    reg [2:0] count_sys_reset_n;

    always_ff @(posedge clk or negedge sys_pwrgd)

endmodule 