`ifndef DEFINE
`define DEFINE
    `define SyncState 2'b00
    `define BackPorchState 2'b01
    `define DisplayState 2'b10
    `define FrontPorchState 2'b11
    `define WIDTH 640
    `define HEIGHT 480
    `define screen_frequency 60
    `define hsync_pulse_width 96
    `define hsync_back_porch 48
    `define hsync_front_porch 16
    `define vsync_pulse_width 2
    `define vsync_back_porch 33
    `define vsync_front_porch 10
    `define tile_size 20
`endif