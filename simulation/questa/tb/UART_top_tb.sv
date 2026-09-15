module tb();

localparam integer WIDTH = 8;
localparam [WIDTH-1:0] PACKET = 8'b10111010;

reg clk;
reg rst;
reg rx_en, tx_en;

wire rx_req;

reg rx_data_in;
reg [7:0] tx_data_in;
wire tx_data_out;
wire [7:0] rx_data_out;

task tx_byte();
    // Transmit one packet. tx_en is an edge-triggered request.
    tx_data_in = PACKET;
    tx_en = 1'b1;
    @(posedge clk);
    tx_en = 1'b0;

    // Allow the complete transmitted packet to finish, then remain idle.
    repeat (WIDTH + 1) @(posedge clk);
    repeat (5) @(posedge clk);
endtask

task rx_byte();
    // Receive one packet: start bit followed by LSB-first data bits.
    rx_en = 1'b1;
    @(negedge clk);
    rx_data_in = 1'b0;
    @(posedge clk);
    for (integer bit_index = 0; bit_index < WIDTH; bit_index = bit_index + 1) begin
        @(negedge clk);
        rx_data_in = PACKET[bit_index];
        @(posedge clk);
    end

    rx_data_in = 1'b1;
    rx_en = 1'b0;

    // Leave the serial line idle after the received packet.
    repeat (5) @(posedge clk);
endtask

//System clock
always #10 clk = ~clk;

UART_top #(8) u_dut(
    .data_from_top(tx_data_in),
    .clk(clk),
    .rx_data_in(rx_data_in),
    .rst(rst), 
    .rx_en(rx_en), 
    .tx_en(tx_en),
	.rx_req(rx_req),
    .data_to_top(rx_data_out),
    .tx_data_out(tx_data_out)
);

initial begin

    clk = 1'b0;
    rx_en = 1'b0;
    tx_en = 1'b0;
    tx_data_in = 8'b0;
    rx_data_in = 1'b1;

    rst = 1'b1;

    repeat (2) @(posedge clk);

    rst = 1'b0;

    tx_byte();

    rx_byte();

    $finish;

end






endmodule