

module sipo_shift_reg #( parameter WIDTH = 8)(
    input clk,
    input se,
    input rst,
    input data_in,
    output [WIDTH-1:0] data_out
);


    reg [WIDTH-1:0] data;
    integer i;


    always @(posedge clk)begin
        if(rst)begin
            data    <= {WIDTH{1'b0}};
        end else if(se) begin
            data[WIDTH-1] <=  data_in;
            for (i = WIDTH-1; i>0; i = i - 1)begin
                    data[i-1] <=  data[i];
            end
        end
    end

    assign data_out =   data;


    


endmodule