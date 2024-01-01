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
    inout reg [$clog2(`WIDTH) - 1:0] x,
    inout reg [$clog2(`HEIGHT) - 1:0] y,
    inout reg [1:0] ghost_direction,
	 input [`width_log2 - 1:0] player_x,
	 input [`width_log2 - 1:0] player_y,
	 input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls
);


reg [3:0] dir_temp; // w,s,a,d
reg [1:0] next_dir;
reg [4:0] counter;

always@(x or y)begin
	if( (x == 140 && y == 160) ||(x == 200 && y == 240) || (x == 280 && y == 280) || (x == 200 && y == 320) || (x == 360 && y == 380) || (x == 200 && y == 60) || (x == 280 && y == 20) || (x == 140 && y == 120))
		next_dir = `dir_down;
	else if((x == 20 && y == 160) || (x == 140 && y == 240) || (x == 200 && y == 280) || (x == 200 && y == 380) || (x == 360 && y == 440)||(x == 480 && y == 60))
		next_dir = `dir_right;
	else if((x == 480 && y == 380) || (x == 600 && y == 60) || (x == 600 && y == 440))
		next_dir = `dir_up;
	else if((x == 280 && y == 320) || (x == 600 && y == 380) || (x == 600 && y == 20) || (x == 280 && y == 60) || (x == 200 && y == 120))
		next_dir = `dir_left;
	else 
		next_dir = next_dir;
end

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            x <= 20;
            y <= 160;
				ghost_direction <= `dir_right;
				
				counter <= 0;
//				curr_state <= S0;
        end
        else if(counter == 18) 
		  begin
				counter <= 0;
//				curr_state <= next_state;
				case(next_dir)
					`dir_up:begin
						ghost_direction <= next_dir;
						y <= y - speed;
						x <= x;
					end
					`dir_down:begin
						ghost_direction <= next_dir;
						y <= y + speed;
						x <= x;
					end
					`dir_left:begin
						ghost_direction <= next_dir;
						y <= y;
						x <= x - speed;
					end
					`dir_right:begin
						ghost_direction <= next_dir;
						y <= y;
						x <= x + speed;
					end
				endcase

        end
		  else 
				counter <= counter + 1;
    end
endmodule
