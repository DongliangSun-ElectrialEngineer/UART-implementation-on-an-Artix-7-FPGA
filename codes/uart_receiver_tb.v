`timescale 1ns / 1ps
module uart_receiver_tb;


    // Testbench Signals
    reg clk_100MHz;
    reg reset;
    reg tx_start;
    reg [7:0] data_in;
    wire tx_done;
    wire tx;
    wire data_ready;
    wire [7:0] data_out;

    // Instantiate the Unit Under Test (UUT)
           uart_receiver
        #(
            .clks_per_bit(868)
         )
         UART_RX_UNIT
         (
            .clk(clk_100MHz),
            .reset(reset),
            .i_rx(tx),
            .o_data_ready(data_ready),
            .o_data_byte(data_out)
         );
       
       uart_transmitter
         #(.clks_per_bit(868))
       UART_TX_UNIT
         (
            .clk(clk_100MHz),
            .reset(reset),
            .tx_start(tx_start),
            .i_data_byte(data_in),
            .tx_done(tx_done),
            .tx(tx)
         );   

    // Clock Generation
    always #(10 / 2) clk_100MHz = ~clk_100MHz;

    // Testbench Logic
    initial begin
        // Initialize Inputs
        clk_100MHz <= 0;
        reset <= 1;
        tx_start <= 0;
        data_in <= 8'b01110101;
        # 10;
        reset <= 0;
        # 50;
        tx_start <= 1;
        # 100000;
        $finish;
    end

endmodule
