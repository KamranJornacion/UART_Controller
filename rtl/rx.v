//QUESTION: I sample the start bit, but not each data bit, is that normal... I need to add logic to change the sample to the middle of each bit
//I likely wont implement a cache cuz that means fifo, but I will maybe implement parity bit checker? if thats easier???

module rx #(parameter WIDTH = 8)(
    input   data_in,
    input   rx_clk,
    input   rst,
    input   rx_en,
    output  rx_req, //rm from port...
    output reg rx_recv,   
    output  [WIDTH-1:0] data_out
);

    localparam IDLE = 3'd0;
    localparam RX_START_PRECHECK = 3'd1;
    localparam RX_START_CHECK = 3'd2;
    localparam RX_START = 3'd3;
    localparam RX   = 3'd4;


    reg [2:0] state, next_state;
    reg prev_edge, count_en, smpl_en, vote_en, vote_rst;
    wire [1:0] vote;
    
    wire [3:0] smpl_counter;
    wire [$clog2(WIDTH)-1:0] bit_counter;
    wire bit_ce;
    wire [WIDTH-1:0] sr_data_out;

    sipo_shift_reg #(.WIDTH(WIDTH)) u_sft_rg (
    .clk(rx_clk),
    .se(count_en),
    .rst(rst),
    .data_in(data_in),
    .data_out(sr_data_out)
    );

    counter #(.LENGTH($clog2(WIDTH))) u_bit_cntr (
        .clk(rx_clk),
        .ce(bit_ce),
        .rst(rst),
        .count(bit_counter)
    );

    counter #(.LENGTH(4)) u_smpl_cntr (
        .clk(rx_clk),
        .ce(smpl_en),
        .rst(rst),
        .count(smpl_counter)
    );

    counter #(.LENGTH(2)) u_vote_cntr(
        .clk(rx_clk),
        .ce(vote_en),
        .rst(vote_rst),
        .count(vote)
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
                vote_en= 1'b0;
                vote_rst = 1'b1;
                count_en = 1'b0;
                rx_recv = 1'b0;
                if(rx_en && rx_req) begin
                    next_state = RX_START_PRECHECK;
                    smpl_en = 1'b1;
                end else begin
                    next_state = IDLE;
                    smpl_en = 1'b0;
                end
            end
            RX_START_PRECHECK:begin
                count_en = 1'b0;
                smpl_en = 1'b1;                
                vote_en= 1'b0;
                vote_rst = 1'b0;
                rx_recv = 1'b0;
                if(smpl_counter == 4'd5)
                    next_state = RX_START_CHECK;
                else
                    next_state = RX_START_PRECHECK;
            end
            RX_START_CHECK:begin
                count_en = 1'b0;
                smpl_en = 1'b1;
                rx_recv = 1'b0;
                if((smpl_counter == 4'd8)&&(vote[1]))begin
                    next_state = RX_START;
                    vote_en = 1'b0;
                    vote_rst = 1'b1;
                end else if(smpl_counter == 4'd8) begin
                    next_state = IDLE;
                    vote_en = 1'b0;
                    vote_rst = 1'b1;
                end else begin
                    vote_en = ~data_in;
                    next_state = RX_START_CHECK;
                    vote_rst = 1'b0;
                end
            end
            RX_START:begin
                vote_en = 1'b0;
                smpl_en = 1'b1;
                rx_recv = 1'b0;
                vote_rst = 1'b0;
                if(smpl_counter == 4'd15)begin
                    next_state = RX;
                    count_en = 1'b1;
                end else begin
                    next_state = RX_START;
                    count_en = 1'b0;
                end
            end
            RX: begin
                vote_en = 1'b0;
                vote_rst = 1'b0;
                if (smpl_counter == 4'd7) begin
                    count_en =1'b1;
                    next_state  = RX;
                    smpl_en = 1'b1;
                    rx_recv = 1'b0;
                end 
                else if ((smpl_counter == 4'd15)&&(bit_counter == WIDTH-1))begin
                    next_state = IDLE; 
                    count_en = 1'b0;
                    smpl_en = 1'b0;
                    rx_recv = 1'b1;
                end else begin
                    next_state = RX;
                    count_en = 1'b0;
                    smpl_en = 1'b1;
                    rx_recv = 1'b0;
                end
            end
            default: begin 
                next_state = IDLE;
                count_en = 1'b0;
                smpl_en = 1'b1;
                vote_en = 1'b0;
                rx_recv = 1'b0;
                vote_rst = 1'b0;
            end
        endcase
    end

    //negedge detector
    always @(posedge rx_clk)begin
        prev_edge <= data_in;
    end

    assign rx_req = ~data_in & prev_edge;

    assign bit_ce = (state == RX) && (smpl_counter == 4'd15);
    assign data_out = sr_data_out;

endmodule