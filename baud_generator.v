`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2026 22:32:54
// Design Name: 
// Module Name: baud_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module baud_generator(

input clk,
input rst,

output reg baud_tick

);

parameter CLK_FREQ = 100000000;
parameter BAUD = 9600;

localparam DIV = CLK_FREQ/BAUD;

reg [13:0] count;

always @(posedge clk)
begin

if(rst)
begin

count <= 0;
baud_tick <= 0;

end

else
begin

if(count == DIV-1)
begin

count <= 0;
baud_tick <= 1;

end

else
begin

count <= count + 1;
baud_tick <= 0;

end

end

end

endmodule
