`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////


module rd_wr_state_machine
(
    input logic clk,
    input logic reset,
    input logic [15:0] sw,
    input logic [3:0] btn,
    output logic [3:0] an,
    output logic [7:0] sseg
);

typedef enum {addMSB, storeMSB, addLSB, storeLSB, display, writeMSB, writeLSB} state_type;

// declarations
state_type state_reg, state_next;    

logic address; // top button [0] is the address button
logic read; // left button [3] is the read button
logic write; // right button [1] is the write button 
logic restart; // bottom button [2] is the restart button
logic [31:0] display_seven; // 8 hex digits for seven seg display
logic [31:0] address_bits;
logic BRAM_en;
logic [3:0] BRAM_wr_en;
logic [31:0] BRAM_data_in;
logic [31:0] BRAM_data_out;

BRAM_wrapper BRAM_wrapper
(
    .addr(address_bits),
    .clk(clk),
    .reset(reset),
    .din(BRAM_data_in),
    .dout(BRAM_data_out),
    .en(BRAM_en),
    .write_en(BRAM_wr_en)    
);

always_ff @ (posedge clk, posedge reset)
    if (reset)
    begin
        state_reg <= addMSB; // start
    end
    else
    begin
        state_reg <= state_next;
    end   

always_comb
begin
    state_next = state_reg;
    case (state_reg)
        addMSB:
        begin
            display_seven[31:16] = sw[15:0]; // MSB 4 digits of seven segment display mirrors the active switches
            display_seven[15:0] = address_bits[15:0]; // LSB 4 digits of seven segment display show active address LSB
            if (address) // debounce
            begin
                address_bits[31:16] = sw[15:0]; // store switches as address MSB
                state_next = storeMSB;
            end
        end
        storeMSB:
        begin
            // blink the seven segment display to show change
            state_next = addLSB;
        end
        addLSB:
        begin
            display_seven[31:16] = address_bits[31:16]; // MSB 4 digits of seven segment display show active address MSB
            display_seven[15:0] = sw[15:0]; // LSB 4 digits of seven segment display mirrors the active switches
            if (address) // debounce
            begin
                address_bits[15:0] = sw[15:0]; // store switches as address LSB
                state_next = storeLSB;
            end
        end
        storeLSB:
        begin 
            // blink the seven segment display to show change
            if (read) // debounce
            begin
                state_next = display;
            end
            else if (write) // debounce
            begin
                
                state_next = writeMSB;
            end
        end
        display:
        begin
            BRAM_en = 1'b0; // enable (active low)
            display_seven = BRAM_data_out; // display contents of address on 7 seg display
            if (restart) // debounce
            begin
                BRAM_en = 1'b1; // disable (active low)
                display_seven = address_bits;
                state_next = addMSB;
            end
        end
        writeMSB:
        begin
            // write switches to MSB of selected register in BRAM
            // blink the seven segment display to show change
            if (write) // debounce
            begin
                state_next = writeLSB;
            end 
        end
        writeLSB:
        begin
            // write switches to LSB of selected register in BRAM
            // blink the seven segment display to show change
            if (restart) // debounce
            begin
                state_next = addMSB;
            end
        end
    endcase
end
endmodule