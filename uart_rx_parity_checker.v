module uart_rx_parity_checker #(parameter DATA_WIDTH = 8) 
(
    input UCLK,
    input reset,
    input enable,
    input sampled_bit,
    input [DATA_WIDTH - 1:0] parallel_data,
    
    output reg parity_bit_error 
);

  always @(posedge UCLK or negedge reset) begin
        if (~reset)
                begin
                  parity_bit_error <= 1'b0;
                end
        else if (enable) 
                begin
                    parity_bit_error <= (~^parallel_data) ^ sampled_bit;
                end
        end
endmodule
