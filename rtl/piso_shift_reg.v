
//This Piso shift reg holds an inactive 1 to support tx idle behaviour
module tx_piso_shift_reg #( parameter WIDTH = 8)(
    input clk,
    input se,
    input le,
    input rst,
    input [WIDTH-1:0] data_in,
    output data_out
);
    reg [WIDTH-1:0] data;
    integer i;


    always @(posedge clk)begin
        if(rst)begin
            data    <= {WIDTH{1'b1}};
        end else if(se) begin
            data[WIDTH-1] <=  1'b1;
                for (i = WIDTH-1; i>0; i = i - 1)begin
                        data[i-1] <=  data[i];
                end
        end else if(le) begin
            data    <= data_in;
        end
    end

    assign data_out =   data[0];
endmodule