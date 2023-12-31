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
    output [3:0] blue,
    output [7*6-1:0] sevenDisplay,
    output [7:0] dot_row_dir,
    output [7:0] dot_col_dir,
    output [7:0] dot_col_char
);

    // clk for VGA
    wire clk_25MHz;
    FrequencyDivider_25MHz clk_divider(clk_50MHz, clk_25MHz);

    wire [1:0] hstate;
    wire [1:0] vstate;

    wire [`width_log2 - 1:0] x;
    wire [`height_log2 - 1:0] y;

    VGAStateMachine vga_sm(clk_25MHz, x, y, hstate, vstate);

    wire [`tile_row_num * `tile_col_num - 1:0] tilemap_walls;
    reg [`tile_row_num * `tile_col_num - 1:0] tilemap_dots;
    reg [`tile_row_num * `tile_col_num - 1:0] tilemap_big_dots;

    
    wire [`tile_row_num * `tile_col_num - 1:0] init_walls;
    wire [`tile_row_num * `tile_col_num - 1:0] init_dots;
    wire [`tile_row_num * `tile_col_num - 1:0] init_big_dots;

    wire [1:0] player_direction;
    reg [`width_log2 - 1:0] player_x;
    reg [`height_log2 - 1:0] player_y;
    wire [`width_log2 - 1:0] player_next_x;
    wire [`height_log2 - 1:0] player_next_y;

    wire [`width_log2 - 1:0] ghost1_next_x;
    wire [`height_log2 - 1:0] ghost1_next_y;
    wire [`width_log2 - 1:0] ghost1_direction;
    reg [`width_log2 - 1:0] ghost1_x;
    reg [`height_log2 - 1:0] ghost1_y;

    wire [`width_log2 - 1:0] ghost2_next_x;
    wire [`height_log2 - 1:0] ghost2_next_y;
    wire [`width_log2 - 1:0] ghost2_direction;
    reg [`width_log2 - 1:0] ghost2_x;
    reg [`height_log2 - 1:0] ghost2_y;

    wire [`width_log2 - 1:0] ghost3_next_x;
    wire [`height_log2 - 1:0] ghost3_next_y;
    wire [`width_log2 - 1:0] ghost3_direction;
    reg [`width_log2 - 1:0] ghost3_x;
    reg [`height_log2 - 1:0] ghost3_y;

    wire [`width_log2 - 1:0] ghost4_next_x;
    wire [`height_log2 - 1:0] ghost4_next_y;
    wire [`width_log2 - 1:0] ghost4_direction;
    reg [`width_log2 - 1:0] ghost4_x;
    reg [`height_log2 - 1:0] ghost4_y;

    reg [25:0] score;
    reg [8:0] ateDots;
    reg [2:0] game_state = `GAME_STATE_PLAYING;
    reg [31:0] power_count_down;

    integer i;
    integer j;

    wire seven_clk;
    wire clk_6Hz;
    FrequencyDivider #(.target_frequency(10000)) seven_clk_divider(clk_50MHz, 1, seven_clk);
    FrequencyDivider #(.target_frequency(6)) seven_clk_divider2(clk_50MHz, 1, clk_6Hz);

    MatrixDisplay matrix_display(
        .dir(player_direction),
        .clk(seven_clk), // must change
        .state(clk_6Hz),
        .dot_row_dir(dot_row_dir),
        .dot_col_dir(dot_col_dir),
        .dot_col_char(dot_col_char)
    );
    assign tilemap_walls = 768'b111111111111111111111111111111111000000000000011110000000000000110111110111110111101111101111101101111101111101111011111011111011000000000000000000000000000000110111110110111111111101101111101101111101101111111111011011111011000000011000001100000110000000111111110111111011011111101111111111111101100000000000011011111111111111011011111111110110111111110000000000100000000100000000001111111101101111001111011011111111111111011000000000000110111111111111110110111111111101101111111100000000000000110000000000000011011111011111101101111110111110110000110000000000000000001100001111101101101111111111011011011111111011011011111111110110110111110000000110000011000001100000001101111111111110110111111111111011000000000000000000000000000000111111111111111111111111111111111;
    wire clk_5Hz;
    FrequencyDivider #(.target_frequency(5)) char_clk_divider(clk_50MHz, 1, clk_5Hz);

    always @(posedge clk_25MHz) begin
        if(hstate == `SyncState) hsync <= 1'b0;
        else hsync <= 1'b1;
        if(vstate == `SyncState) vsync <= 1'b0;
        else vsync <= 1'b1;
    end

    PlayerControl player_control(
        .clk(clk_5Hz),
        .reset(reset),
        .w(w),
        .a(a),
        .s(s),
        .d(d),
        .x(player_x),
        .y(player_y),
        .next_x(player_next_x),
        .next_y(player_next_y),
        .player_direction(player_direction),
        .tilemap_walls(tilemap_walls),
        .tilemap_dots(tilemap_dots)
    );

    Ghost1Control ghost1_control(
        .clk(clk_5Hz),
        .reset(reset),
        .x(ghost1_x),
        .y(ghost1_y),
        .next_x(ghost1_next_x),
        .next_y(ghost1_next_y),
        .ghost_direction(ghost1_direction),
        .tilemap_walls(tilemap_walls)
    );
    
    Ghost2Control ghost2_control(
        .clk(clk_5Hz),
        .reset(reset),
        .x(ghost2_x),
        .y(ghost2_y),
        .next_x(ghost2_next_x),
        .next_y(ghost2_next_y),
        .ghost_direction(ghost2_direction),
        .tilemap_walls(tilemap_walls)
    );

    Ghost3Control ghost3_control(
        .clk(clk_5Hz),
        .reset(reset),
        .x(ghost3_x),
        .y(ghost3_y),
        .next_x(ghost3_next_x),
        .next_y(ghost3_next_y),
        .ghost_direction(ghost3_direction),
        .tilemap_walls(tilemap_walls)
    );

    Ghost4Control ghost4_control(
        .clk(clk_5Hz),
        .reset(reset),
        .x(ghost4_x),
        .y(ghost4_y),
        .next_x(ghost4_next_x),
        .next_y(ghost4_next_y),
        .ghost_direction(ghost4_direction),
        .tilemap_walls(tilemap_walls)
    );

    // add a temp variable to store is start, otherwise standby
    reg isStart;

    always @(posedge clk_25MHz or negedge reset)
    begin
        if(!reset) begin
            score <= 0;
            ateDots <= 0;
            game_state <= `GAME_STATE_STANDBY;
            ghost1_x <= `GHOST1_SPAWN_POINT_X;
            ghost1_y <= `GHOST1_SPAWN_POINT_Y;
            ghost2_x <= `GHOST2_SPAWN_POINT_X;
            ghost2_y <= `GHOST2_SPAWN_POINT_Y;
            ghost3_x <= `GHOST3_SPAWN_POINT_X;
            ghost3_y <= `GHOST3_SPAWN_POINT_Y;
            ghost4_x <= `GHOST4_SPAWN_POINT_X;
            ghost4_y <= `GHOST4_SPAWN_POINT_Y;
            player_x <= `PLAYER_SPAWN_POINT_X;
            player_y <= `PLAYER_SPAWN_POINT_Y;
            power_count_down <= 0;
            isStart <= 1'b0;
            tilemap_dots <= 768'b000000000000000000000000000000000111111111111100001111111111111000000001000001000010000010000000010000010000010000100000100000100111111111111111111111111111111001000001001000000000010010000010010000010010000000000100100000100111111100111110011111001111111000000001000000100100000010000000000000010011111111111100100000000000000100100000000001001000000000000001111000000000011110000000000000010010000000000100100000000000000100111111111111001000000000000001001000000000010010000000011111111111111001111111111111100100000100000010010000001000001000111001111111111111111110011100000010010010000000000100100100000000100100100000000001001001000001111111001111100111110011111110010000000000001001000000000000100111111111111111111111111111110000000000000000000000000000000000;
            tilemap_big_dots <= 768'b000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        end
        else begin
            if (isStart == 1'b0 && game_state == `GAME_STATE_STANDBY)
                if((!w || !a || !s || !d)) begin
                    isStart <= 1'b1;
                    game_state <= `GAME_STATE_PLAYING;
                end
                else begin
                    isStart <= 1'b0;
                    game_state <= `GAME_STATE_STANDBY;
                end
            else if(isStart == 1'b1 && game_state == `GAME_STATE_STANDBY)
            begin
                game_state <= `GAME_STATE_PLAYING;
                isStart <= 1'b0;
            end
            else if(game_state == `GAME_STATE_PLAYING_POWER)
            begin
                if(power_count_down > 0)
                    power_count_down <= power_count_down - 1;
                else
                    game_state <= `GAME_STATE_PLAYING;
            end
            else;


            if((((ghost1_x > player_x)?ghost1_x - player_x :player_x - ghost1_x ) < `tile_size && ((ghost1_y > player_y)?ghost1_y - player_y :player_y - ghost1_y) < `tile_size) || ((ghost1_x == player_x) && ((ghost1_y > player_y) ? ((ghost1_y - player_y) == `tile_size && ghost1_direction == `dir_down && player_direction == `dir_up) : ((player_y - ghost1_y) == `tile_size && ghost1_direction == `dir_up && player_direction == `dir_down))) || ((ghost1_y == player_y) && ((ghost1_x > player_x) ? ((ghost1_x - player_x) == `tile_size && ghost1_direction == `dir_left && player_direction == `dir_right) : ((player_x - ghost1_x) == `tile_size && ghost1_direction == `dir_right && player_direction == `dir_left))))
            begin
                if(game_state == `GAME_STATE_PLAYING_POWER)
                begin
                    score <= score + `GHOST_POINTS;
                    ghost1_x <= `GHOST1_SPAWN_POINT_X;
                    ghost1_y <= `GHOST1_SPAWN_POINT_Y;
                end
                else begin
                    game_state <= `GAME_STATE_GAMEOVER;
                    ghost1_x <= ghost1_next_x;
                    ghost1_y <= ghost1_next_y;
                end
            end
            else if(game_state != `GAME_STATE_STANDBY)
            begin
                ghost1_x <= ghost1_next_x;
                ghost1_y <= ghost1_next_y;
            end
            else; 
            if((((ghost2_x > player_x)?ghost2_x - player_x :player_x - ghost2_x ) < `tile_size && ((ghost2_y > player_y)?ghost2_y - player_y :player_y - ghost2_y) < `tile_size) || ((ghost2_x == player_x  && (((ghost2_y > player_y) ? ((ghost2_y - player_y) == `tile_size && ghost2_direction == `dir_down && player_direction == `dir_up) : ((player_y - ghost2_y) == `tile_size && ghost2_direction == `dir_up && player_direction == `dir_down)))) || ((ghost2_y == player_y) && ((ghost2_x > player_x) ? ((ghost2_x - player_x) == `tile_size && ghost2_direction == `dir_left && player_direction == `dir_right) : ((player_x - ghost2_x) == `tile_size && ghost2_direction == `dir_right && player_direction == `dir_left)))))
            begin
                if(game_state == `GAME_STATE_PLAYING_POWER)
                begin
                    score <= score + `GHOST_POINTS;
                    ghost2_x <= `GHOST2_SPAWN_POINT_X;
                    ghost2_y <= `GHOST2_SPAWN_POINT_Y;
                end
                else begin
                    game_state <= `GAME_STATE_GAMEOVER;
                    ghost2_x <= ghost2_next_x;
                    ghost2_y <= ghost2_next_y;
                end
            end
            else if(game_state != `GAME_STATE_STANDBY)
            begin
                ghost2_x <= ghost2_next_x;
                ghost2_y <= ghost2_next_y;
            end
            else;
            if((((ghost3_x > player_x)?ghost3_x - player_x :player_x - ghost3_x ) < `tile_size && ((ghost3_y > player_y)?ghost3_y - player_y :player_y - ghost3_y) < `tile_size) || ((ghost3_x == player_x  && (((ghost3_y > player_y) ? ((ghost3_y - player_y) == `tile_size && ghost3_direction == `dir_down && player_direction == `dir_up) : ((player_y - ghost3_y) == `tile_size && ghost3_direction == `dir_up && player_direction == `dir_down)))) || ((ghost3_y == player_y) && ((ghost3_x > player_x) ? ((ghost3_x - player_x) == `tile_size && ghost3_direction == `dir_left && player_direction == `dir_right) : ((player_x - ghost3_x) == `tile_size && ghost3_direction == `dir_right && player_direction == `dir_left)))))
            begin
                if(game_state == `GAME_STATE_PLAYING_POWER)
                begin
                    score <= score + `GHOST_POINTS;
                    ghost3_x <= `GHOST3_SPAWN_POINT_X;
                    ghost3_y <= `GHOST3_SPAWN_POINT_Y;
                end
                else begin
                    game_state <= `GAME_STATE_GAMEOVER;
                    ghost3_x <= ghost3_next_x;
                    ghost3_y <= ghost3_next_y;
                end
            end
            else if(game_state != `GAME_STATE_STANDBY)
            begin
                ghost3_x <= ghost3_next_x;
                ghost3_y <= ghost3_next_y;
            end
            else;
            if((((ghost4_x > player_x)?ghost4_x - player_x :player_x - ghost4_x ) < `tile_size && ((ghost4_y > player_y)?ghost4_y - player_y :player_y - ghost4_y) < `tile_size) || ((ghost4_x == player_x  && (((ghost4_y > player_y) ? ((ghost4_y - player_y) == `tile_size && ghost4_direction == `dir_down && player_direction == `dir_up) : ((player_y - ghost4_y) == `tile_size && ghost4_direction == `dir_up && player_direction == `dir_down)))) || ((ghost4_y == player_y) && ((ghost4_x > player_x) ? ((ghost4_x - player_x) == `tile_size && ghost4_direction == `dir_left && player_direction == `dir_right) : ((player_x - ghost4_x) == `tile_size && ghost4_direction == `dir_right && player_direction == `dir_left)))))
            begin
                if(game_state == `GAME_STATE_PLAYING_POWER)
                begin
                    score <= score + `GHOST_POINTS;
                    ghost4_x <= `GHOST4_SPAWN_POINT_X;
                    ghost4_y <= `GHOST4_SPAWN_POINT_Y;
                end
                else begin
                    game_state <= `GAME_STATE_GAMEOVER;
                    ghost4_x <= ghost4_next_x;
                    ghost4_y <= ghost4_next_y;
                end
            end
            else if(game_state != `GAME_STATE_STANDBY)
            begin
                ghost4_x <= ghost4_next_x;
                ghost4_y <= ghost4_next_y;
            end
            else;

            if(tilemap_dots[(player_x / `tile_size) + (player_y / `tile_size) * `tile_col_num] == 1'b1)
            begin
                ateDots <= ateDots + 1'b1;
                score <= score + `DOT_POINTS;
                tilemap_dots[(player_x / `tile_size) + (player_y / `tile_size) * `tile_col_num] <= 1'b0;
            end
            else if(tilemap_big_dots[(player_x / `tile_size) + (player_y / `tile_size) * `tile_col_num] == 1'b1)
            begin
                ateDots <= ateDots + 1'b1;
                score <= score + `BIGDOT_POINTS;
                game_state <= `GAME_STATE_PLAYING_POWER;
                power_count_down <= 150000000;
                tilemap_big_dots[(player_x / `tile_size) + (player_y / `tile_size) * `tile_col_num] <= 1'b0;
            end
            else;
            
            if(game_state != `GAME_STATE_GAMEOVER)
            begin
                player_x <= player_next_x;
                player_y <= player_next_y;
            end
            else begin
                player_x <= player_x;
                player_y <= player_y;
            end

            if(ateDots == `MAX_DOTS)
                game_state <= `GAME_STATE_WIN;
            else;
        end
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

    reg [3:0] scoreDisplay [0:5];
    always @(posedge clk_5Hz or negedge reset) begin
        scoreDisplay[0] <= score % 10;
        scoreDisplay[1] <= (score % 100) / 10;
        scoreDisplay[2] <= (score % 1000) / 100;
        scoreDisplay[3] <= (score % 10000) / 1000;
        scoreDisplay[4] <= (score % 100000) / 10000;
        scoreDisplay[5] <= (score % 1000000) / 100000;
    end
    SevenDisplay seven_display0(.num(scoreDisplay[0]), .out(sevenDisplay[7*0 + 6:7*0]));
    SevenDisplay seven_display1(.num(scoreDisplay[1]), .out(sevenDisplay[7*1 + 6:7*1]));
    SevenDisplay seven_display2(.num(scoreDisplay[2]), .out(sevenDisplay[7*2 + 6:7*2]));
    SevenDisplay seven_display3(.num(scoreDisplay[3]), .out(sevenDisplay[7*3 + 6:7*3]));
    SevenDisplay seven_display4(.num(scoreDisplay[4]), .out(sevenDisplay[7*4 + 6:7*4]));
    SevenDisplay seven_display5(.num(scoreDisplay[5]), .out(sevenDisplay[7*5 + 6:7*5]));


endmodule

module FrequencyDivider_25MHz (
    input clk,
    output reg div_clock
);

    always @(posedge clk) begin
        div_clock <= ~div_clock;
    end
endmodule

module SevenDisplay(num, out);
    input[3:0] num;
    reg[6:0] out;
    output[6:0] out;

    always @(num)
    begin
        case(num)
            4'h0: out = 7'b1000000;
            4'h1: out = 7'b1111001;
            4'h2: out = 7'b0100100;
            4'h3: out = 7'b0110000;
            4'h4: out = 7'b0011001;
            4'h5: out = 7'b0010010;
            4'h6: out = 7'b0000010;
            4'h7: out = 7'b1111000;
            4'h8: out = 7'b0000000;
            4'h9: out = 7'b0010000;
            4'hA: out = 7'b0001000;
            4'hB: out = 7'b0000011;
            4'hC: out = 7'b1000110;
            4'hD: out = 7'b0100001;
            4'hE: out = 7'b0000110;
            4'hF: out = 7'b0001110;
            default: out = 7'b1111111;
        endcase
    end

endmodule
