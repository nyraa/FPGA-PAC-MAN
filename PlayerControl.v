`include "define.v"

module PlayerControl #(
    boundary_x0 = 0, boundary_x1 = 620, boundary_y0 = 0, boundary_y1 = 460,
    speed = 20
)
(
    input clk,
    input reset,
    input w, input a, input s, input d,
    inout reg [$clog2(`WIDTH) - 1:0] x,
    inout reg [$clog2(`HEIGHT) - 1:0] y,
    inout reg [1:0] player_direction,
	input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls,
	inout reg [`tile_row_num * `tile_col_num - 1:0] tilemap_dots
);

	wire [20:0] tile_idx;
	reg [1:0] cur_dir;
	reg [`width_log2 - 1:0] next_x;
	reg [`width_log2 - 1:0] next_y;

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
				x <= 20;
				y <= 20;
				// tilemap_dots <= 768'b000000000000000000000000000000000111111111111100001111111111111001000001000001000010000010000010010000010000010000100000100000100111111111111111111111111111111001000001001000000000010010000010010000010010000000000100100000100111111100111110011111001111111000000001000000100100000010000000000000010011111111111100100000000000000100100000000001001000000000000001111011111111011110000000000000010010000000000100100000000000000100111111111111001000000000000001001000000000010010000000011111111111111001111111111111100100000100000010010000001000001001111001111111111111111110011110000010010010000000000100100100000000100100100000000001001001000001111111001111100111110011111110010000000000001001000000000000100111111111111111111111111111111000000000000000000000000000000000;
        end
        else begin
				if(tilemap_dots[tile_idx] == 1)
				begin
					// score <= score + 1;
					tilemap_dots[tile_idx] <= 0;
				end
            if(!w) begin
					if (tilemap_walls[tile_idx - `tile_col_num] == 1) begin
						cur_dir <= player_direction;
						x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
						y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
					end
					else begin
						cur_dir <= `dir_up;
						player_direction <= `dir_up;
						y <= y - speed;
					end
				end
				else if(!s) begin
					if (tilemap_walls[tile_idx + `tile_col_num] == 1) begin
						cur_dir <= player_direction;
						x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
						y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
					end
					else begin
						cur_dir <= `dir_down;
						player_direction <= `dir_down;
						y <= y + speed;
					end
					end
				else if(!a) begin
					if (tilemap_walls[tile_idx - 1] == 1) begin
						cur_dir <= player_direction;
						x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
						y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
					end
					else begin
						cur_dir <= `dir_left;
						player_direction <= `dir_left;
						x <= x - speed;
					end
					end
				else if(!d) begin
					if (tilemap_walls[tile_idx+1] == 1) begin
						cur_dir <= player_direction;
						x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
						y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
					end
					else begin
						cur_dir <= `dir_right;
						player_direction <= `dir_right;
						x <= x + speed;
					end
				end
				else begin
					cur_dir <= player_direction;
					x <= x_axes(player_direction,x,y,tilemap_walls,tile_idx);
					y <= y_axes(player_direction,x,y,tilemap_walls,tile_idx);
				end
		end
		
    end
/*
always@(x or y)
begin
	if(tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + x/`tile_size] == 1)begin
		tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + x/`tile_size] = 0;
		// score = score + 1;
	end
end
*/

endmodule