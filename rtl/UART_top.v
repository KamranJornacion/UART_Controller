
module UART_top #( parameter WIDTH = 8)(
    input [WIDTH-1:0] data_from_top,
    input rx_data_in,
    input rst, rx_en, tx_en, rx_req,
    output [WIDTH-1:0] data_to_top,
    output tx_data_out
);


wire [WIDTH-1:0] data_to_tx, data_from_rx;

wire rst, rx_en, tx_en;

rx u_rx (WIDTH)(
    .data_in(rx_data),
    .rx_clk(clk),
    .rst(rst),
    .rx_en(rx_en),
    .rx_req(rx_req),
    .data_out(data_from_rx)
);

tx u_tx (WIDTH)(
    .data_in(data_to_tx),
    .tx_clk(clk),
    .rst(rst),
    .tx_en(tx_en),
    .data_out(tx_data_out)
);


endmodule

