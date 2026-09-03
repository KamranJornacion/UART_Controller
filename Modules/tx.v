
module tx (
    input data_in,
    input tx_clk,
    input rst,
    input tx_en,    //ctrl signal from top ctrllr
    output data_out
);

localparam IDLE = 1'b0;
localparam Tx   = 1'b1;

reg state;

//state update logic
always @(posedge clk)begin
    if(rst == 1'b1 || tx_en == 1'b0) 
        state   <= IDLE;
    else 
        state   <= Tx;
end

assign data_out = state ? data_in : 1'b1; //should i make this an always if statement to use the Tx vs Idle keywords?

endmodule