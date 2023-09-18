
`include "UART_Tx_control_unit.v"
`include "uart_tx_serializer.v"
`include "uart_tx_parity.v"
`include "uart_tx_mux.v"

module Tx_Top #(parameter DATA_WIDTH = 8)
(
    input UCLK,
    input reset,
    input parity_en,
    input data_valid,
    input [DATA_WIDTH - 1:0] parallel_data,

    output reg mux_out,
    output reg busy,
    output reg uart_tx_state
);

    // Bit select values of the output mux
    localparam [1:0] START_BIT_SELECT = 2'b00;
    localparam [1:0] STOP_BIT_SELECT = 2'b01;
    localparam [1:0] SERIAL_DATA_BIT_SELECT = 2'b10;
    localparam [1:0] PARITY_BIT_SELECT = 2'b11;

    // Internal signals' decalaration
    wire ser_en;
    wire [$clog2(DATA_WIDTH) - 1:0] frame;
    wire [1:0] bit_select;
    wire serial_data;
    wire parity_bit;

    UART_Tx_control_unit #(
        .DATA_WIDTH(DATA_WIDTH),
        .START_BIT_SELECT(START_BIT_SELECT),
        .STOP_BIT_SELECT(STOP_BIT_SELECT),
        .SERIAL_DATA_BIT_SELECT(SERIAL_DATA_BIT_SELECT),
        .PARITY_BIT_SELECT(PARITY_BIT_SELECT)
    )  
    U_UART_Tx_control_unit (
        .UCLK(UCLK)                      ,
        .reset(reset)                    ,
        .data_valid(data_valid)          ,
        .parity_en(parity_en)            ,
        .ser_en(ser_en)                  ,
        .bit_select(bit_select)          ,
        .frame(frame)                    ,
        .busy(busy)                      ,
        .uart_tx_state(uart_tx_state)    
    );


    uart_tx_serializer #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    U_uart_tx_serializer (
        .UCLK(UCLK),
        .reset(reset),
        .parallel_data(parallel_data),
        .ser_en(ser_en),
        .frame(frame),
        .serial_data(serial_data)
    );


    uart_tx_parity #(
        .DATA_WIDTH(DATA_WIDTH)
    ) 
    U_uart_tx_parity (
        .UCLK(UCLK),
        .reset(reset),
        .parity_en(parity_en),
        .data_valid(data_valid),
        .parallel_data(parallel_data),
        .parity_bit(parity_bit)
    );


    uart_tx_mux # (
        .START_BIT_SELECT(START_BIT_SELECT),
        .STOP_BIT_SELECT(STOP_BIT_SELECT),
        .SERIAL_DATA_BIT_SELECT(SERIAL_DATA_BIT_SELECT),
        .PARITY_BIT_SELECT(PARITY_BIT_SELECT)
    ) U_uart_tx_mux (
        .bit_select(bit_select),
        .serial_data(serial_data),
        .parity_bit(parity_bit),
        .mux_out(mux_out)
    );

endmodule
