
module rx (
    input   data_in,
    input   rx_clk,
    input   rst,
    input   rx_en,    //ctrl signal from top ctrllr
    output  data_out
);

    localparam IDLE = 1'b0;
    localparam Rx   = 1'b1;

    reg state;

    //state_update logic
    always @(posedge clk) begin
        if (rx_en == 1'b0 || rst == 1'b1)
            state <=    IDLE;
        else
            state <=    Rx;
    end

    assign data_out = rx_en ? data_in : 1'bz;

endmodule