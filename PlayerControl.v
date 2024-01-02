`include "define.v"

module PlayerControl #(
    speed = 20
)
(
    input clk,
    input reset,
    input w, input a, input s, input d,
    input [$clog2(`WIDTH) - 1:0] x,
    input [$clog2(`HEIGHT) - 1:0] y,
    output reg [$clog2(`WIDTH) - 1:0] next_x,
    output reg [$clog2(`HEIGHT) - 1:0] next_y,
    inout reg [1:0] player_direction,
    input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls,
    input [`tile_row_num * `tile_col_num - 1:0] tilemap_dots
);

    wire [20:0] tile_idx;
    reg [1:0] cur_dir;

    assign tile_idx = (`WIDTH / `tile_size)*(y/`tile_size) + x/`tile_size;
    
    function [$clog2(`WIDTH) - 1:0] x_axes(input [1:0] dir, input [$clog2(`WIDTH) - 1:0] x, input [$clog2(`WIDTH) - 1:0] y, input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls, input [20:0] tile_idx);
        
        if( dir == `dir_up)
            x_axes = x;
        else if( dir == `dir_down)
            x_axes = x;
        else if( dir == `dir_left && tilemap_walls[tile_idx - 1] == 0)
            x_axes = x - speed;
        else if( dir == `dir_left && tilemap_walls[tile_idx - 1] == 1)
            x_axes = x;
        else if( dir == `dir_right && tilemap_walls[tile_idx + 1] == 0)
            x_axes = x + speed;
        else 
            x_axes = x;
    endfunction
     
    function [$clog2(`WIDTH) - 1:0] y_axes(input [1:0] dir, input [$clog2(`WIDTH) - 1:0] x, input [$clog2(`WIDTH) - 1:0] y, input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls, input [20:0] tile_idx);
        
        if( dir == `dir_up && tilemap_walls[tile_idx - `tile_col_num] == 0)
            y_axes = y - speed;
        else if(dir == `dir_up && tilemap_walls[tile_idx - `tile_col_num] == 1)
            y_axes = y;
        else if( dir == `dir_down && tilemap_walls[tile_idx + `tile_col_num] == 0)
            y_axes = y + speed;
        else if(dir == `dir_down && tilemap_walls[tile_idx + `tile_col_num] == 1)
            y_axes = y;
        else if( dir == `dir_left)
            y_axes = y;
        else if( dir == `dir_right)
            y_axes = y;
    endfunction
    
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            next_x <= 20;
            next_y <= 20;
            player_direction <= `dir_left;
        end
        else begin
            if(!w) begin
                if (tilemap_walls[tile_idx - `tile_col_num] == 1) begin
                    cur_dir <= player_direction;
                    next_x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
                    next_y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
                end
                else begin
                    cur_dir <= `dir_up;
                    player_direction <= `dir_up;
                    next_x <= x;
                    next_y <= y - speed;
                end
            end
            else if(!s) begin
                if (tilemap_walls[tile_idx + `tile_col_num] == 1) begin
                    cur_dir <= player_direction;
                    next_x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
                    next_y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
                end
                else begin
                    cur_dir <= `dir_down;
                    player_direction <= `dir_down;
                    next_x <= x;
                    next_y <= y + speed;
                end
                end
            else if(!a) begin
                if (tilemap_walls[tile_idx - 1] == 1) begin
                    cur_dir <= player_direction;
                    next_x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
                    next_y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
                end
                else begin
                    cur_dir <= `dir_left;
                    player_direction <= `dir_left;
                    next_x <= x - speed;
                    next_y <= y;
                end
                end
            else if(!d) begin
                if (tilemap_walls[tile_idx+1] == 1) begin
                    cur_dir <= player_direction;
                    next_x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
                    next_y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
                end
                else begin
                    cur_dir <= `dir_right;
                    player_direction <= `dir_right;
                    next_x <= x + speed;
                    next_y <= y;
                end
            end
            else begin
                cur_dir <= player_direction;
                next_x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
                next_y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
            end
        end
    end
endmodule