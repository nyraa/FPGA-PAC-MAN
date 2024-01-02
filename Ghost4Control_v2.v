`include "define.v"

// Orange Top-Left
module Ghost4Control #(
//     width = 640, height = 480, tile_size = 20,
    boundary_x0 = 0, boundary_x1 = 620, boundary_y0 = 0, boundary_y1 = 460,
    speed = 20
)
(
    input clk,
    input reset,
	 input reg [$clog2(`WIDTH) - 1:0] x,
    input reg [$clog2(`HEIGHT) - 1:0] y,
    output reg [$clog2(`WIDTH) - 1:0] next_x,
    output reg [$clog2(`HEIGHT) - 1:0] next_y,
    inout reg [1:0] ghost_direction,
	 input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls
);

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            next_x <= 20;
            next_y <= 160;
				ghost_direction <= `dir_right;
        end
        else begin
				if( (x == 140 && y == 160) ||(x == 200 && y == 240) || (x == 280 && y == 280) || (x == 200 && y == 320) || (x == 360 && y == 380) || (x == 200 && y == 60) || (x == 280 && y == 20) || (x == 140 && y == 120))begin
					next_y <= y + speed;
						next_x <= x;
					ghost_direction <= `dir_down;
				end
				else if((x == 20 && y == 160) || (x == 140 && y == 240) || (x == 200 && y == 280) || (x == 200 && y == 380) || (x == 360 && y == 440)||(x == 480 && y == 60)) begin
					next_y <= y;
					next_x <= x + speed;
					ghost_direction <= `dir_right;
				end
				else if((x == 480 && y == 380) || (x == 600 && y == 60) || (x == 600 && y == 440))begin
					next_y <= y - speed;
					next_x <= x;
					ghost_direction <= `dir_up;
				end
				else if((x == 280 && y == 320) || (x == 600 && y == 380) || (x == 600 && y == 20) || (x == 280 && y == 60) || (x == 200 && y == 120))begin
					next_y <= y;
					next_x <= x - speed;
					ghost_direction <= `dir_left;
				end
				else begin
					case(ghost_direction)
						`dir_up:begin
							next_y <= y - speed;
							next_x <= x;
						end
						`dir_down:begin
							next_y <= y + speed;
							next_x <= x;
						end
						`dir_left:begin
							next_y <= y;
							next_x <= x - speed;
						end
						`dir_right:begin
							next_y <= y;
							next_x <= x + speed;
						end
					
					endcase
				
				end
        end
    end
endmodule