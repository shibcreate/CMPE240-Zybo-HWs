module top1();

    // port a
    wire [12:0] BRAM_PORTA_0_addr;
    wire        clk;
    wire [31:0] BRAM_PORTA_0_din;
    wire [31:0] BRAM_PORTA_0_dout;
    wire        BRAM_PORTA_0_en;
    wire        BRAM_PORTA_0_rst;
    wire        BRAM_PORTA_0_we;
    wire        rst;

    // port b
    reg  [10:0] BRAM_PORTB_0_addr = 0;
    reg  [31:0] BRAM_PORTB_0_din  = 0;
    reg         BRAM_PORTB_0_we   = 1'b0;

    design_1_wrapper design_1_wrapper_inst (
        .BRAM_PORTA_0_addr (BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk  (clk),
        .BRAM_PORTA_0_din  (BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout (BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_en   (BRAM_PORTA_0_en),
        .BRAM_PORTA_0_rst  (BRAM_PORTA_0_rst),
        .BRAM_PORTA_0_we   (BRAM_PORTA_0_we)
    );

    blk_mem_gen_0 blk_mem_gen_0_inst (
        .clka  (clk),
        .ena   (BRAM_PORTA_0_en),
        .wea   (BRAM_PORTA_0_we),
        .addra (BRAM_PORTA_0_addr[12:2]),
        .dina  (BRAM_PORTA_0_din),
        .douta (BRAM_PORTA_0_dout),
        .clkb  (clk),
        .enb   (1),
        .web   (BRAM_PORTB_0_we),
        .addrb (BRAM_PORTB_0_addr),
        .dinb  (BRAM_PORTB_0_din),
        .doutb ()
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            BRAM_PORTB_0_addr <= #0.1 0;
            BRAM_PORTB_0_we   <= #0.1 0;
            BRAM_PORTB_0_din  <= #0.1 0;
        end else begin
            if (BRAM_PORTB_0_addr != 11'h7ff) begin
                BRAM_PORTB_0_addr <= #0.1 BRAM_PORTB_0_addr + 1;
                BRAM_PORTB_0_we   <= #0.1 1;
                BRAM_PORTB_0_din  <= #0.1 BRAM_PORTB_0_din + 1;
            end else begin
                BRAM_PORTB_0_we   <= #0.1 0;
            end
        end
    end

endmodule
