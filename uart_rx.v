`timescale 1ns / 1ps
module uart_rx(
input clk,
input rst,
input baud_tick,
input rx,
output reg [7:0] rx_data,
output reg rx_done,
output reg frame_err
);
localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;
reg [1:0] state;
reg [2:0] bit_idx;
reg [7:0] shift_reg;
reg rx_sync1, rx_sync2;
wire rx_s = rx_sync2;
always @(posedge clk)
begin
    if(rst)
    begin
        rx_sync1 <= 1'b1;
        rx_sync2 <= 1'b1;
    end
    else
    begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
    end
end
always @(posedge clk)
begin
    if(rst)
    begin
        state     <= IDLE;
        bit_idx   <= 3'd0;
        shift_reg <= 8'd0;
        rx_data   <= 8'd0;
        rx_done   <= 1'b0;
        frame_err <= 1'b0;
    end
    else
    begin
        rx_done   <= 1'b0;
        frame_err <= 1'b0;
        case(state)
            IDLE:
            begin
                if(!rx_s)
                    state <= START;
            end
            START:
            begin
                if(baud_tick)
                begin
                    if(!rx_s)
                    begin
                        bit_idx <= 3'd0;
                        state   <= DATA;
                    end
                    else
                        state <= IDLE;
                end
            end
            DATA:
            begin
                if(baud_tick)
                begin
                    shift_reg <= {rx_s, shift_reg[7:1]};
                    if(bit_idx == 3'd7)
                        state <= STOP;
                    else
                        bit_idx <= bit_idx + 1;
                end
            end
            STOP:
            begin
                if(baud_tick)
                begin
                    if(rx_s)
                    begin
                        rx_data <= shift_reg;
                        rx_done <= 1'b1;
                    end
                    else
                        frame_err <= 1'b1;
                    state <= IDLE;
                end
            end
        endcase
    end
end
endmodule