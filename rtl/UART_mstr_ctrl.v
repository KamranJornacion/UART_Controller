module UART_mstr_ctrl (
    input   clk,
    input   rx_data, //why??
    output  tx_data, //why??
    output  tx_en,
    output  rx_en,
    output  rst

);

localparam IDLE = 1'b0, TX = 1'b1, RX = 2'b10;

reg [1:0] state;





endmodule