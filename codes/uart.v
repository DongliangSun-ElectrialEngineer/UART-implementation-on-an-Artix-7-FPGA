`timescale 1ns / 1ps


module uart
 #(parameter clks_per_bit = 868)
(
    input clk_100MHz,       // basys 3 FPGA clock signal
    input reset,            // btnR    
    input rx,               // USB-RS232 Rx
    input tx_start,
    input [7:0] i_data_byte,
    output tx,
    output tx_done,
    output [7:0] o_data_byte,
    output o_data_ready
    );
    
        uart_receiver
        #(
            .clks_per_bit(clks_per_bit)
         )
         UART_RX_UNIT
         (
            .clk(clk_100MHz),
            .reset(reset),
            .i_rx(rx),
            .o_data_ready(o_data_ready),
            .o_data_byte(o_data_byte)
         );
         
         
       uart_transmitter
         #(.clks_per_bit(clks_per_bit))
       UART_TX_UNIT
         (
            .clk(clk_100MHz),
            .reset(reset),
            .tx_start(tx_start),
            .i_data_byte(i_data_byte),
            .tx_done(tx_done),
            .tx(tx)
         ); 
         
endmodule
