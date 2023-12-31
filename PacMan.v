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

    reg [`tile_row_num * `tile_col_num - 1:0] tilemap_walls;
    wire [`tile_row_num * `tile_col_num - 1:0] tilemap_dots;
    reg [`tile_row_num * `tile_col_num - 1:0] tilemap_big_dots;

    // TODO : initialize tilemap

    wire [`width_log2 - 1:0] player_x ;
    wire [`height_log2 - 1:0] player_y;
    wire [1:0] player_direction;

    wire [`width_log2 - 1:0] ghost1_x;
    wire [`height_log2 - 1:0] ghost1_y;
    wire [`width_log2 - 1:0] ghost1_direction;

    wire [`width_log2 - 1:0] ghost2_x;
    wire [`height_log2 - 1:0] ghost2_y;
    wire [`width_log2 - 1:0] ghost2_direction;

    wire [`width_log2 - 1:0] ghost3_x;
    wire [`height_log2 - 1:0] ghost3_y;
    wire [`width_log2 - 1:0] ghost3_direction;

    wire [`width_log2 - 1:0] ghost4_x;
    wire [`height_log2 - 1:0] ghost4_y;
	 wire [`width_log2 - 1:0] ghost4_direction;
	 
	 wire [255:0] score;// TODO
    wire [2:0] game_state = `GAME_STATE_PLAYING;

    integer i;
    integer j;

    // clk for char update
    wire clk_100Hz;
    FrequencyDivider #(.target_frequency(100)) char_clk_divider(clk_50MHz, reset, clk_100Hz);

    // TODO : add ghosts' data and behaviors

    always @(posedge clk_25MHz) begin
        if(hstate == `SyncState) hsync <= 1'b0;
        else hsync <= 1'b1;
        if(vstate == `SyncState) vsync <= 1'b0;
        else vsync <= 1'b1;
    end

    always @(posedge clk_25MHz or negedge reset) begin

//        ghost1_x <= 50;
//        ghost1_y <= 100;
//        ghost1_direction <= `dir_up;
//
//        ghost2_x <= 160;
//        ghost2_y <= 70;
//        ghost2_direction <= `dir_left;
//
//        ghost3_x <= 80;
//        ghost3_y <= 400;
//        ghost3_direction <= `dir_down;
//
//        ghost4_x <= 500;
//        ghost4_y <= 300;
//        ghost4_direction <= `dir_right;

        for(i = 0; i < `tile_row_num; i = i + 1) begin
            for(j = 0; j < `tile_col_num; j = j + 1) begin
                if(i == `tile_row_num - 1 || j == `tile_col_num - 1) begin
                    tilemap_walls[i * `tile_col_num + j] <= 1'b1;
                end
                else begin
                    tilemap_walls[i * `tile_col_num + j] <= 1'b0;
                end
//                if(i == `tile_row_num - 2 || j == `tile_col_num - 2) begin
//                    tilemap_dots[i * `tile_col_num + j] <= 1'b1;
//                end
//                else begin
//                    tilemap_dots[i * `tile_col_num + j] <= 1'b0;
//                end
                if(i == `tile_row_num - 3 || j == `tile_col_num - 3) begin
                    tilemap_big_dots[i * `tile_col_num + j] <= 1'b1;
                end
                else begin
                    tilemap_big_dots[i * `tile_col_num + j] <= 1'b0;
                end
            end
        end
		  
		  for(i = 0; i < `tile_row_num; i = i + 1) //test
				tilemap_walls[100+i] <= 1'b1;
		  for(i = 0; i < `tile_row_num; i = i + 1) //test
				tilemap_walls[2*i+32] <= 1'b1;
		 
    end

	
//	 Player player(
//		.clk(clk_100Hz),
//		.reset(reset),
//      .w(w),
//      .a(a),
//      .s(s),
//      .d(d),
//		.tilemap_walls(tilemap_walls),
//		.tilemap_dots(tilemap_dots),
//		.player_x(player_x),
//      .player_y(player_y),
//		.score(score),
//      .default_direction(player_direction)
//	 );
	 
	
    PlayerControl player_control(
        .clk(clk_100Hz),
        .reset(reset),
        .w(w),
        .a(a),
        .s(s),
        .d(d),
        .x(player_x),
        .y(player_y),
		  .player_direction(player_direction),
		  .tilemap_walls(tilemap_walls),
		  .tilemap_dots(tilemap_dots)
    );
	 
	 Clyde clyde(
		  .clock(clk_100Hz),
        .reset(reset),
		  .w(w),
        .a(a),
        .s(s),
        .d(d),
        .x(ghost2_x),
        .y(ghost2_y),
        .ghostDirection(ghost2_direction),
		  .player_x(player_x),
		  .player_y(player_y),
		  .tilemap_walls(tilemap_walls)
	 );
	 
	 Ghost1Control ghost1_control(
        .clk(clk_100Hz),
        .reset(reset),
        .w(w),
        .a(a),
        .s(s),
        .d(d),
        .x(ghost1_x),
        .y(ghost1_y),
        .ghost1_direction(ghost1_direction),
		  .player_x(player_x),
		  .player_y(player_y),
		  .tilemap_walls(tilemap_walls)
    );
	 
	 Ghost3Control ghost3_control(
		  .clk(clk_100hz),
		  .reset(reset),
		  .Player_x(player_x),
		  .Player_y(player_y),
		  .Ghost_x(ghost3_x),
        .Ghost_y(ghost3_y),
		  .tilemap(tilemap_walls),
		  .direction(ghost3_direction)
	 );

	
	 Ghost4Control ghost4_control(
        .clk(clk_100Hz),
        .reset(reset),
        .w(w),
        .a(a),
        .s(s),
        .d(d),
        .x(ghost4_x),
        .y(ghost4_y),
        .ghost4_direction(ghost4_direction),
		  .player_x(player_x),
		  .player_y(player_y),
		  .tilemap_walls(tilemap_walls)
    );
	
//	 Ghost4Control ghost4_control(
//		  .clk(clk_100hz),
//		  .reset(reset),
//		  .Player_x(player_x),
//		  .Player_y(player_y),
//		  .x(ghost4_x),
//        .y(ghost4_y),
//		  .tilemap(tilemap_walls)
//	 );

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



    