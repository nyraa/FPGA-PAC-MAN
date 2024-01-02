
`define WIDTH 640
`define HEIGHT 480
`define tile_size 20

`define dir_up 0
`define dir_down 1
`define dir_left 2
`define dir_right 3
module Player#( boundary_x0 = 0, boundary_x1 = 620, boundary_y0 = 0, boundary_y1 = 460,speed = 5)
(
	input clk,
	input reset,
	input w, input a,input s, input d,
	inout reg [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] tilemap_walls,
	inout reg [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] tilemap_dots,
	inout reg [$clog2(`WIDTH) - 1:0] player_x,
	inout reg [$clog2(`HEIGHT) - 1:0] player_y,
	inout reg [255:0] score,
	inout reg [1:0] default_direction // PacMan direction
);

//reg [] next_tile_idx;


	always @(posedge clk or negedge reset) begin
        if (!reset) begin
            player_x <= 0; // start_x (must change)
            player_y <= 0; // start_y (must change)
				score <= 0;
				default_direction <= 0;
        end
		  else 
		  begin
				if(!w)
				begin
					default_direction <= 0;
					if(player_y >= speed)begin
						if(tilemap_walls[(`WIDTH / `tile_size)*((player_y - speed)/`tile_size) + player_x/`tile_size] == 0)
						begin
							player_y <= player_y - speed;
							if( tilemap_dots[(`WIDTH / `tile_size)*((player_y - speed)/`tile_size) + player_x/`tile_size] == 1)
							begin
								score <= score + 1;
								tilemap_dots[(`WIDTH / `tile_size)*((player_y - speed)/`tile_size) + player_x/`tile_size] <= 0;
							end
						end
					 end
                else player_y <= boundary_y0;
				end
				
				else if(!s)
				begin
					default_direction <= 1;
					if(player_y + speed <= boundary_y1)begin
						if(tilemap_walls[(`WIDTH / `tile_size)*((player_y + speed)/`tile_size) + player_x/`tile_size] == 0)
						begin
							player_y <= player_y + speed;
							if( tilemap_dots[(`WIDTH / `tile_size)*((player_y + speed)/`tile_size) + player_x/`tile_size] == 1)
							begin
								score <= score + 1;
								tilemap_dots[(`WIDTH / `tile_size)*((player_y + speed)/`tile_size) + player_x/`tile_size] <= 0;
							end
						end
					 end
                else player_y <= boundary_y0;
				end
				
				else if(!a)
				begin
					default_direction <= 2;
					if(player_x >= speed)begin
						if(tilemap_walls[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x - speed)/`tile_size] == 0)
						begin
							player_x <= player_x - speed;
							if( tilemap_dots[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x - speed)/`tile_size] == 1)
							begin
								score <= score + 1;
								tilemap_dots[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x - speed)/`tile_size] <= 0;
							end
						end
					 end
                else player_x <= boundary_x0;
				end
				
				else if(!d)
				begin
					default_direction <= 3;
					if(player_x >= speed)begin
						if(tilemap_walls[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x + speed)/`tile_size] == 0)begin
							player_x <= player_x + speed;
							if( tilemap_dots[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x + speed)/`tile_size] == 1)
							begin
								score <= score + 1;
								tilemap_dots[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x + speed)/`tile_size] <= 0;
							end
						end
					 end
                else player_x <= boundary_x0;
				end
				
				
				else 
				begin
					case(default_direction)
						`dir_up:
						begin
							default_direction <= 0;
							if(player_y >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((player_y - speed)/`tile_size) + player_x/`tile_size] == 0)
								begin
									player_y <= player_y - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((player_y - speed)/`tile_size) + player_x/`tile_size] == 1)
									begin
										score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((player_y - speed)/`tile_size) + player_x/`tile_size] <= 0;
									end
								end
							 end
							 else player_y <= boundary_y0;
						end
						`dir_down:
						begin
							default_direction <= 1;
							if(player_y + speed <= boundary_y1)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((player_y + speed)/`tile_size) + player_x/`tile_size] == 0)
								begin
									player_y <= player_y + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((player_y + speed)/`tile_size) + player_x/`tile_size] == 1)
									begin
										score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((player_y + speed)/`tile_size) + player_x/`tile_size] <= 0;
									end
								end
							 end
							 else player_y <= boundary_y0;
						end
						`dir_left:
						begin
							default_direction <= 2;
							if(player_x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x - speed)/`tile_size] == 0)
								begin
									player_x <= player_x - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x - speed)/`tile_size] == 1)
									begin
										score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x - speed)/`tile_size] <= 0;
									end
								end
							 end
							 else player_x <= boundary_x0;
						end
						`dir_right:
						begin
							default_direction <= 3;
							if(player_x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x + speed)/`tile_size] == 0)begin
									player_x <= player_x + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x + speed)/`tile_size] == 1)
									begin
										score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(player_y/`tile_size) + (player_x + speed)/`tile_size] <= 0;
									end
								end
							 end
							 else player_x <= boundary_x0;
						end
					endcase
				end
		  end
	end
endmodule 
