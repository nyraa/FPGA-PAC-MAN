`define WIDTH 640
`define HEIGHT 480
`define tile_size 20


module Ghost #(
//     width = 640, height = 480, tile_size = 20,
    boundary_x0 = 80, boundary_x1 = 560, boundary_y0 = 60, boundary_y1 = 420,
    speed = 5
)
(
    input clk,
    input reset,
    input [$clog2(`WIDTH) - 1:0] Player_x,
    input [$clog2(`HEIGHT) - 1:0] Player_y,
    input [$clog2(`WIDTH) - 1:0] Ghostprev_x,
    input [$clog2(`HEIGHT) - 1:0] Ghostprev_y,
    input [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] tilemap,
    output reg [$clog2(`WIDTH) - 1:0] GhostNextx,
    output reg [$clog2(`HEIGHT) - 1:0] GhostNexty,
	 output reg isOver, // isOver: 0/false, 1/true
	 output reg [1:0] direction
);

reg [3:0] Movable_dir; // w,s,a,d
reg [1:0] default_direction;
reg [1:0] next_index;
always@(Ghostprev_x or Ghostprev_y)begin
	// check which direction is movable, 1: movable, 0: unmovable
	if(Ghostprev_y - speed >= boundary_y0 && tilemap[(`WIDTH / `tile_size)*((Ghostprev_y - speed)/`tile_size) + Ghostprev_x/`tile_size] == 0)
		Movable_dir[0] = 1;
	else
		Movable_dir[0] = 0;
	if(Ghostprev_y + speed <= boundary_y1 && tilemap[(`WIDTH / `tile_size)*((Ghostprev_y + speed)/`tile_size) + Ghostprev_x/`tile_size] == 0)
		Movable_dir[1] = 1;
	else
		Movable_dir[1] = 0;
	if(Ghostprev_x - speed >= boundary_x0 && tilemap[(`WIDTH / `tile_size)*(Ghostprev_y/`tile_size) + (Ghostprev_x - speed)/`tile_size] == 0) 
		Movable_dir[2] = 1;
	else
		Movable_dir[2] = 0;
	if(Ghostprev_x + speed <= boundary_x1 && tilemap[(`WIDTH / `tile_size)*(Ghostprev_y/`tile_size) + (Ghostprev_x + speed)/`tile_size] == 0)
		Movable_dir[3] = 1;
	else
		Movable_dir[3] = 0;
	/*
	while (Movable_dir[random_index] != 0) begin
	  random_index = $random % 4;
	end
	*/
	if(default_direction == 0)
	begin
		if(Movable_dir[0] == 1)
			next_index = 0;
		else if(Movable_dir[1] == 1)
			next_index = 1;
		else if(Movable_dir[2] == 1)
			next_index = 2;
		else 
			next_index = 3;
	end
	else if(default_direction == 1)
	begin
		if(Movable_dir[1] == 1)
			next_index = 1;
		else if(Movable_dir[0] == 1)
			next_index = 0;
		else if(Movable_dir[2] == 1)
			next_index = 2;
		else 
			next_index = 3;
	end
	else if(default_direction == 2)
	begin
		if(Movable_dir[2] == 1)
			next_index = 2;
		else if(Movable_dir[0] == 1)
			next_index = 0;
		else if(Movable_dir[1] == 1)
			next_index = 1;
		else 
			next_index = 3;
	end
	else 
	begin
		if(Movable_dir[3] == 1)
			next_index = 3;
		else if(Movable_dir[0] == 1)
			next_index = 0;
		else if(Movable_dir[1] == 1)
			next_index = 1;
		else 
			next_index = 2;
	end
end


   always @(posedge clk or negedge reset) begin
        if (!reset) begin
            GhostNextx <= 0; // start_position (must change)
            GhostNexty <= 0; // start_position (must change)
				direction <= 0; // reset direction is W
				default_direction <= 0;
        end
        else begin
				if(Ghostprev_x == Player_x && ((Ghostprev_y > Player_y && Ghostprev_y - Player_y <= 10)||(Ghostprev_y <= Player_y && Player_y - Ghostprev_y <= 10)))
					isOver <= 1;
				else if(Ghostprev_y == Player_y && ((Ghostprev_x > Player_x && Ghostprev_x- Player_x <= 10)||(Ghostprev_x <= Player_x && Player_x - Ghostprev_x <= 10)))
					isOver <= 1;
            
				// default_direction is still movable
				if(Movable_dir[default_direction] == 1)
				begin
					case(default_direction)
						0:
						begin
							GhostNextx <= Ghostprev_x;
							GhostNexty <= Ghostprev_y - speed;
						end
						1: 
						begin
							GhostNextx <= Ghostprev_x;
							GhostNexty <= Ghostprev_y + speed;
						end
						2:
						begin
							GhostNextx <= Ghostprev_x - speed;
							GhostNexty <= Ghostprev_y;
						end
						3:
						begin
							GhostNextx <= Ghostprev_x + speed;
							GhostNexty <= Ghostprev_y;
						end
					endcase
					direction <= default_direction;
				end
				// until you reach walls, turn the direction 
				else 
				begin
					case(next_index)
						0:
						begin
							GhostNextx <= Ghostprev_x;
							GhostNexty <= Ghostprev_y - speed;
						end
						1: 
						begin
							GhostNextx <= Ghostprev_x;
							GhostNexty <= Ghostprev_y + speed;
						end
						2:
						begin
							GhostNextx <= Ghostprev_x - speed;
							GhostNexty <= Ghostprev_y;
						end
						3:
						begin
							GhostNextx <= Ghostprev_x + speed;
							GhostNexty <= Ghostprev_y;
						end
					endcase
					direction <= next_index;
					default_direction <= next_index;
				end
        end
    end
endmodule
