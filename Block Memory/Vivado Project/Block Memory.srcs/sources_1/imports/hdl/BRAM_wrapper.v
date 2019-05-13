`timescale 1 ps / 1 ps

module BRAM_wrapper
(
    input logic [31:0] addr,
    input logic clk,
    input logic [31:0] din,
    output logic [31:0] dout,
    input logic en,
    input logic reset,
    input logic [3:0] write_en
);

BRAM BRAM_i
(
    .BRAM_PORTA_0_addr(addr),
    .BRAM_PORTA_0_clk(clk),
    .BRAM_PORTA_0_din(din),
    .BRAM_PORTA_0_dout(dout),
    .BRAM_PORTA_0_en(en),
    .BRAM_PORTA_0_rst(reset),
    .BRAM_PORTA_0_we(write_en)
);

endmodule
