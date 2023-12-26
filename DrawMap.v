module DrawMap(
    input toDisplay,
    input clk,
    input [2:0] game_state,
    input [`width_log2 - 1:0] x,
    input [`height_log2 - 1:0] y,
    input [`tile_col_num_log2 + `tile_row_num_log2 - 1:0] tilemap_walls,
    input [`tile_col_num_log2 + `tile_row_num_log2 - 1:0] tilemap_dots,
    input [`tile_col_num_log2 + `tile_row_num_log2 - 1:0] tilemap_big_dots,
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
    reg [`tile_size_log2 - 1:0] tile_x;
    reg [`tile_size_log2 - 1:0] tile_y;

    reg [`tile_col_num_log2 * `tile_row_num_log2 - 1:0] tile_idx;

    always @(posedge clk) begin
        tile_x <= x % `tile_size;
        tile_y <= y % `tile_size;
        tile_idx <= x / `tile_size + (y / `tile_size) * `tile_col_num;
    end

    reg [3:0] background_r [0:`tile_size - 1][0:`tile_size - 1];
    reg [3:0] background_g [0:`tile_size - 1][0:`tile_size - 1];
    reg [3:0] background_b [0:`tile_size - 1][0:`tile_size - 1];

    reg player_mask [0:`tile_size - 1][0:`tile_size - 1];
    reg [3:0] player_r;
    reg [3:0] player_g;
    reg [3:0] player_b;

    reg ghost_mask [0:`tile_size - 1][0:`tile_size - 1];
    reg [3:0] ghost_color_r [0:3];
    reg [3:0] ghost_color_g [0:3];
    reg [3:0] ghost_color_b [0:3];

    reg dot_mask [0:`tile_size - 1][0:`tile_size - 1];
    reg big_dot_mask [0:`tile_size - 1][0:`tile_size - 1];

    reg [3:0] wall_r [0:`tile_size - 1][0:`tile_size - 1];
    reg [3:0] wall_g [0:`tile_size - 1][0:`tile_size - 1];
    reg [3:0] wall_b [0:`tile_size - 1][0:`tile_size - 1];

    
    reg [19:0] temp [0:19];
    
    integer i, j;
    initial begin
        // set background to black
        for (i = 0; i < `tile_size; i = i + 1) begin
            for (j = 0; j < `tile_size; j = j + 1) begin
                background_r[i][j] = 4'h0;
                background_g[i][j] = 4'h0;
                background_b[i][j] = 4'h0;
            end
        end
        // set player to yellow
        player_r = 4'hf;
        player_g = 4'hf;
        player_b = 4'h0;
        // set ghosts to red, pink, cyan, orange
        ghost_color_r[0] = 4'hf;
        ghost_color_g[0] = 4'h0;
        ghost_color_b[0] = 4'h0;
        ghost_color_r[1] = 4'hf;
        ghost_color_g[1] = 4'h0;
        ghost_color_b[1] = 4'hf;
        ghost_color_r[2] = 4'h0;
        ghost_color_g[2] = 4'hf;
        ghost_color_b[2] = 4'hf;
        ghost_color_r[3] = 4'hf;
        ghost_color_g[3] = 4'h7;
        ghost_color_b[3] = 4'h0;
        // set wall to blue
        for (i = 0; i < `tile_size; i = i + 1) begin
            for (j = 0; j < `tile_size; j = j + 1) begin
                wall_r[i][j] = 4'h0;
                wall_g[i][j] = 4'h0;
                wall_b[i][j] = 4'hf;
            end
        end
        // set dot mask to 1
        $readmemb("./images/dot.txt", temp);
        for (i = 0; i < `tile_size; i = i + 1) begin
            // $display("dot[%d] : %b", i, temp[i]);
            for (j = 0; j < `tile_size; j = j + 1) begin
                dot_mask[i][j] = temp[i][j];
            end
        end

        // set big dot mask to 1
        $readmemb("./images/big_dot.txt", temp);
        for (i = 0; i < `tile_size; i = i + 1) begin
            // $display("big dot[%d] : %b", i, temp[i]);
            for (j = 0; j < `tile_size; j = j + 1) begin
                big_dot_mask[i][j] = temp[i][j];
            end
        end

        // TODO: generate player mask
        $readmemb("./images/pac_man.txt", temp);
        for (i = 0; i < `tile_size; i = i + 1) begin
            // $display("player[%d] : %b", i, temp[i]);
            for (j = 0; j < `tile_size; j = j + 1) begin
                player_mask[i][j] = temp[i][j];
            end
        end

        // TODO: generate ghost mask
        // $readmemb("./images/ghost.txt", temp);
        for(i = 0; i < `tile_size; i = i + 1) begin
            for(j = 0; j < `tile_size; j = j + 1) begin
                if(player_mask[i][j] == 1'b1) begin
                    ghost_mask[i][j] = 1'b1;
                end
            end
        end
    end

    always @(clk) begin
        if(toDisplay == 1'b0) begin 
            r <= 4'h0;
            g <= 4'h0;
            b <= 4'h0;
        end
        else if(game_state == `GAME_STATE_PLAYING) begin
            if(tilemap_walls[tile_idx] == 1'b1) begin
                r <= wall_r[tile_x][tile_y];
                g <= wall_g[tile_x][tile_y];
                b <= wall_b[tile_x][tile_y];
            end
            else if(tilemap_dots[tile_idx] == 1'b1) begin
                if(dot_mask[tile_x][tile_y] == 1'b0) begin
                    r <= 4'hf;
                    g <= 4'hf;
                    b <= 4'hf;
                end
                else begin
                    r <= background_r[tile_x][tile_y];
                    g <= background_g[tile_x][tile_y];
                    b <= background_b[tile_x][tile_y];
                end
            end
            // draw characters and ghosts
            else if(inTile(x, y, player_x, player_y)) begin
                if (player_mask[x-player_x][y-player_y] == 1'b1) begin
                    r <= player_r;
                    g <= player_g;
                    b <= player_b;
                end
                else begin
                    r <= background_r[x-player_x][y-player_y];
                    g <= background_g[x-player_x][y-player_y];
                    b <= background_b[x-player_x][y-player_y];
                end
            end
            else if(inTile(x, y, ghost1_x, ghost1_y)) begin
                if (ghost_mask[x-ghost1_x][y-ghost1_y] == 1'b1) begin
                    r <= ghost_color_r[0];
                    g <= ghost_color_g[0];
                    b <= ghost_color_b[0];
                end
                else begin
                    r <= background_r[x-ghost1_x][y-ghost1_y];
                    g <= background_g[x-ghost1_x][y-ghost1_y];
                    b <= background_b[x-ghost1_x][y-ghost1_y];
                end
            end
            else if(inTile(x, y, ghost2_x, ghost2_y)) begin
                if (ghost_mask[x-ghost2_x][y-ghost2_y] == 1'b1) begin
                    r <= ghost_color_r[1];
                    g <= ghost_color_g[1];
                    b <= ghost_color_b[1];
                end
                else begin
                    r <= background_r[x-ghost2_x][y-ghost2_y];
                    g <= background_g[x-ghost2_x][y-ghost2_y];
                    b <= background_b[x-ghost2_x][y-ghost2_y];
                end
            end
            else if(inTile(x, y, ghost3_x, ghost3_y)) begin
                if (ghost_mask[x-ghost3_x][y-ghost3_y] == 1'b1) begin
                    r <= ghost_color_r[2];
                    g <= ghost_color_g[2];
                    b <= ghost_color_b[2];
                end
                else begin
                    r <= background_r[x-ghost3_x][y-ghost3_y];
                    g <= background_g[x-ghost3_x][y-ghost3_y];
                    b <= background_b[x-ghost3_x][y-ghost3_y];
                end
            end
            else if(inTile(x, y, ghost4_x, ghost4_y)) begin
                if (ghost_mask[x-ghost4_x][y-ghost4_y] == 1'b1) begin
                    r <= ghost_color_r[3];
                    g <= ghost_color_g[3];
                    b <= ghost_color_b[3];
                end
                else begin
                    r <= background_r[x-ghost4_x][y-ghost4_y];
                    g <= background_g[x-ghost4_x][y-ghost4_y];
                    b <= background_b[x-ghost4_x][y-ghost4_y];
                end
            end
            else if(tilemap_big_dots[tile_idx] == 1'b1) begin
                if(big_dot_mask[tile_x][tile_y] == 1'b0) begin
                    r <= 4'hf;
                    g <= 4'hf;
                    b <= 4'hf;
                end
                else begin
                    r <= background_r[tile_x][tile_y];
                    g <= background_g[tile_x][tile_y];
                    b <= background_b[tile_x][tile_y];
                end
            end
            else begin
                // set to wierd color to debug
                r <= 4'h4;
                g <= 4'hf;
                b <= 4'h7;
            end
        end
        else begin
            // set to wierd color to debug
            r <= 4'h7;
            g <= 4'h4;
            b <= 4'hf;
        end
    end

endmodule



