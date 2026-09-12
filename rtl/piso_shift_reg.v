

module piso_shift_reg #( parameter WIDTH = 8)(
    input clk,
    input se,
    input le,
    input rst,
    input [WIDTH-1:0] data_in,
    output data_out
);


    reg [WIDTH-1:0] data;
    genvar i;


    always @(posedge clk)begin
        if(rst)begin
            data    <= 'b0;
        end else if(se) begin
            data[WIDTH-1] <=  1'b0;;
            generate
                for (i = WIDTH-1; i>0; i--)begin
                        data[i-1] <=  data[i];
                end
            endgenerate
        end else if(le) begin
            data    <= data_in;
        end
    end

    assign data_out =   data[0];


endmodule