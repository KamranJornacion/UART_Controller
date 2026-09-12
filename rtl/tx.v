
module tx #(parameter WIDTH = 8)(
    input data_in,
    input tx_clk,
    input rst,
    input tx_en,    //ctrl signal from top ctrllr
    output data_out
);

localparam IDLE = 1'b0;
localparam TX   = 1'b1;

reg state,next_state;

piso_shift_reg u_ps_sr(WIDTH)(
    .clk(tx_clk),
    .se(),
    .le(),
    .rst(),
    .data_in(),
    .data_out()
);

//state update logic
always @(posedge clk)begin
    if(rst) 
        state   <= IDLE;
    else 
        state   <= next_state;
end

always @(*)begin
    if(~tx_en) 
        next_state   = IDLE;
    else 
        next_state   = TX;
end

assign data_out = state ? data_in : 1'b1; //should i make this an always if statement to use the Tx vs Idle keywords?

endmodule