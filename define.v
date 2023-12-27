`ifndef DEFINE
`define DEFINE
    `define SyncState 2'b00
    `define BackPorchState 2'b01
    `define DisplayState 2'b10
    `define FrontPorchState 2'b11
    `define WIDTH 640
    `define HEIGHT 480
    `define width_log2 10
    `define height_log2 9
    `define screen_frequency 60
    `define hsync_pulse_width 96
    `define hsync_back_porch 48
    `define hsync_front_porch 16
    `define vsync_pulse_width 2
    `define vsync_back_porch 33
    `define vsync_front_porch 10
    `define tile_size 20
    `define tile_size_log2 5
    `define tile_col_num 32 //(`WIDTH / `tile_size)
    `define tlie_row_num 24 //(`HEIGHT / `tile_size)
    `define tile_col_num_log2 5 //($clog2(`tile_col_num))
    `define tile_row_num_log2 5 //($clog2(`tile_row_num))

    `define MAX_ANIMATION_FRAME_LOG2 2  // 4 frames
    `define GAME_STATE_PLAYING 3'b001
`endif