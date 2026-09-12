
module rx #(parameter WIDTH = 8)(
    input   data_in,
    input   rx_clk,
    input   rst,
    input   rx_en,    //ctrl signal from top ctrllr
    output  rx_req,   
    output  [WIDTH-1:0] data_out
);

    localparam IDLE = 1'b0;
    localparam RX   = 1'b1;

    reg state, next_state;
    reg prev_edge, count_en;
    reg [$clog2(WIDTH):0] counter;

    wire [WIDTH-1:0] sr_data_out;

    sipo_shift_reg u_sft_rg (WIDTH)(
    .clk(rx_clk),
    .se(count_en),
    .rst(rst),
    .data_in(data_in),
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
        case(state)
            IDLE: begin 
                if(rx_en && rx_req)
                    next_state = RX;
                    count_en = 1'b1;
                else
                    next_state = IDLE;
                    count_en = 1'b0;
            end
            RX: begin 
                if (rx_en && (counter < WIDTH))begin
                    next_state = RX; 
                    count_en = 1'b1;
                end else begin
                    next_state = IDLE;
                    count_en = 1'b0;
                end
            end
            default: begin 
                next_state = IDLE;
                count_en = 1'b0;
            end
        endcase
    end

    assign data_out = sr_data_out;
    

    //negedge detector
    always @(posedge rx_clk)begin
        prev_edge <= data_in;
    end

    assign rx_req = ~data_in & prev_edge;

    //counter
    always @(posedge rx_clk) begin
        if (rst)begin
            counter <= 'b0;
        end else begin
            counter <= counter +1;
        end
    end

endmodule