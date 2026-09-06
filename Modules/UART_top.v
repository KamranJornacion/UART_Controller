
module UART_top ();

rx u_rx(
    .data_in(rx_data),
    .rx_clk(clk),
    .rst(rst),
    .rx_en(rx_en),
    .data_out()
);
tx u_tx(
    .data_in(tx_data),
    .tx_clk(clk),
    .rst(rst),
    .tx_en(tx_en),
    .data_out()
);

endmodule