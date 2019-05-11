`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// 
// Cameron Anderson
// 
//////////////////////////////////////////////////////////////////////////////////

// N = 2 to display microseconds
// N = 5 to display milliseconds
// N = 8 to display seconds

module clock_divider
    (
    input logic clk, // input of 100MHz system clock
    input logic reset, // input to reset the counter
    output logic [3:0] display_clk // outputs 4 digits to represent whichever fraction of a second the user chooses
    );
   
    localparam N = 5; // used to set the 4 display digits
    // N = 2 to display microseconds
    // N = 5 to display milliseconds
    // N = 8 to display seconds
    
    logic [11:0] count; // counter mirrors system clock and overruns at 10 seconds
    
    always_ff @(posedge clk) // increments the counter with each period of the system clock
        if (reset)
            begin
                count <= 12'b000000000000;
            end
          else
            begin
                count <= count+1;
            end
            
    assign display_clk = count[N+3:N]; // sends the seconds, milliseconds, or microseconds to the display clock

endmodule
