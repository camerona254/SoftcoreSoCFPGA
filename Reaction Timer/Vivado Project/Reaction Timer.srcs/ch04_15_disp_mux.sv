// Listing 4.15
module disp_mux
   (
    input  logic clk, 
    input  logic reset,
    input  logic HI, // input to display "HI" on the seven segment display
    input  logic ERR, // input to display "ERR" on the seven segment display
    input  logic CHEATER, // input to display "9999" on the seven segment display
    input  logic [7:0] in3, in2, in1, in0, // in 0 is the 8-digit binary combination used to light specific portions of the rightmost digit (active low)
    output logic [7:0] an,   // anode 0 is the rightmost digit on the board (8 total anodes)
    output logic [7:0] sseg  // this output mirrors the in input to light the specific portions of the active number
   );
  
   localparam N = 18; // refreshing rate around 800 Hz (50 MHz/2^16)

   // signal declaration
   logic [N-1:0] q_reg;
   logic [N-1:0] q_next;

   // N-bit counter
   // register
   always_ff @(posedge clk,  posedge reset)
      if (reset == 1'b0)
        begin
            q_reg <= 0;
        end
      else
        begin
            q_reg <= q_next;
        end

   // next-state logic
   assign q_next = q_reg + 1;

   // 2 MSBs of counter to control 4-to-1 multiplexing
   // and to generate active-low enable signal
   always_comb
      case (q_reg[N-1:N-2])
         2'b00:
            begin
               an = 8'b11111110;
               if (HI == 1'b1)
                begin
                    sseg = 8'b11111001; // I
                end
               else if (ERR == 1'b1)
                begin
                    sseg = 8'b10001000; // R
                end
               else if (CHEATER == 1'b1)
                 begin
                     sseg[6:0] = 7'b0010000; // 9
                 end
               else
                begin
                    sseg = in0;
                end
            end
         2'b01:
            begin
               an =  8'b11111101;
               if (HI == 1'b1)
                begin
                    sseg = 8'b10001001; // H
                end
               else if (ERR == 1'b1)
                begin
                    sseg = 8'b10001000; // R
                end
               else if (CHEATER == 1'b1)
                 begin
                     sseg[6:0] = 7'b0010000; // 9
                 end
               else
                begin
                    sseg = in1;
                end
            end
         2'b10:
            begin
               an =  8'b11111011;
               if (HI == 1'b1)
                begin
                    sseg = 8'b11111111; // blank
                end
               else if (ERR == 1'b1)
                begin
                    sseg = 8'b10000110; // E
                end
               else if (CHEATER == 1'b1)
                 begin
                     sseg[6:0] = 7'b0010000; // 9
                 end
               else
                begin
                    sseg = in2;
                end
            end
         default:
            begin
               an =  8'b11110111;
               if (HI == 1'b1)
                begin
                    sseg = 8'b11111111; // blank
                end
               else if (ERR == 1'b1)
                begin
                    sseg = 8'b11111111; // blank
                end
               else if (CHEATER == 1'b1)
                begin
                    sseg[6:0] = 7'b0010000; // 9
                end
               else
                begin
                    sseg = in3;
                end
            end
       endcase
endmodule