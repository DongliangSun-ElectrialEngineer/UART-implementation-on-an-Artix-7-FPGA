`timescale 1ns / 1ps

module uart_tb;

    reg clk_100MHz;
    reg clk_50MHz;
    reg reset_1;
    reg reset_2;
    reg tx_start_1;
    reg tx_start_2;
    reg [7:0] data_in_1;
    reg [7:0] data_in_2;
    
    wire tx_done_1;
    wire tx_done_2;
    wire tx;
    wire rx;
    wire data_ready_1;
    wire data_ready_2;
    wire [7:0] data_out_1;
    wire [7:0] data_out_2;
    
    
        uart
        #(.clks_per_bit(868))
        UART_UNIT1
         (
            .clk_100MHz(clk_100MHz),
            .reset(reset_1),
            .rx(rx),
            .tx_start(tx_start_1),
            .i_data_byte(data_in_1),
            .tx_done(tx_done_1),
            .tx(tx),
            .o_data_ready(data_ready_1),
            .o_data_byte(data_out_1)
         );
         
        uart
        #(.clks_per_bit(434))
        UART_UNIT2
         (
            .clk_100MHz(clk_50MHz),
            .reset(reset_2),
            .rx(tx),
            .tx_start(tx_start_2),
            .i_data_byte(data_in_2),
            .tx_done(tx_done_2),
            .tx(rx),
            .o_data_ready(data_ready_2),
            .o_data_byte(data_out_2)
         ); 

    // Clock Generation
    always #(10 / 2) clk_100MHz = ~clk_100MHz;
    always #(20 / 2) clk_50MHz = ~clk_50MHz;
    
        initial begin
        // Initialize Inputs
        clk_100MHz <= 0;
        reset_1 <= 1;
        tx_start_1 <= 0;
        data_in_1 <= 8'b01110101;
        clk_50MHz <= 0;
        reset_2 <= 1;
        tx_start_2 <= 0;
        data_in_2 <= 8'b01010010;        
        # 10;
        reset_1 <= 0;
        reset_2 <= 0;
        # 50;
        tx_start_1 <= 1;
        tx_start_2 <= 1;
        # 100000;
        $finish;
    end
    


                 
endmodule
