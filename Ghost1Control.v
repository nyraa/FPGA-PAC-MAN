`include "define.v"

// RED Down-Left
module Ghost1Control #(
//     width = 640, height = 480, tile_size = 20,
    boundary_x0 = 0, boundary_x1 = 620, boundary_y0 = 0, boundary_y1 = 460,
    speed = 20
)
(
    input clk,
    input reset,
    inout reg [$clog2(`WIDTH) - 1:0] x,
    inout reg [$clog2(`HEIGHT) - 1:0] y,
    inout reg [1:0] ghost_direction,
	 input [`width_log2 - 1:0] player_x,
	 input [`width_log2 - 1:0] player_y,
	 input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls
);



    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            x <= 20;
            y <= 320;
				ghost_direction <= `dir_right;
        end
        else begin
				if((x == 140 && y == 320) ||(x == 20 && y == 380) || (x == 600 && y == 20) ||(x == 480 && y == 60) ||(x == 420 && y == 240) ||(x == 340 && y == 280) ||(x == 420 && y == 320) ||(x == 600 && y == 320))begin
					y <= y + speed;
						x <= x;
					ghost_direction <= `dir_down;
				end
				else if((x == 20 && y == 320) || (x == 20 && y == 440) ||(x == 200 && y == 320) ||(x == 140 && y == 160) ||(x == 280 && y == 120) ||(x == 340 && y == 20) ||(x == 340 && y == 320) ||(x == 420 && y == 380) ||(x == 480 && y == 320)) begin
					y <= y;
					x <= x + speed;
					ghost_direction <= `dir_right;
				end
				else if((x == 260 && y == 440) ||(x == 200 && y == 380) ||(x == 280 && y == 320) ||(x == 200 && y == 280) ||(x == 140 && y == 240) ||(x == 280 && y == 160) ||(x == 420 && y == 120) ||(x == 340 && y == 60) ||(x == 480 && y == 380) ||(x == 360 && y == 440))begin
					y <= y - speed;
					x <= x;
					ghost_direction <= `dir_up;
				end
				else if((x == 140 && y == 380) || (x == 260 && y == 380) || (x == 280 && y == 280) ||(x == 200 && y == 240) || (x == 420 && y == 60) || (x == 600 && y == 60) ||(x == 480 && y == 240) ||(x == 420 && y == 280) ||(x == 600 && y == 440) ||(x == 360 && y == 380))begin
					y <= y;
					x <= x - speed;
					ghost_direction <= `dir_left;
				end
				else begin
					case(ghost_direction)
						`dir_up:begin
							y <= y - speed;
							x <= x;
						end
						`dir_down:begin
							y <= y + speed;
							x <= x;
						end
						`dir_left:begin
							y <= y;
							x <= x - speed;
						end
						`dir_right:begin
							y <= y;
							x <= x + speed;
						end
					
					endcase
				
				end
        end
    end
endmodule
