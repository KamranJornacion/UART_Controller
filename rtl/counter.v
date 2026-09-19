module counter #(parameter LENGTH = 4) (
    input clk,
    input ce,
    input rst,
    output [LENGTH-1:0] count
);
    reg [LENGTH-1:0] counter;
    assign count = counter;

    always @(posedge clk) begin
        if (rst)begin
            counter <= 'b0;
        end else if(ce) begin
            counter <= counter +1;
        end 
    end
endmodule