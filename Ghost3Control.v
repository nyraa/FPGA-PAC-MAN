`define WIDTH 640
`define HEIGHT 480
`define tile_size 20


module Ghost3Control #(boundary_x0 = 0, boundary_x1 = 620, boundary_y0 = 0, boundary_y1 = 460,speed = 1)
(
    input clk,
    input reset,
    input [$clog2(`WIDTH) - 1:0] Player_x,
    input [$clog2(`HEIGHT) - 1:0] Player_y,
    inout reg [$clog2(`WIDTH) - 1:0] Ghost_x,
    inout reg [$clog2(`HEIGHT) - 1:0] Ghost_y,
    input [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] tilemap,
	 //output reg isOver, // isOver: 0/false, 1/true
	 output reg [1:0] direction
);

reg [3:0] Movable_dir; // w,s,a,d
reg [1:0] default_direction;
reg [1:0] next_index;
always@(Ghost_x or Ghost_y)begin
	// check which direction is movable, 1: movable, 0: unmovable
	if(Ghost_y - speed >= boundary_y0 && tilemap[(`WIDTH / `tile_size)*((Ghost_y - speed)/`tile_size) + Ghost_x/`tile_size] == 0)
		Movable_dir[0] = 1;
	else
		Movable_dir[0] = 0;
	if(Ghost_y + speed <= boundary_y1 && tilemap[(`WIDTH / `tile_size)*((Ghost_y + speed)/`tile_size) + Ghost_x/`tile_size] == 0)
		Movable_dir[1] = 1;
	else
		Movable_dir[1] = 0;
	if(Ghost_x - speed >= boundary_x0 && tilemap[(`WIDTH / `tile_size)*(Ghost_y/`tile_size) + (Ghost_x - speed)/`tile_size] == 0) 
		Movable_dir[2] = 1;
	else
		Movable_dir[2] = 0;
	if(Ghost_x + speed <= boundary_x1 && tilemap[(`WIDTH / `tile_size)*(Ghost_y/`tile_size) + (Ghost_x + speed)/`tile_size] == 0)
		Movable_dir[3] = 1;
	else
		Movable_dir[3] = 0;
	/*
	while (Movable_dir[random_index] != 0) begin
	  random_index = $random % 4;
	end
	*/
	if(default_direction == 0) // w
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
	else if(default_direction == 3) // d
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
	else if(default_direction == 1) // s
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
	else if(default_direction == 2) // a
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
end


   always @(posedge clk or negedge reset) begin
        if (!reset) begin
            Ghost_x <= 0; // start_position (must change)
            Ghost_y <= 0; // start_position (must change)
				direction <= 0; // reset direction is W
				default_direction <= 0;
        end
        else begin
//				if(Ghost_x == Player_x && ((Ghost_y > Player_y && Ghost_y - Player_y <= 10)||(Ghost_y <= Player_y && Player_y - Ghost_y <= 10)))
//					isOver <= 1;
//				else if(Ghost_y == Player_y && ((Ghost_x > Player_x && Ghost_x- Player_x <= 10)||(Ghost_x <= Player_x && Player_x - Ghost_x <= 10)))
//					isOver <= 1;
            
				// default_direction is still movable
				if(Movable_dir[default_direction] == 1)
				begin
					case(default_direction)
						0: // w
						begin
							Ghost_x <= Ghost_x;
							Ghost_y <= Ghost_y - speed;
						end
						1: // s
						begin
							Ghost_x <= Ghost_x;
							Ghost_y <= Ghost_y + speed;
						end
						2: // a
						begin
							Ghost_x <= Ghost_x - speed;
							Ghost_y <= Ghost_y;
						end
						3: // d
						begin
							Ghost_x <= Ghost_x + speed;
							Ghost_y <= Ghost_y;
						end
					endcase
					direction <= default_direction;
				end
				// until you reach walls, turn the direction 
				else 
				begin
					case(next_index)
						0: // w
						begin
							Ghost_x <= Ghost_x;
							Ghost_y <= Ghost_y - speed;
						end
						1: // s
						begin
							Ghost_x <= Ghost_x;
							Ghost_y <= Ghost_y + speed;
						end
						2: // a
						begin
							Ghost_x <= Ghost_x - speed;
							Ghost_y <= Ghost_y;
						end
						3: // d
						begin
							Ghost_x <= Ghost_x + speed;
							Ghost_y <= Ghost_y;
						end
					endcase
					direction <= next_index;
					default_direction <= next_index;
				end
        end
    end
endmodule
