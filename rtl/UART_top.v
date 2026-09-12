
module UART_top #( parameter WIDTH = 8)(
    input [WIDTH-1:0] data_from_top,
    input rx_data_in,
    //input add control signals as needed,
    output [WIDTH-1:0] data_to_top,
    output tx_data_out
);

wire [WIDTH-1:0] sr_pl_data_out;
wire sr_sl_data_out = sr_pl_data_out[0];
wire [WIDTH-1:0] data_to_sr, data_from_rx;

rx u_rx(
    .data_in(rx_data),
    .rx_clk(clk),
    .rst(rst),
    .rx_en(rx_en),
    .data_out(data_from_rx)
);

tx u_tx(
    .data_in(sr_sl_data_out),
    .tx_clk(clk),
    .rst(rst),
    .tx_en(tx_en),
    .data_out(tx_data_out)
);

shift_reg u_sft_rg (WIDTH)(
    .clk(clk),
    .se(),
    .rst(rst),
    .data_in(data_to_sr), //mux rx data_out top data in
    .data_out(sr_pl_data_out)

);

UART_mstr_ctrl u_mstr_ctrl(
// mux_sel must come from here
);

assign data_to_sr = (mux_sel) ? data_from_rx : data_from_top;


endmodule

//TODO: implement shift reg inside RX, then mux RX and data in to shift_reg

// Either create seperate shift reg or use generate statements to parameterize the current module