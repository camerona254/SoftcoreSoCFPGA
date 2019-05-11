`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Cameron Anderson
// 
//////////////////////////////////////////////////////////////////////////////////


module state_machine
    (
    input logic clk,
    input logic display_clk,
    input logic reset,
    input logic start,
    //input  logic [7:0] sw,
    output logic [7:0] an,
    output logic [7:0] sseg,
    //input logic start,
    //input logic stop,
    output logic led[15],
    output logic [7:0] sevenseg
    );
    
// fsm state type
typedef enum {init, starter, test, reaction, tooslow, cheater} state_type;

// declaration
state_type state_reg, state_next;    
//logic led[15]; // initialize visual cue led 
logic cheat; // initialize "9999" display signal
logic HI; // initialize "HI" display signal
logic ERR; // initialize "ERR" display signal
logic [4:0] count1; // initialize 1st counter
logic [4:0] count2; // initialize 2nd counter
logic random; // initialize random number to make the timer unpredictable
logic [7:0] led0, led1, led2, led3; // output from hex_to_sseg and input to disp_mux

// instantiate clock divider to use the millisecond clock
clock_divider clock_divider
    (.clk(clk), .reset(reset), .display_clk(display_clk));
    
// instantiate 7-seg LED display time-multiplexing module
disp_mux disp_unit
    (.clk(clk), .reset(1'b0), .in0(led0), .in1(led1),
     .in2(led2), .in3(led3), .an(an), .sseg(sseg));
     
//instantiate 1st seven segment digit module
hex_to_sseg sseg_unit_0
    (.hex(1'h4), .decimal_point(1'b1), .sseg(led0));
    
//instantiate 2nd seven segment digit module
hex_to_sseg sseg_unit_1
    (.hex(1'h3), .decimal_point(1'b0), .sseg(led1));
    
//instantiate 3rd seven segment digit module
hex_to_sseg sseg_unit_2
    (.hex(1'h2), .decimal_point(1'b1), .sseg(led2));

//instantiate 3rd seven segment digit module
hex_to_sseg sseg_unit_3
    (.hex(1'h1), .decimal_point(1'b0), .sseg(led3));
             
always_ff @(posedge clk, posedge reset)
    if (reset)
    begin
        state_reg <= init; // start
        count1 <= 5'b00000; // reset the 1st counter
        count2 <= 5'b00000;
    end
    else // enable state machine
    begin
        state_reg <= state_next;
        count1 <= count1_next;
        count2 <= count2_next;
    end

/*always_ff @ (posedge display_clk)
    if (state_reg == test)
        begin
            count2 <= count2 + 1; // start 2nd counter
        end
    else if (state_reg == starter)
        begin
            count1 <= count1 + 1; // start 1st counter
        end
    else
        begin
        end*/
        
always_comb
begin
    state_next = state_reg;
    case (state_reg)
        init:
        begin
            HI = 1'b1; // seven segment display says "HI"
            cheat = 1'b0;
            count1_next = 5'b00000; // clear 1st counter
            // get random number for counter start time
            if (start) // start button is pressed
            begin
                count2_next = 5'b00000; // clear the 2nd counter
                state_next = starter; // move to the next state
            end
        end
        starter:
            HI = 1'b0; // turns off the "HI" message
            sevenseg = 1'b0; // seven segment display is off
            cheat = 1'b0; // turns off seven segment display = "9999"
            // start 1st counter
            if (stop) // used to pickup a false start
                begin
                    state_next = cheater; // move to the next state
                end
            if (count1 = random) // used to start the timer at a random time
                begin
                    state_next = test; // move to the next state
                end
        test:
            HI = 1'b0; // turns off the "HI" message
            cheat = 1'b0; // turns off seven segment display = "9999"
            // turn on LED
            // start 2nd counter
            sevenseg = count2; // seven segment display = 2nd counter
            if (count2 = 1000)
                begin
                    state_next = tooslow; // move to the next state
                end
            if (stop)
                begin
                    state_next = reaction; // move to the next state
                end
        reaction:
            HI = 1'b0; // turns off the "HI" message
            cheat = 1'b0; // turns off seven segment display = "9999"
            LED = 1'b0; // turn off LED
            // stop 2nd counter
            sevenseg = count2; // display time from the 2nd counter
            if (reset)
                begin
                    state_next = init; // reset the timer
                end
                
        tooslow:
            HI = 1'b0; // turns off the "HI" message
            cheat = 1'b0; // turns off seven segment display = "9999"
            led = 1'b0; // turn off LED
            sevenseg = 1000; // seven segment display = 1000
            if (reset)
                begin
                    state_next = init; // reset the timer
                end
        cheater:
            HI = 1'b0; // turns off the "HI" message
            cheat = 1'b1; // seven segment display = "9999"
            if (reset)
                begin
                    state_next = init; // reset the timer
                end
        default: 
            ERR = 1'b1; // seven segment display says "ERR"
    endcase
end

endmodule
