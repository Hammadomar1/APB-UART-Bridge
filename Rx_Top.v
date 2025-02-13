`include "UART_Rx_control_unit.v"
`include "uart_rx_data_sampler.v"
`include "uart_rx_deserializer.v"
`include "uart_rx_edge_counter.v"
`include "uart_rx_startbit_checker.v"
`include "uart_rx_parity_checker.v"
`include "uart_rx_stopbit_checker.v"

module Rx_Top #(
    parameter DATA_WIDTH = 8) 
(
    input UCLK,
    input reset,
    input parity_type,
    input parity_enable,
    input [5:0] prescale,
    input serial_data_in,

    output data_valid,
    output [DATA_WIDTH - 1:0] parallel_data,
    output parity_error,
    output frame_error
);
    // Internal signals' decalaration
    wire start_bit_error;
    wire stop_bit_error;
    wire [4:0] edge_count;
    wire edge_count_done;
    wire start_bit_check_enable;
    wire parity_bit_check_enable;
    wire stop_bit_check_enable;
    wire edge_counter_and_data_sampler_enable;
    wire deserializer_enable;
    wire [$clog2(DATA_WIDTH) - 1:0] data_index;
    wire sampled_bit;

    assign frame_error = start_bit_error | stop_bit_error;

    UART_Rx_control_unit #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    U_UART_Rx_FSM (
        .UCLK(UCLK),
        .reset(reset),
        .parity_enable(parity_enable),
        .serial_data_in(serial_data_in),
        .prescale(prescale),
        .start_bit_error(start_bit_error),
        .parity_bit_error(parity_error),
        .stop_bit_error(stop_bit_error),
        .edge_count(edge_count),
        .edge_count_done(edge_count_done),

        .start_bit_check_enable(start_bit_check_enable),
        .parity_bit_check_enable(parity_bit_check_enable),
        .stop_bit_check_enable(stop_bit_check_enable),
        .edge_counter_and_data_sampler_enable(edge_counter_and_data_sampler_enable),
        .deserializer_enable(deserializer_enable),
        .data_index(data_index),
        .data_valid(data_valid)
    );

    uart_rx_data_sampler U_data_sampler (
        .UCLK(UCLK),
        .reset(reset),
        .serial_data_in(serial_data_in),
        .prescale(prescale[5:1]),
        .enable(edge_counter_and_data_sampler_enable),
        .edge_count(edge_count),

        .sampled_bit(sampled_bit)
    );

    uart_rx_deserializer #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    U_deserializer (
        .UCLK(UCLK),
        .reset(reset),
        .enable(deserializer_enable),
        .data_index(data_index),
        .sampled_bit(sampled_bit),

        .parallel_data(parallel_data)
    );

    uart_rx_edge_counter U_edge_counter (
        .UCLK(UCLK),
        .reset(reset),
        .prescale(prescale),
        .enable(edge_counter_and_data_sampler_enable),

        .edge_count(edge_count),
        .edge_count_done(edge_count_done)
    );

    uart_rx_startbit_checker U_start_bit_checker (
        .UCLK(UCLK),
        .reset(reset),
        .enable(start_bit_check_enable),
        .sampled_bit(sampled_bit),
        
        .start_bit_error(start_bit_error)
    );

    uart_rx_parity_checker #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    U_parity_checker (
        .UCLK(UCLK),
        .reset(reset),
        .parity_type(parity_type),
        .enable(parity_bit_check_enable),
        .sampled_bit(sampled_bit),
        .parallel_data(parallel_data),
        
        .parity_bit_error(parity_error) 
    );

    uart_rx_stopbit_checker U_stopbit_checker (
        .UCLK(UCLK),
        .reset(reset),
        .enable(stop_bit_check_enable),
        .sampled_bit(sampled_bit),
        
        .stop_bit_error(stop_bit_error) 
    );


endmodule
