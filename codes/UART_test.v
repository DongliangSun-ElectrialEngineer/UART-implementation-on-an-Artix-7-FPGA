`timescale 1ns / 1ps

module UART_test(
    input clk_100MHz,       // basys 3 FPGA clock signal
    input reset,            // btnR    
    input rx,               // USB-RS232 Rx
    output [7:0] LED,        // data byte display
    output tx

    );
 
 wire [7:0] rx_data_out;
 wire data_ready;
    
   assign LED = rx_data_out;              // data byte received displayed on LEDs
   
       uart_receiver
        #(
            .clks_per_bit(868)
         )
         UART_RX_UNIT
         (
            .clk(clk_100MHz),
            .reset(reset),
            .i_rx(rx),
            .o_data_ready(data_ready),
            .o_data_byte(rx_data_out)
         );
       
       uart_transmitter
         #(.clks_per_bit(868))
       UART_TX_UNIT
         (
            .clk(clk_100MHz),
            .reset(reset),
            .tx_start(data_ready),
            .i_data_byte(rx_data_out),
            .tx_done(),
            .tx(tx)
         );       
         
endmodule
