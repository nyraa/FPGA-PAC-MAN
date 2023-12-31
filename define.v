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
    `define tile_row_num 24 //(`HEIGHT / `tile_size)
    `define tile_col_num_log2 5 //($clog2(`tile_col_num))
    `define tile_row_num_log2 5 //($clog2(`tile_row_num))

    `define MAX_ANIMATION_FRAME_LOG2 2  // 4 frames
    `define GAME_STATE_STANDBY 3'b000
    `define GAME_STATE_PLAYING 3'b001
    `define GAME_STATE_WIN 3'b010   // temporary, change the name and the value after merge to topmodule
    `define GAME_STATE_GAMEOVER 3'b011
    `define GAME_STATE_PLAYING_POWER 3'b100

    `define GHOST1_SPAWN_POINT_X 280
    `define GHOST1_SPAWN_POINT_Y 240
    `define GHOST2_SPAWN_POINT_X 340
    `define GHOST2_SPAWN_POINT_Y 240
    `define GHOST3_SPAWN_POINT_X 320
    `define GHOST3_SPAWN_POINT_Y 240
    `define GHOST4_SPAWN_POINT_X 260
    `define GHOST4_SPAWN_POINT_Y 240
    `define PLAYER_SPAWN_POINT_X 20
    `define PLAYER_SPAWN_POINT_Y 20
    `define POWER_TIME 600

    `define MAX_DOTS 285
    `define DOT_POINTS 10
    `define BIGDOT_POINTS 50
    `define GHOST_POINTS 200

    `define dir_up 2'b00
    `define dir_down 2'b11
    `define dir_left 2'b10
    `define dir_right 2'b01

    // set color of player to yellow
    `define player_r 4'hf;
    `define player_g 4'hf;
    `define player_b 4'h0;
    // set color of ghost1 to red
    `define ghost1_r 4'hf;
    `define ghost1_g 4'h0;
    `define ghost1_b 4'h0;
    // set color of ghost2 to pink
    `define ghost2_r 4'hf;
    `define ghost2_g 4'h0;
    `define ghost2_b 4'hf;
    // set color of ghost3 to cyan
    `define ghost3_r 4'h0;
    `define ghost3_g 4'hf;
    `define ghost3_b 4'hf;
    // set color of ghost4 to orange
    `define ghost4_r 4'hf;
    `define ghost4_g 4'h7;
    `define ghost4_b 4'h0;

    `define ghost_void_f1_r 4'hf;
    `define ghost_void_f1_g 4'h0;
    `define ghost_void_f1_b 4'h0;

    `define ghost_void_f2_r 4'h0;
    `define ghost_void_f2_g 4'h0;
    `define ghost_void_f2_b 4'hf;

    `define ghost_void_face_r 4'hf;
    `define ghost_void_face_g 4'hf;
    `define ghost_void_face_b 4'hf;

    `define ghost_sclera_r 4'hf;
    `define ghost_sclera_g 4'hf;
    `define ghost_sclera_b 4'hf;

    `define ghost_eye_r 4'h5;
    `define ghost_eye_g 4'h5;
    `define ghost_eye_b 4'hb;

    `define CONGRATULATIONS_MASK_HEIGHT 81
    `define CONGRATULATIONS_MASK_WIDTH 320
    `define CONGRATULATIONS_X 160
    `define CONGRATULATIONS_Y 200

    `define gameover_width 86
    `define gameover_height 48
    
`endif