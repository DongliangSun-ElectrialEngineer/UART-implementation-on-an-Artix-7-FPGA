`timescale 1ns / 1ps

module uart_receiver
 #(parameter clks_per_bit = 868)
(
  input clk,
  input reset,
  input i_rx,
  output o_data_ready,
  output [7:0] o_data_byte
 );
    
  localparam   idle = 2'b00,
               start = 2'b01,
               data_state = 2'b10,
               stop = 2'b11;
               
  reg [1:0] state;
  reg [9:0] counter;
  reg [2:0] bit_index;
  reg       data_ready;
  reg [7:0] data_byte;
  reg rx, rx_buffer;
 // reg reset_counter;
  
  assign o_data_ready = data_ready;
  assign o_data_byte = data_byte;
  
  always @(posedge clk)
    begin
    rx_buffer <= i_rx;
    rx        <= rx_buffer;
    end
  
  always @(posedge clk, posedge reset)
    begin
      if (reset)
        begin
        state <= idle;
        counter <= 0;
        bit_index <= 0;
        data_ready <= 0;
        data_byte <= 0;
        end
      else
    case(state)
      idle:
      begin
      data_ready <= 0;
      counter <= 0;
      bit_index <= 0;
      if (~rx)
      begin
        state <= start;
      end  
      else
        state <= idle;  
      end
      
      start:
      begin
        if (counter == (clks_per_bit/2 - 1) )
          begin
          if(rx == 0)
            begin
            counter <= 0;
            state <= data_state;
            end
          else
            state <= idle;   
          end
        else
          begin
          counter <= counter + 1;
          state <= start;
          end
      end
      
      data_state:
      begin
        if(counter < clks_per_bit - 1 )
          begin
          counter <= counter + 1;
          state <= data_state;
          end
        else
          begin
          counter <= 0;
          data_byte[bit_index] <= rx;
          
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
        if(counter < clks_per_bit - 1 )
          begin
          counter <= counter + 1;
          state <= stop;
          end
        else
          begin
          data_ready <= 1;
          state <= idle;
          end  
      end
      
      default:
        state <= idle;
     
    endcase
  end    
    
endmodule
