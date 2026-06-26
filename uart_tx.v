`timescale 1ns / 1ps
module uart_tx(
input clk,
input rst,
input baud_tick,
input tx_start,
input [7:0] tx_data,
output reg tx,
output reg tx_busy
);
localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;
reg [1:0] state;
reg [2:0] bit_idx;
reg [7:0] shift_reg;
always @(posedge clk)
begin
    if(rst)
    begin
        state     <= IDLE;
        tx        <= 1'b1;
        tx_busy   <= 1'b0;
        bit_idx   <= 3'd0;
        shift_reg <= 8'd0;
    end
    else
    begin
        case(state)
            IDLE:
            begin
                tx      <= 1'b1;
                tx_busy <= 1'b0;
                if(tx_start)
                begin
                    shift_reg <= tx_data;
                    tx_busy   <= 1'b1;
                    state     <= START;
                end
            end
            START:
            begin
                tx <= 1'b0;
                if(baud_tick)
                begin
                    bit_idx <= 3'd0;
                    state   <= DATA;
                end
            end
            DATA:
            begin
                tx <= shift_reg[0];
                if(baud_tick)
                begin
                    shift_reg <= {1'b0, shift_reg[7:1]};
                    if(bit_idx == 3'd7)
                        state <= STOP;
                    else
                        bit_idx <= bit_idx + 1;
                end
            end
            STOP:
            begin
                tx <= 1'b1;
                if(baud_tick)
                begin
                    tx_busy <= 1'b0;
                    state   <= IDLE;
                end
            end
        endcase
    end
end
endmodule