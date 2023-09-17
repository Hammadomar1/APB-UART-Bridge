module parity_calculator # (parameter DATA_WIDTH = 8)
(
    input UCLK,
    input reset,
    input parity_en,
    input data_valid,
    input [DATA_WIDTH - 1:0] parallel_data,
    
    output reg parity_bit
);


    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            parity_bit <= 1'b0;
        end
        else if (parity_enable && data_valid) 
          begin
                // Odd parity
                parity_bit <= ~^parallel_data;
          end
        end
    end

endmodule
