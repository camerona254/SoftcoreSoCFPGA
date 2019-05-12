`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// 
// Cameron Anderson
// 
//////////////////////////////////////////////////////////////////////////////////

module clock_divider
    (
    input logic clk, // input of 100MHz system clock
    input logic reset, // input to reset the counter
    output logic ms_clk // outputs 4 digits to represent whichever fraction of a second the user chooses
    );
   
    typedef enum {minus, ms_zero, ms_one} state_type;
    
    // declarations
    state_type state_reg, state_next;
    logic [15:0] count;
    logic [15:0] count_next; 

    always_ff @(posedge clk, posedge reset) 
        if (reset)
        begin
            state_reg <= ms_zero;
        end
        else
        begin
            state_reg <= state_next;
            count <= count_next;
        end
        
    always_comb
    begin
        state_next = state_reg;
        case (state_reg)
            ms_one:
            begin
                ms_clk = 0;
                count_next = 16'd50000;
                state_next = minus;
            end
            ms_zero:
            begin
                ms_clk = 1;
                count_next = 16'd50000;
                state_next = minus;
            end
            minus:
            begin
                if (count == 0 && ms_clk == 0)
                begin
                    state_next = ms_zero;
                end
                else if (count == 0 && ms_clk == 1)
                begin
                    state_next = ms_one;
                end
                else
                begin
                    count_next = count_next - 1;
                end
            end
            default:
            begin
            
            end // error
        endcase
    end  

endmodule
