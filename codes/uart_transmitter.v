`timescale 1ns / 1ps

module uart_transmitter
 #(parameter clks_per_bit = 868)
(
  input clk,
  input tx_start,
  input reset,
  input [7:0] i_data_byte,
  output reg tx_done,
  output reg tx
 );
 
  localparam   idle = 2'b00,
               start = 2'b01,
               data_state = 2'b10,
               stop = 2'b11;
  reg [1:0] state;
  reg [9:0] counter;
  reg [2:0] bit_index;
  reg [7:0] data_byte; 
  
    always @(posedge clk, posedge reset)
    begin
      if (reset)
        begin
        state <= idle;
        counter <= 0;
        bit_index <= 0;
        data_byte <= 0;
        end
      else
        case(state)
          idle:
            begin
              tx <= 1;
              counter <= 0;
              tx_done <= 0;
              bit_index <= 0;
              
              if (tx_start)
                begin
                data_byte <= i_data_byte;
                state <= start;
                end
              else
                state <= idle;
            end 
            
            start:
              begin
                tx <= 0;
                if (counter < clks_per_bit - 1)
                  begin
                  counter <= counter + 1;
                  state <= start;
                  end
                else
                  begin
                  counter <= 0;
                  state <= data_state;
                  end    
              end
              
              data_state: 
                begin
                tx <= data_byte[bit_index];
                if (counter < clks_per_bit - 1)
                  begin
                  counter <= counter + 1;
                  state <= data_state;
                  end
                else
                  begin
                    counter <= 0;
                    if (bit_index < 7)
                      begin
                        bit_index <= bit_index + 1;
                        state <= data_state;
                      end
                    else
                      begin
                      state <= stop;
                      end    
                  end  
                end
                
                stop:
                  begin
                    tx <= 1;
                    if (counter < clks_per_bit - 1)
                      begin
                      counter <= counter + 1;
                      state <= stop;
                      end
                    else
                      begin
                      tx_done <= 1;
                      state <= idle;
                      end  
                  end
      
    endcase
  end                 
 
endmodule
