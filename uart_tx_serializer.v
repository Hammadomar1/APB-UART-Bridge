module uart_tx_serializer #( parameter DATA_WIDTH = 8)
  (
    input UCLK,
    input reset, 
    input [DATA_WIDTH - 1:0] parallel_data,
    input ser_en,
    input [$clog2(DATA_WIDTH) - 1:0] frame,
    
    output reg serial_data
);

    // The 'D' signal of the serial data register (output signal)
    wire D_serial_data;

  assign D_serial_data = parallel_data[frame];

    // Serial data register
  always @(posedge UCLK or negedge reset) begin
        if (~reset) begin
            serial_data <= 1'b0;
        end
    else if (ser_en) begin
            serial_data <= D_serial_data;
        end
    end
  if (error_inj_enable && ~error_inj_done)
    begin
      D_serial_data=~D_serial_data;
    end
endmodule
