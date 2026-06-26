`timescale 1ns / 1ps
module uart_top(
input clk,
input rst,
input tx_start,
input [7:0] tx_data,
input rx,
output wire tx,
output wire tx_busy,
output wire [7:0] rx_data,
output wire rx_done,
output wire frame_err
);
parameter CLK_FREQ = 100000000;
parameter BAUD     = 9600;
wire baud_tick;
baud_generator #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD(BAUD)
) u_baud_gen (
    .clk       (clk),
    .rst       (rst),
    .baud_tick (baud_tick)
);
uart_tx u_tx (
    .clk       (clk),
    .rst       (rst),
    .baud_tick (baud_tick),
    .tx_start  (tx_start),
    .tx_data   (tx_data),
    .tx        (tx),
    .tx_busy   (tx_busy)
);
uart_rx u_rx (
    .clk       (clk),
    .rst       (rst),
    .baud_tick (baud_tick),
    .rx        (rx),
    .rx_data   (rx_data),
    .rx_done   (rx_done),
    .frame_err (frame_err)
);
endmodule