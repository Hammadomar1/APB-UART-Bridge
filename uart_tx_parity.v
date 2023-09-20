module uart_tx_parity # (parameter DATA_WIDTH = 8)
(
    input wire UCLK,
    input wire reset,
    input parity_en,
    input data_valid,
    input [DATA_WIDTH - 1:0] parallel_data,
    input wire err_inj_en,
    
    output reg parity_bit,
    output wire error_inj_done,
);


    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            parity_bit <= 1'b0;
        end
        else if (parity_enable && data_valid) 
          begin
              if (err_inj_en)
                      begin 
                        parity_bit <= ^parallel_data;
                        error_inj_done <=   1'b1;
                      end
              
              else
                // Odd parity
                            parity_bit <= ~^parallel_data;
          end
        
        end
    end

endmodule
