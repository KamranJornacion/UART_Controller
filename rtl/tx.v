module tx #(parameter WIDTH = 8)(
    input [WIDTH-1:0] data_in,
    input tx_clk,
    input rst,
    input tx_en,
    output data_out
);

localparam IDLE = 1'b0;
localparam TX_START   = 1'b1;
localparam TX = 2'b10;

reg [1:0] state,next_state;
wire [$clog2(WIDTH)-1:0] bit_counter;

wire sr_data_out;
wire tx_req;
reg prev_edge;
reg le,se;

piso_shift_reg  #(.WIDTH(WIDTH)) u_ps_sr(
    .clk(tx_clk),
    .se(se),
    .le(le),
    .rst(rst),
    .data_in(data_in),
    .data_out(sr_data_out)
);

counter #(.LENGTH($clog2(WIDTH))) u_bit_cntr (
        .clk(tx_clk),
        .ce(se),
        .rst(rst),
        .count(bit_counter)
);

//state update logic
always @(posedge tx_clk)begin
    if(rst) 
        state   <= IDLE;
    else 
        state   <= next_state;
end

always @(*)begin
   case(state)
   IDLE: begin
      if(tx_req)begin
      next_state = TX_START;
      le = 1'b1;
      end else begin
      next_state = IDLE; 
      le = 1'b0;
      end
      se = 1'b0;

   end
   TX_START: begin
      next_state = TX;
      le = 1'b0;
      se = 1'b0;
   end
   TX: begin
      if(bit_counter < WIDTH-1)begin 
        next_state = TX;
        se = 1'b1;
      end else begin
        next_state = IDLE;
        se = 1'b0;
      end
      le = 1'b0;
   end
   default: begin
        next_state = IDLE;
        le = 1'b0;
        se = 1'b0;
   end
   endcase
end

 //posedge detector
always @(posedge tx_clk)begin
    prev_edge <= tx_en;
end

assign tx_req = tx_en & ~prev_edge;
assign data_out = (state == TX_START) ? 1'b0:sr_data_out; 

endmodule