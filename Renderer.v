`include "define.v"

module Renderer(
    input toDisplay,
    input clk,
    input [2:0] game_state,
    input [`width_log2 - 1:0] x,
    input [`height_log2 - 1:0] y,
    input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls,
    input [`tile_row_num * `tile_col_num - 1:0] tilemap_dots,
    input [`tile_row_num * `tile_col_num - 1:0] tilemap_big_dots,
    input [`width_log2 - 1:0] player_x,
    input [`height_log2 - 1:0] player_y,
    input [`width_log2 - 1:0] ghost1_x,
    input [`height_log2 - 1:0] ghost1_y,
    input [`width_log2 - 1:0] ghost2_x,
    input [`height_log2 - 1:0] ghost2_y,
    input [`width_log2 - 1:0] ghost3_x,
    input [`height_log2 - 1:0] ghost3_y,
    input [`width_log2 - 1:0] ghost4_x,
    input [`height_log2 - 1:0] ghost4_y,
    input [1:0] player_direction,
    input [1:0] ghost1_direction,
    input [1:0] ghost2_direction,
    input [1:0] ghost3_direction,
    input [1:0] ghost4_direction,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b
);

    // x, y is the coordinate of the pixel, tile_x, tile_y is the coordinate of the tile
    function inTile;
        input [`width_log2 - 1:0] x;
        input [`height_log2 - 1:0] y;
        input [`width_log2 - 1:0] tile_x;
        input [`height_log2 - 1:0] tile_y;
        begin
            inTile = ((tile_x + `tile_size) > x && x >= tile_x) && ((tile_y + `tile_size) > y && y >= tile_y);
        end
    endfunction

    task rotate;
        input [`width_log2 - 1:0] x;
        input [`height_log2 - 1:0] y;
        input [1:0] direction;
        output [`width_log2 - 1:0] rotate_x;
        output [`height_log2 - 1:0] rotate_y;
        begin
            case(direction)
                `dir_right: begin
                    rotate_x = x;
                    rotate_y = y;
                end
                `dir_left: begin
                    rotate_x = `tile_size - 1 - x;
                    rotate_y = y;
                end
                `dir_up: begin
                    rotate_x = `tile_size - 1 - y;
                    rotate_y = x;
                end
                `dir_down: begin
                    rotate_x = y;
                    rotate_y = `tile_size - 1 - x;
                end
            endcase
        end
    endtask

    wire [`tile_size_log2 - 1:0] tile_x;
    wire [`tile_size_log2 - 1:0] tile_y;

    wire [`tile_col_num_log2 * `tile_row_num_log2 - 1:0] tile_idx;

    wire [`MAX_ANIMATION_FRAME_LOG2 - 1 : 0] animation_timer;
    // 5/7.5Hz
    FrequencyDivider #(.target_frequency(10)) animation_clk_divider(clk, reset, animation_timer);
    FrequencyDivider #(.target_frequency(15)) animation_clk_divider_2(clk, reset, animation_timer_char);

    wire [`tile_size * `tile_size * 4 - 1:0] background_r;
    wire [`tile_size * `tile_size * 4 - 1:0] background_g;
    wire [`tile_size * `tile_size * 4 - 1:0] background_b;

    wire [`tile_size * `tile_size - 1:0] player_mask_f1;
    wire [`tile_size * `tile_size - 1:0] player_mask_f2;
    reg player_mask_pixel;

    wire [`tile_size * `tile_size - 1:0] ghost_mask_f1;
    wire [`tile_size * `tile_size - 1:0] ghost_mask_f2;
    reg ghost_mask_pixel;

    // white of eyes
    wire [`tile_size * `tile_size - 1:0] ghost_sclera_mask_up;
    wire [`tile_size * `tile_size - 1:0] ghost_sclera_mask_down;
    wire [`tile_size * `tile_size - 1:0] ghost_sclera_mask_left;
    wire [`tile_size * `tile_size - 1:0] ghost_sclera_mask_right;
    // black of eyes
    wire [`tile_size * `tile_size - 1:0] ghost_eye_mask_up;
    wire [`tile_size * `tile_size - 1:0] ghost_eye_mask_down;
    wire [`tile_size * `tile_size - 1:0] ghost_eye_mask_left;
    wire [`tile_size * `tile_size - 1:0] ghost_eye_mask_right;

    wire [`tile_size * `tile_size - 1:0] dot_mask;
    wire [`tile_size * `tile_size - 1:0] big_dot_mask;

    wire [`tile_size * `tile_size * 4 - 1:0] wall_r;
    wire [`tile_size * `tile_size * 4 - 1:0] wall_g;
    wire [`tile_size * `tile_size * 4 - 1:0] wall_b;

    wire [`CONGRATULATIONS_MASK_WIDTH * `CONGRATULATIONS_MASK_HEIGHT - 1:0] congratulations_mask;

    // reg [19:0] temp [0:19];

    wire [`tile_size_log2 - 1:0] rotate_x;
    wire [`tile_size_log2 - 1:0] rotate_y;

    wire [`tile_size_log2 - 1:0] rotate_x2;
    wire [`tile_size_log2 - 1:0] rotate_y2;
    
    integer i, j;
    
    assign tile_x = x % `tile_size;
    assign tile_y = y % `tile_size;
    assign tile_idx = x / `tile_size + (y / `tile_size) * `tile_col_num;
    assign tile_pos = tile_x + tile_y * `tile_size;

    ReadImages readImages(
        .background_r(background_r),
        .background_g(background_g),
        .background_b(background_b),
        .wall_r(wall_r),
        .wall_g(wall_g),
        .wall_b(wall_b),
        .player_mask_f1(player_mask_f1),
        .player_mask_f2(player_mask_f2),
        .ghost_mask_f1(ghost_mask_f1),
        .ghost_mask_f2(ghost_mask_f2),
        .dot_mask(dot_mask),
        .big_dot_mask(big_dot_mask),
        .ghost_sclera_mask_up(ghost_sclera_mask_up),
        .ghost_sclera_mask_down(ghost_sclera_mask_down),
        .ghost_sclera_mask_left(ghost_sclera_mask_left),
        .ghost_sclera_mask_right(ghost_sclera_mask_right),
        .ghost_eye_mask_up(ghost_eye_mask_up),
        .ghost_eye_mask_down(ghost_eye_mask_down),
        .ghost_eye_mask_left(ghost_eye_mask_left),
        .ghost_eye_mask_right(ghost_eye_mask_right),
        .congratulations_mask(congratulations_mask)
    );

    Rotate rot(x-player_x, y-player_y, player_direction, rotate_x2, rotate_y2);

    always @(*) begin
        if(toDisplay == 1'b0) begin 
            r <= 4'h0;
            g <= 4'h0;
            b <= 4'h0;
        end
        else if(game_state == `GAME_STATE_PLAYING || game_state == `GAME_STATE_WIN) begin
            
            r <= background_r[(tile_x + tile_y * `tile_size) * 4 +: 4];
            g <= background_g[(tile_x + tile_y * `tile_size) * 4 +: 4];
            b <= background_b[(tile_x + tile_y * `tile_size) * 4 +: 4];

            if(tilemap_walls[tile_idx] == 1'b1) begin
                r <= wall_r[(tile_x + tile_y * `tile_size) * 4 +: 4];
                g <= wall_g[(tile_x + tile_y * `tile_size) * 4 +: 4];
                b <= wall_b[(tile_x + tile_y * `tile_size) * 4 +: 4];
            end
            // draw characters and ghosts
            else if(inTile(x, y, player_x, player_y)) begin
                // rotate(x - player_x, y - player_y, player_direction, rotate_x, rotate_y);
                case(animation_timer_char % 2'h2)
                    2'h0: player_mask_pixel = player_mask_f1[rotate_x2 + rotate_y2 * `tile_size];
                    2'h1: player_mask_pixel = player_mask_f2[rotate_x2 + rotate_y2 * `tile_size];
                endcase
                if(player_mask_pixel == 1'b1) begin
                    r <= `player_r;
                    g <= `player_g;
                    b <= `player_b;
                end
                else ;
            end
            
            else if(inTile(x, y, ghost1_x, ghost1_y)) begin
                // rotate(x - ghost1_x, y - ghost1_y, ghost1_direction, rotate_x, rotate_y);
                case(animation_timer % 2'h2)
                    2'h0: ghost_mask_pixel = ghost_mask_f1[(x - ghost1_x) + (y - ghost1_y) * `tile_size];
                    2'h1: ghost_mask_pixel = ghost_mask_f2[(x - ghost1_x) + (y - ghost1_y) * `tile_size];
                endcase
                if (ghost_mask_pixel == 1'b1) begin
                    r <= `ghost1_r;
                    g <= `ghost1_g;
                    b <= `ghost1_b;
                end
                else ;
                case(ghost1_direction)
                    `dir_up:
                    begin
                        if(ghost_eye_mask_up[(x - ghost1_x) + (y - ghost1_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_up[(x - ghost1_x) + (y - ghost1_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_down:
                    begin
                        if(ghost_eye_mask_down[(x - ghost1_x) + (y - ghost1_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_down[(x - ghost1_x) + (y - ghost1_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_left:
                    begin
                        if(ghost_eye_mask_left[(x - ghost1_x) + (y - ghost1_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_left[(x - ghost1_x) + (y - ghost1_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_right:
                    begin
                        if(ghost_eye_mask_right[(x - ghost1_x) + (y - ghost1_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_right[(x - ghost1_x) + (y - ghost1_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                endcase

            end
            else if(inTile(x, y, ghost2_x, ghost2_y)) begin
                // rotate(x - ghost2_x, y - ghost2_y, ghost2_direction, rotate_x, rotate_y);
                case(animation_timer % 2'h2)
                    2'h0: ghost_mask_pixel = ghost_mask_f1[(x - ghost2_x) + (y - ghost2_y) * `tile_size];
                    2'h1: ghost_mask_pixel = ghost_mask_f2[(x - ghost2_x) + (y - ghost2_y) * `tile_size];
                endcase
                if (ghost_mask_pixel == 1'b1) begin
                    r <= `ghost2_r;
                    g <= `ghost2_g;
                    b <= `ghost2_b;
                end
                else ;
                case(ghost2_direction)
                    `dir_up:
                    begin
                        if(ghost_eye_mask_up[(x - ghost2_x) + (y - ghost2_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_up[(x - ghost2_x) + (y - ghost2_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_down:
                    begin
                        if(ghost_eye_mask_down[(x - ghost2_x) + (y - ghost2_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_down[(x - ghost2_x) + (y - ghost2_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_left:
                    begin
                        if(ghost_eye_mask_left[(x - ghost2_x) + (y - ghost2_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_left[(x - ghost2_x) + (y - ghost2_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_right:
                    begin
                        if(ghost_eye_mask_right[(x - ghost2_x) + (y - ghost2_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_right[(x - ghost2_x) + (y - ghost2_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                endcase
            end
            else if(inTile(x, y, ghost3_x, ghost3_y)) begin
                // rotate(x - ghost3_x, y - ghost3_y, ghost3_direction, rotate_x, rotate_y);
                case(animation_timer % 2'h2)
                    2'h0: ghost_mask_pixel = ghost_mask_f1[(x - ghost3_x) + (y - ghost3_y) * `tile_size];
                    2'h1: ghost_mask_pixel = ghost_mask_f2[(x - ghost3_x) + (y - ghost3_y) * `tile_size];
                endcase
                if (ghost_mask_pixel == 1'b1) begin
                    r <= `ghost3_r;
                    g <= `ghost3_g;
                    b <= `ghost3_b;
                end
                else ;
                case(ghost3_direction)
                    `dir_up:
                    begin
                        if(ghost_eye_mask_up[(x - ghost3_x) + (y - ghost3_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_up[(x - ghost3_x) + (y - ghost3_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_down:
                    begin
                        if(ghost_eye_mask_down[(x - ghost3_x) + (y - ghost3_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_down[(x - ghost3_x) + (y - ghost3_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_left:
                    begin
                        if(ghost_eye_mask_left[(x - ghost3_x) + (y - ghost3_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_left[(x - ghost3_x) + (y - ghost3_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_right:
                    begin
                        if(ghost_eye_mask_right[(x - ghost3_x) + (y - ghost3_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_right[(x - ghost3_x) + (y - ghost3_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                endcase
            end
            else if(inTile(x, y, ghost4_x, ghost4_y)) begin
                // rotate(x - ghost4_x, y - ghost4_y, ghost4_direction, rotate_x, rotate_y);
                case(animation_timer % 2'h2)
                    2'h0: ghost_mask_pixel = ghost_mask_f1[(x - ghost4_x) + (y - ghost4_y) * `tile_size];
                    2'h1: ghost_mask_pixel = ghost_mask_f2[(x - ghost4_x) + (y - ghost4_y) * `tile_size];
                endcase
                if (ghost_mask_pixel == 1'b1) begin
                    r <= `ghost4_r;
                    g <= `ghost4_g;
                    b <= `ghost4_b;
                end
                else ;
                case(ghost4_direction)
                    `dir_up:
                    begin
                        if(ghost_eye_mask_up[(x - ghost4_x) + (y - ghost4_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_up[(x - ghost4_x) + (y - ghost4_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_down:
                    begin
                        if(ghost_eye_mask_down[(x - ghost4_x) + (y - ghost4_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_down[(x - ghost4_x) + (y - ghost4_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_left:
                    begin
                        if(ghost_eye_mask_left[(x - ghost4_x) + (y - ghost4_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_left[(x - ghost4_x) + (y - ghost4_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                    `dir_right:
                    begin
                        if(ghost_eye_mask_right[(x - ghost4_x) + (y - ghost4_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_eye_r;
                            g <= `ghost_eye_g;
                            b <= `ghost_eye_b;
                        end
                        else if(ghost_sclera_mask_right[(x - ghost4_x) + (y - ghost4_y) * `tile_size] == 1'b1) begin
                            r <= `ghost_sclera_r;
                            g <= `ghost_sclera_g;
                            b <= `ghost_sclera_b;
                        end
                        else ;
                    end
                endcase
            end
            else if(tilemap_big_dots[tile_idx] == 1'b1) begin
                if(big_dot_mask[tile_x + tile_y * `tile_size] == 1'b1) begin
                    r <= 4'hf;
                    g <= 4'hf;
                    b <= 4'hf;
                end
                else begin
                    r <= background_r[(tile_x + tile_y * `tile_size) * 4 +: 4];
                    g <= background_g[(tile_x + tile_y * `tile_size) * 4 +: 4];
                    b <= background_b[(tile_x + tile_y * `tile_size) * 4 +: 4];
                end
            end
            else if(tilemap_dots[tile_idx] == 1'b1) begin
                if(dot_mask[tile_x + tile_y * `tile_size] == 1'b1) begin
                    r <= 4'hf;
                    g <= 4'hf;
                    b <= 4'hf;
                end
                else ;
            end
            else begin
                r <= background_r[(tile_x + tile_y * `tile_size) * 4 +: 4];
                g <= background_g[(tile_x + tile_y * `tile_size) * 4 +: 4];
                b <= background_b[(tile_x + tile_y * `tile_size) * 4 +: 4];
            end
            if(game_state == `GAME_STATE_WIN)
            begin
                if(x > `CONGRATULATIONS_X && x < `CONGRATULATIONS_X + `CONGRATULATIONS_MASK_WIDTH && y > `CONGRATULATIONS_Y && y < `CONGRATULATIONS_Y + `CONGRATULATIONS_MASK_HEIGHT)
                begin
                    if(congratulations_mask[x - `CONGRATULATIONS_X - 1 + (y - `CONGRATULATIONS_Y - 1) * `CONGRATULATIONS_MASK_WIDTH] == 1'b1) begin
                        r <= 4'h0;
                        g <= 4'hf;
                        b <= 4'hf;
                    end
                    if(congratulations_mask[x - `CONGRATULATIONS_X + (y - `CONGRATULATIONS_Y) * `CONGRATULATIONS_MASK_WIDTH] == 1'b1) begin
                        r <= 4'hf;
                        g <= 4'hf;
                        b <= 4'hf;
                    end
                end
            end
            else ;
        end
        else begin
            // set to light purple to debug
            r <= 4'h7;
            g <= 4'h4;
            b <= 4'hf;
        end
    end

endmodule

module Rotate(
    input [`width_log2 - 1:0] x,
    input [`height_log2 - 1:0] y,
    input [1:0] direction,
    output [`width_log2 - 1:0] rotate_x,
    output [`height_log2 - 1:0] rotate_y
);
    // assign rotate_x = (direction == `dir_right) ? x : (direction == `dir_left) ? `tile_size - 1 - x : (direction == `dir_up) ? `tile_size - 1 - y : y;
    // assign rotate_y = (direction == `dir_right) ? y : (direction == `dir_left) ? y : (direction == `dir_up) ? x : `tile_size - 1 - x;
    assign rotate_x = (direction == `dir_left) ? x : (direction == `dir_right) ? `tile_size - 1 - x : (direction == `dir_down) ? `tile_size - 1 - y : y;
    assign rotate_y = (direction == `dir_left) ? y : (direction == `dir_right) ? y : (direction == `dir_down) ? x : `tile_size - 1 - x;


endmodule

