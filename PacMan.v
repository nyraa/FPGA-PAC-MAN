`include "define.v"

module PacMan(
    input clk_50MHz,
    input reset,
    input w,
    input a,
    input s,
    input d,
    output reg hsync,
    output reg vsync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
);

    // clk for VGA
    wire clk_25MHz;
    FrequencyDivider_25MHz clk_divider(clk_50MHz, clk_25MHz);

    wire [1:0] hstate;
    wire [1:0] vstate;

    wire [`width_log2 - 1:0] x;
    wire [`height_log2 - 1:0] y;

    VGAStateMachine vga_sm(clk_25MHz, reset, x, y, hstate, vstate);

    wire [`tlie_row_num * `tile_col_num - 1:0] tilemap_walls;
    wire [`tlie_row_num * `tile_col_num - 1:0] tilemap_dots;
    wire [`tlie_row_num * `tile_col_num - 1:0] tilemap_big_dots;

    // TODO : initialize tilemap

    reg [`width_log2 - 1:0] player_x;
    reg [`height_log2 - 1:0] player_y;
    reg [`width_log2 - 1:0] player_direction;

    reg [`width_log2 - 1:0] ghost1_x;
    reg [`height_log2 - 1:0] ghost1_y;
    reg [`width_log2 - 1:0] ghost1_direction;

    reg [`width_log2 - 1:0] ghost2_x;
    reg [`height_log2 - 1:0] ghost2_y;
    reg [`width_log2 - 1:0] ghost2_direction;

    reg [`width_log2 - 1:0] ghost3_x;
    reg [`height_log2 - 1:0] ghost3_y;
    reg [`width_log2 - 1:0] ghost3_direction;

    reg [`width_log2 - 1:0] ghost4_x;
    reg [`height_log2 - 1:0] ghost4_y;
    reg [`width_log2 - 1:0] ghost4_direction;

    wire [2:0] game_state;


    // clk for char update
    wire clk_5Hz;
    FrequencyDivider #(.target_frequency(5)) char_clk_divider(clk_50MHz, reset, clk_5Hz);

    // TODO : add ghosts' data and behaviors


    always @(posedge clk_25MHz) begin
        if(hstate == `SyncState) hsync <= 1'b0;
        else hsync <= 1'b1;
        if(vstate == `SyncState) vsync <= 1'b0;
        else vsync <= 1'b1;
    end

    Renderer renderer(
        .toDisplay(hstate == `DisplayState && vstate == `DisplayState),
        .clk(clk_25MHz),
        .game_state(game_state),
        .x(x),
        .y(y),
        .tilemap_walls(tilemap_walls),
        .tilemap_dots(tilemap_dots),
        .tilemap_big_dots(tilemap_big_dots),
        .player_x(player_x),
        .player_y(player_y),
        .ghost1_x(ghost1_x),
        .ghost1_y(ghost1_y),
        .ghost2_x(ghost2_x),
        .ghost2_y(ghost2_y),
        .ghost3_x(ghost3_x),
        .ghost3_y(ghost3_y),
        .ghost4_x(ghost4_x),
        .ghost4_y(ghost4_y),
        .player_direction(player_direction),
        .ghost1_direction(ghost1_direction),
        .ghost2_direction(ghost2_direction),
        .ghost3_direction(ghost3_direction),
        .ghost4_direction(ghost4_direction),
        .r(red),
        .g(green),
        .b(blue)
    );
endmodule

module FrequencyDivider_25MHz (
    input clk,
    output reg div_clock
);

    always @(posedge clk) begin
        div_clock <= ~div_clock;
    end
endmodule



    