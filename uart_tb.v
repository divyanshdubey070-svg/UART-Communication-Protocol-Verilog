`timescale 1ns / 1ps

module uart_tb;

reg        clk;
reg        rst;
reg        tx_start;
reg  [7:0] tx_data;

wire       tx;
wire       tx_busy;
wire [7:0] rx_data;
wire       rx_done;
wire       frame_err;

reg [7:0] expected [0:2];
integer check_idx;

uart_top #(
    .CLK_FREQ (100000000),
    .BAUD     (9600)
) uut (
    .clk       (clk),
    .rst       (rst),
    .tx_start  (tx_start),
    .tx_data   (tx_data),
    .tx        (tx),
    .tx_busy   (tx_busy),
    .rx        (tx),
    .rx_data   (rx_data),
    .rx_done   (rx_done),
    .frame_err (frame_err)
);

initial
    clk = 1'b0;

always
    #5 clk = ~clk;

task send_byte;
    input [7:0] data;
    begin
        @(negedge clk);
        tx_data  = data;
        tx_start = 1'b1;

        @(negedge clk);
        tx_start = 1'b0;

        wait (tx_busy == 1'b0);
        #2000;
    end
endtask

always @(posedge clk)
begin
    if (rx_done)
    begin
        if (rx_data === expected[check_idx])
            $display("[PASS] Byte %0d | Sent = 0x%h | Received = 0x%h | Time = %0t ns",
                     check_idx, expected[check_idx], rx_data, $time);
        else
            $display("[FAIL] Byte %0d | Sent = 0x%h | Received = 0x%h | Time = %0t ns",
                     check_idx, expected[check_idx], rx_data, $time);

        check_idx = check_idx + 1;
    end
end

always @(posedge clk)
begin
    if (frame_err)
        $display("[ERROR] Frame error detected at time = %0t ns", $time);
end

initial
begin
    rst       = 1'b1;
    tx_start  = 1'b0;
    tx_data   = 8'd0;
    check_idx = 0;

    expected[0] = 8'h41;
    expected[1] = 8'h42;
    expected[2] = 8'h55;

    repeat (20) @(posedge clk);
    rst = 1'b0;

    repeat (5) @(posedge clk);

    $display("--------------------------------------------------");
    $display(" UART Loopback Testbench");
    $display(" CLK = 100 MHz | BAUD = 9600");
    $display("--------------------------------------------------");

    $display("[TB] Sending 0x41 (ASCII A)");
    send_byte(8'h41);

    $display("[TB] Sending 0x42 (ASCII B)");
    send_byte(8'h42);

    $display("[TB] Sending 0x55");
    send_byte(8'h55);

    #500000;

    $display("--------------------------------------------------");
    $display(" Testbench completed successfully.");
    $display("--------------------------------------------------");

    $finish;
end

initial
begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);
end

endmodule
