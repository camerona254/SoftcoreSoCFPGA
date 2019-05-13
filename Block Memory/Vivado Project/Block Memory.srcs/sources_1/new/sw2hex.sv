`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Cameron Anderson 
// 
//////////////////////////////////////////////////////////////////////////////////


module sw2hex
(
    input logic clk, reset,
    input logic [15:0] switches,
    output logic [3:0] hex0, hex1, hex2, hex3
);

    
disp_hex_mux disp_hex_mux
(
    .clk(clk),
    .reset(reset),
    .hex0(hex0),
    .hex1(hex1),
    .hex2(hex2),
    .hex3(hex3),
    .dp_in(4'b1111) // decimal points off (active low)
);
    
assign hex3 = switches[15:12];
assign hex2 = switches[11:8];
assign hex1 = switches[7:4];
assign hex0 = switches[3:0];

endmodule
