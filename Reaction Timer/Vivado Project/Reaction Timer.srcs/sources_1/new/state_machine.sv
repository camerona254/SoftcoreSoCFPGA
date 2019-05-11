`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Cameron Anderson
// 
//////////////////////////////////////////////////////////////////////////////////


module state_machine
    (
    input logic clk,
    input logic [3:0] dsp_clk,
    input logic reset, 
    input logic [2:0] btn,
    output logic ERR, HI, SLOW, CHEAT,
    inout logic [3:0] an,
    output logic [7:0] sseg,
    output logic led[15]
    );
    
// fsm state type
typedef enum {init, starter, test, reaction, tooslow, cheater} state_type;

// declarations
state_type state_reg, state_next;    
logic main_clock;
logic rst;
logic LED; // initialize visual cue led 
//logic CHEAT; // initialize "9999" display signal
//logic HI; // initialize "HI" display signal
//logic ERR; // initialize "ERR" display signal
//logic SLOW; // initialize sevenseg counter display
logic [15:0] count1; // initialize 1st counter memory
logic [15:0] count1_next; // initialize 1st counter signal
logic [15:0] count2; // initialize 2nd counter memory
logic [15:0] count2_next; // initialize 2nd counter signal
logic random; // initialize random number to make the timer unpredictable
logic start;
logic stop;
logic [7:0] led0, led1, led2, led3; // output from hex_to_sseg and input to disp_mux
logic [3:0] hex0, hex1, hex2, hex3;
logic [7:0] sevenseg; // internal seven segment display signals

// instantiate clock divider to use the millisecond clock
clock_divider clock_divider
    #(parameter N = 5)
    (
    .clk(main_clock),
    .reset(rst), 
    .display_clk(dsp_clk)
    );
    
// instantiate 7-seg LED display time-multiplexing module
disp_mux disp_unit
    (
    .clk(main_clock), 
    .reset(rst),
    .SLOW(SLOW),
    .HI(HI),
    .ERR(ERR),
    .CHEATER(CHEAT), 
    .in0(led0), .in1(led1), .in2(led2), .in3(led3), 
    .an(an), 
    .ssegd(sevenseg)
    );
     
// instantiate 1st seven segment digit module
hex_to_sseg sseg_unit_0
    (
    .hex(hex0), 
    .decimal_point(1'b1), 
    .sseg(led0)
    );
    
//instantiate 2nd seven segment digit module
hex_to_sseg sseg_unit_1
    (
    .hex(hex1), 
    .decimal_point(1'b0), 
    .sseg(led1)
    );
    
// instantiate 3rd seven segment digit module
hex_to_sseg sseg_unit_2
    (
    .hex(hex2), 
    .decimal_point(1'b1), 
    .sseg(led2)
    );

// instantiate 3rd seven segment digit module
hex_to_sseg sseg_unit_3
    (
    .hex(hex3), 
    .decimal_point(1'b0), 
    .sseg(led3)
    );

// memory logic for fsm             
/*always_ff @(posedge clk, posedge reset)
    if (reset)
    begin
        
    end
    else // enable state machine
    begin
        
    end*/

// memory logic for counter
always_ff @ (posedge dsp_clk[0], posedge reset)
    if (reset)
    begin
        state_reg <= init; // start
        count1 <= 0; // reset the 1st counter
        count2 <= 0; // reset the 2nd counter
    end
    else
    begin
        state_reg <= state_next;
        count1 <= count1_next;
        count2 <= count2_next;
    end         
        
always_comb
begin
    state_next = state_reg;
    case (state_reg)
        init:
        begin
            HI = 1'b1; // turn on "HI"
            LED = 1'b0; // turn LED off
            count1_next = 0; // clear 1st counter
            random = 3000; // get random number for counter start time
            if (start) // start button is pressed
            begin
                HI = 1'b0; // turn off "HI"
                state_next = starter;
            end
        end
        starter:
        begin
            count2_next = 0; // clear the 2nd counter
            count1_next = count1_next + 1; // start 1st counter
            if (stop) // used to pickup a false start
            begin
                count1_next = count1_next; // stop the 1st counter
                state_next = cheater; // move to the next state
            end
            if (count1 == random) // used to start the timer at a random time
            begin
                count1_next = count1_next; // stop the 1st counter                
                state_next = test; // move to the next state
            end
        end
        test:
        begin
            LED = 1'b1; // turn on stimulus LED
            count2_next = count2_next + 1; // start 2nd counter
            if (count2 == 1000)
            begin
                count2_next = count2_next; // stop 2nd counter
                state_next = tooslow; // move to the next state
            end
            if (stop)
            begin
                count2_next = count2_next; // stop 2nd counter
                state_next = reaction; // move to the next state
            end
        end
        reaction:
        begin
            LED = 1'b0; // turn off LED
            hex0 = count2[3:0]; // display time from the 2nd counter
            hex1 = count2[7:4]; // display time from the 2nd counter
            hex2 = count2[11:8]; // display time from the 2nd counter
            hex3 = count2[15:12]; // display time from the 2nd counter
            if (reset) // reset the timer
            begin
                state_next = init; 
            end
        end        
        tooslow:
        begin
            LED = 1'b0; // turn on stimulus LED
            SLOW = 1'b1; // turn on "1000"
            if (reset) // reset the timer
            begin
                SLOW = 1'b0; // turn off "1000"
                state_next = init;
            end
        end
        cheater:
        begin
            CHEAT = 1'b1; // turn on "9999"
            if (reset) // reset the timer
            begin
                CHEAT = 1'b0; // turn off "9999"
                state_next = init; 
            end
        end
        default: // turn on "ERR" 
        begin 
            ERR = 1'b1; 
        end
    endcase
end

assign led[15] = LED;
assign start = btn[0];
assign stop = btn[2];
assign main_clock = clk;
assign rst = reset;
assign sseg = sevenseg;

endmodule
