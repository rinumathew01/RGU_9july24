module APB_rgu(
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

    output reg [11:0] addr,
    output reg [31:0] data,
    output reg rw
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


endmodule 