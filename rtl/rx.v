
module rx #(parameter WIDTH = 8)(
    input   data_in,
    input   rx_clk,
    input   rst,
    input   rx_en,    //ctrl signal from top ctrllr
    output  [WIDTH-1:0] data_out
);

    localparam IDLE = 1'b0;
    localparam RX   = 1'b1;

    reg state, next_state;
    wire [WIDTH-1:0] sr_data_out;

    shift_reg u_sft_rg (WIDTH)(
    .clk(rx_clk),
    .se(rx_en),
    .rst(rst),
    .data_in({WIDTH-1'b0,data_in}),
    .data_out(sr_data_out)

    );

    //state_update logic
    always @(posedge rx_clk) begin
        if (rst == 1'b1)
            state <=    IDLE;
        else
            state <=    next_state;
    end

    always @(*) begin
        if(rx_en)
            next_state = RX;
        else
            next_state = IDLE;
    end

    assign data_out = sr_data_out;

endmodule