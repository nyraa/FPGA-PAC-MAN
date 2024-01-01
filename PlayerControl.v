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

	wire [31:0] tile_idx;
	reg [2:0] cur_dir;
	reg [`width_log2 - 1:0] next_x;
	reg [`width_log2 - 1:0] next_y;

	assign tile_idx = (`WIDTH / `tile_size)*(y/`tile_size) + x/`tile_size;
	 
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            x <= 20;
            y <= 20;
        end
        else begin
            if(!w) begin
				if (tilemap_walls[tile_idx-`tile_col_num] == 1) begin
					cur_dir <= player_direction;
				end
				else begin
					cur_dir <= `dir_up;
				end
			end
			else if(!s) begin
				if (tilemap_walls[tile_idx+`tile_col_num] == 1) begin
					cur_dir <= player_direction;
				end
				else begin
					cur_dir <= `dir_down;
				end
            end
			else if(!a) begin
				if (tilemap_walls[tile_idx-1] == 1) begin
					cur_dir <= player_direction;
				end
				else begin
					cur_dir <= `dir_left;
				end
			end
			else if(!d) begin
				if (tilemap_walls[tile_idx+1] == 1) begin
					cur_dir <= player_direction;
				end
				else begin
					cur_dir <= `dir_right;
				end
			end
			else begin
				cur_dir <= player_direction;
			end
			player_direction <= cur_dir;

			case(cur_dir)
				`dir_up: begin
					x <= x;
					y <= y - speed;
				end
				`dir_down: begin
					x <= x;
					y <= y + speed;
				end
				`dir_left: begin
					x <= x - speed;
					y <= y;
				end
				`dir_right: begin
					x <= x + speed;
					y <= y;
				end
			endcase
			if (x < 0) begin
				x <= 0;
			end
			else if (x > 620) begin
				x <= 620;
			end
			else begin
				x <= x;
			end
			if (y < 0) begin
				y <= 0;
			end
			else if (y > 460) begin
				y <= 460;
			end
			else begin
				y <= y;
			end
		end
		
		

    end
endmodule

module move_char #(speed = 20)
(
	input clk,
	input reset,
	input [1:0] dir,
	input [31:0] x,
	input [31:0] y,
	output reg [31:0] next_x,
	output reg [31:0] next_y
);

	always @(posedge clk or negedge reset) begin
		if (!reset) begin
			next_x <= 20;
			next_y <= 20;
		end
		else begin
			case(dir)
				`dir_up: begin
					next_x <= x;
					next_y <= y - speed;
				end
				`dir_down: begin
					next_x <= x;
					next_y <= y + speed;
				end
				`dir_left: begin
					next_x <= x - speed;
					next_y <= y;
				end
				`dir_right: begin
					next_x <= x + speed;
					next_y <= y;
				end
			endcase
			if (next_x < 0) begin
				next_x <= 0;
			end
			else if (next_x > 620) begin
				next_x <= 620;
			end
			else begin
				next_x <= next_x;
			end
			if (next_y < 0) begin
				next_y <= 0;
			end
			else if (next_y > 460) begin
				next_y <= 460;
			end
			else begin
				next_y <= next_y;
			end
		end
	end
endmodule

