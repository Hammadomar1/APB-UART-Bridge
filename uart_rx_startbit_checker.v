module uart_rx_startbit_checker (
    input UCLK,
    input reset,
    input enable,
    input sampled_bit,
    
    output reg start_bit_error 
);

  always @(posedge UCLK or negedge reset) begin
        if (~reset) begin
            start_bit_error <= 1'b0;
        end
        else if (enable) begin
            start_bit_error <= sampled_bit;
        end
        else begin
            start_bit_error <= 1'b0;
        end
    end

endmodule
