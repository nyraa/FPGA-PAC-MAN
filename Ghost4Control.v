`include "define.v"

module Ghost4Control #(
//     width = 640, height = 480, tile_size = 20,
    boundary_x0 = 0, boundary_x1 = 620, boundary_y0 = 0, boundary_y1 = 460,
    speed = 1
)
(
    input clk,
    input reset,
    input w, input a, input s, input d,
    inout reg [$clog2(`WIDTH) - 1:0] x,
    inout reg [$clog2(`HEIGHT) - 1:0] y,
    inout [1:0] ghost4_direction,
	 input [`width_log2 - 1:0] player_x,
	 input [`width_log2 - 1:0] player_y,
	 input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls
);

	 reg [1:0] direction;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            x <= 400;
            y <= 300;
				direction <= 0;
        end
        else begin
				if(direction == 0) begin
					if((x - speed) > boundary_x0 && tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 0)begin
						x <= x - speed;
					end
					else begin
						x <= x;
						y <=y;
						direction <= 1;
					end
				end
				else if(direction == 1) begin
					if((y - speed) > boundary_y0 && tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 0)begin
						y <= y - speed;
					end
					else begin
						x <= x;
						y <=y;
						direction <= 2;
					end
				end
				else if(direction == 2) begin
					if((x + speed) < boundary_x1 && tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 0)begin
						x <= x + speed;
					end
					else begin
						x <= x;
						y <= y;
						direction <= 3;
					end
				end
				else if(direction == 3) begin
					if((y + speed) < boundary_y1 && tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 0)begin
						y <= y + speed;
					end
					else begin
						x <= x;
						y <= y;
						direction <= 0;
					end
				end
//            if(!w) begin
//                if((y - speed) <= boundary_y0) y <= boundary_y0;
//                else if((y - speed) >= boundary_y1) y <= y;
//                else y <= y - speed;
//                x <= x;
//					 
//            end
//            else if(!s) begin
//                if((y + speed) >= boundary_y1) y <= boundary_y1;
//                else if((y + speed) <= boundary_y0) y <= y;
//                else y <= y + speed;
//                x <= x;
//            end
//            else if(!a) begin
//                if((x - speed) <= boundary_x0) x <= boundary_x0;
//                else if((x - speed) >= boundary_x1) x <= x;
//                else x <= x - speed;
//                y <= y;
//            end
//            else begin
//                if((x + speed) >= boundary_x1) x <= boundary_x1;
//                else if((x + speed) <= boundary_x0) x <= x;
//                else x <= x + speed;
//                y <= y;
//            end
        end
    end
endmodule

