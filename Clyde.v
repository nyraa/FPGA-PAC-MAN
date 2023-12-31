module Clyde #(speed = 2, boundary_x0 = 0, boundary_x1 = 620, boundary_y0 = 0, boundary_y1 = 460)

(
	 input clock, input reset,
	 input w, input a, input s, input d,
    inout reg [$clog2(`WIDTH) - 1:0] x,
    inout reg [$clog2(`HEIGHT) - 1:0] y,
    inout reg [1:0] ghostDirection,
    input [$clog2(`WIDTH) - 1:0] player_x,
    input [$clog2(`HEIGHT) - 1:0] player_y,
	 input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls
);
reg mode; // chase, frighten, dead
reg [1:0] playerDirection;

localparam Chase = 2'b 00,
           Frighten = 2'b 01,
           Dead = 2'b 10;

// TODO: add pac man eat ball and turn ghost into frighten mode
// TODO: add frighten mode count down and then turn into chase mode
// TODO: add dead mode count down and tehn turn ghost into chase mode

//initial begin
//    mode <= Chase;
//    x <= 400;
//    y <= 400;
//end

always @(posedge clock or negedge reset) begin

	 if (!reset) begin
		mode <= Chase;
		x <= 400;
		y <= 400;	
	  end else begin 
		  
		 // 1. determine player's direction
		 if (w) begin
			  playerDirection <= `dir_up;
		 end else if (a) begin
			  playerDirection <= `dir_left;
		 end else if (s) begin
			  playerDirection <= `dir_down;
		 end else if (d) begin
			  playerDirection <= `dir_right;
		 end
		 
		 // 2. determine ghost's direction
		 if (mode == Chase) begin

			  case (playerDirection)
					`dir_left:
						 if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_left;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_down;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_up;
						 end else begin
							  ghostDirection <= `dir_right;
						 end
					`dir_right:
						 if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_right;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_down;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_up;
						 end else begin
							  ghostDirection <= `dir_left;
						 end
					`dir_up:
						 if (tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_up;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_right;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_left;
						 end else begin
							  ghostDirection <= `dir_down;
						 end
					`dir_down:
						 if (tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_down;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_left;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_right;
						 end else begin
							  ghostDirection <= `dir_up;
						 end
			  endcase

		 end else if (mode == Frighten) begin

			  case (playerDirection)
					`dir_left:
						 if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_left;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_down;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_up;
						 end else begin
							  ghostDirection <= `dir_right;
						 end
					`dir_right:
						 if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_right;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_down;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_up;
						 end else begin
							  ghostDirection <= `dir_left;
						 end
					`dir_up:
						 if (tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_up;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_right;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_left;
						 end else begin
							  ghostDirection <= `dir_down;
						 end
					`dir_down:
						 if (tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 1) begin
							  ghostDirection <= `dir_down;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_left;
						 end else if (tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 1) begin
							  ghostDirection <= `dir_right;
						 end else begin
							  ghostDirection <= `dir_up;
						 end
			  endcase

		 end else begin
			  ghostDirection <= `dir_up;
		 end

		 // 3. move ghost toward the direction
		 if (ghostDirection == `dir_up) begin

			  x <= x;
			  if ((y - speed) <= boundary_y0) y <= boundary_y0;
			  else if ((y - speed) >= boundary_y1) y <= y;
			  else y <= y - speed;

		 end else if (ghostDirection == `dir_down) begin

			  x <= x;
			  if ((y + speed) >= boundary_y1) y <= boundary_y1;
			  else if ((y + speed) <= boundary_y0) y <= y;
			  else y <= y + speed;

		 end else if (ghostDirection == `dir_left) begin

			  y <= y;
			  if((x - speed) <= boundary_x0) x <= boundary_x0;
			  else if((x - speed) >= boundary_x1) x <= x;
			  else x <= x - speed;

		 end else begin
			  
			  y <= y;
			  if((x + speed) >= boundary_x1) x <= boundary_x1;
			  else if((x + speed) <= boundary_x0) x <= x;
			  else x <= x + speed;

		 end

		 // 4. collision check
		 if (mode != Dead) begin
			  if ((x == player_x) && (y == player_y)) begin
					if (mode == Chase) begin
						 // game over
					end else if (mode == Frighten) begin
						 mode <= Dead;
					end
			  end
		 end else begin
			  // nothing happen
		 end
	 end
end

endmodule