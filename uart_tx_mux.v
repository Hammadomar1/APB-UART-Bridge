module output_mux # (
                        // Bit select values
                        parameter [1:0] START_BIT_SELECT = 2'b00,
                        parameter [1:0] STOP_BIT_SELECT = 2'b01,
                        parameter [1:0] SERIAL_DATA_BIT_SELECT = 2'b10,
                        parameter [1:0] PARITY_BIT_SELECT = 2'b11
                    )
(
    input [1:0] bit_select,
    input serial_data,
    input parity_bit,

    output reg Tx
);

    always @(*) begin
        case (bit_select)
        START_BIT_SELECT: begin
            Tx = 1'b0;
        end

        STOP_BIT_SELECT: begin
            Tx = 1'b1;
        end

        SERIAL_DATA_BIT_SELECT: begin
            Tx = serial_data;
        end

        PARITY_BIT_SELECT: begin
          Tx = parity_bit;
        end

        endcase
    end

endmodule
