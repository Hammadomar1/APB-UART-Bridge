
*/

module deserializer #(
    parameter DATA_WIDTH = 8
) 
(
    input UCLK,
    input reset,
    input deserializer_enable,
  //input [$clog2(DATA_WIDTH) - 1:0] data_index, 
  //the data_index input would likely be used to control the indexing or addressing of specific bits within the parallel_data output signal.
    input sampled_bit,

    output reg [DATA_WIDTH - 1:0] parallel_data
);

  always @(posedge UCLK or negedge reset) begin
        if (!reset) begin
            parallel_data <= 8'b0;
        end
        else if (deserializer_enable) begin
            parallel_data[data_index] <= sampled_bit;
        end
    end

endmodule
