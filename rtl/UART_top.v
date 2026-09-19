
module UART_top #( parameter WIDTH = 8)(
    input [WIDTH-1:0] data_from_top,
    input clk, clk_x16,
    input rx_data_in,
    input rst, rx_en, tx_en,
	output rx_req, rx_recv,
    output [WIDTH-1:0] data_to_top,
    output tx_data_out
);


rx  #(.WIDTH(WIDTH)) u_rx(
    .data_in(rx_data_in),
    .rx_clk(clk_x16),
    .rst(rst),
    .rx_en(rx_en),
    .rx_req(rx_req),
    .rx_recv(rx_recv),
    .data_out(data_to_top)
);

tx  #(.WIDTH(WIDTH)) u_tx(
    .data_in(data_from_top),
    .tx_clk(clk),
    .rst(rst),
    .tx_en(tx_en),
    .data_out(tx_data_out)
);

endmodule

