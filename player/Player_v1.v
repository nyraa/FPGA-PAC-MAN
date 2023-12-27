`define WIDTH 640
`define HEIGHT 480
`define tile_size 20

module Player #(
//     width = 640, height = 480, tile_size = 20,
    boundary_x0 = 80, boundary_x1 = 560, boundary_y0 = 60, boundary_y1 = 420,
    speed = 5
)
(
    input clk,
    input reset,
    input w, input a, input s, input d,
    input [$clog2(`WIDTH) - 1:0] prev_x,
    input [$clog2(`HEIGHT) - 1:0] prev_y,
    input [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] tilemap, // zero: wall, one: road
	 input [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] Dots
    output reg [$clog2(`WIDTH) - 1:0] x,
    output reg [$clog2(`HEIGHT) - 1:0] y,
	 output reg [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] NextDots // NextDots = 1: Beans, NextDots = 0: Not Bean
);
reg [1:0] default_direction;
    always @(posedge clk or negedge reset) begin
        if (!reset) begin 
				NextDots <= Dots; // press reset to initialize the NextDots
            x <= 0; // start_x (must change)
            y <= 0; // start_y (must change)
        end
        else begin
            if(!w) begin
					 // If you press W, then the next default direction is W;
					 default_direction <= 0;
                if(prev_y - speed >= boundary_y0)begin
						// check whether the above is wall (zero: wall, one: road)
						if(tilemap[(`WIDTH / `tile_size)*((prev_y - speed)/`tile_size) + prev_x/`tile_size] == 0)begin
							y <= prev_y - speed;
							NextDots[(`WIDTH / `tile_size)*((prev_y - speed)/`tile_size) + prev_x/`tile_size] <= 0;
						end
						else 
							y <= prev_y;
					 end
                else y <= boundary_y0;
                x <= prev_x;
            end
            else if(!s) begin
					 default_direction <= 1;
                if(prev_y + speed <= boundary_y1)begin
						// check whether the below is wall (zero: wall, one: road)
						if(tilemap[(`WIDTH / `tile_size)*((prev_y + speed)/`tile_size) + prev_x/`tile_size] == 0)begin
							y <= prev_y + speed;
							NextDots[(`WIDTH / `tile_size)*((prev_y + speed)/`tile_size) + prev_x/`tile_size] <= 0;
						end
						else 
							y <= prev_y;
					 end
                else y <= boundary_y1;
                x <= prev_x;
            end
            else if(!a) begin
					 default_direction <= 2;
                if(prev_x - speed >= boundary_x0 )begin
						// check whether the left is wall (zero: wall, one: road)
						if(tilemap[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x - speed)/`tile_size] == 0)begin
							x <= prev_x - speed;
							NextDots[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x - speed)/`tile_size] <= 0;
						end
						else 
							x <= prev_x;
					 end
                else x <= boundary_x0;
                y <= prev_y;
            end
            else if(!d) begin
					 default_direction <= 3;
                if(prev_x + speed <= boundary_x1)begin
						// check whether the right is wall (zero: wall, one: road)
						if(tilemap[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x + speed)/`tile_size] == 0)begin
							x <= prev_x + speed;
							NextDots[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x + speed)/`tile_size] <= 0;
						end
						else 
							x <= prev_x;
					 end
					else x <= boundary_x1;
               y <= prev_y;
            end
				else begin
					// if you don't press any WASD buttons => use default_direction to move until facing walls
					case(default_direction)
						2'd0:begin // w 
						if(prev_y - speed >= boundary_y0)begin
							if(tilemap[(`WIDTH / `tile_size)*((prev_y - speed)/`tile_size) + prev_x/`tile_size] == 0)begin
								y <= prev_y - speed;
								NextDots[(`WIDTH / `tile_size)*((prev_y - speed)/`tile_size) + prev_x/`tile_size] <= 1;
							end
							else 
								y <= prev_y;
						 end
						 else y <= boundary_y0;
						 x <= prev_x;
						end
						2'd1:begin // s
						if(prev_y + speed <= boundary_y1)begin
							if(tilemap[(`WIDTH / `tile_size)*((prev_y + speed)/`tile_size) + prev_x/`tile_size] == 0)begin
								y <= prev_y + speed;
								NextDots[(`WIDTH / `tile_size)*((prev_y + speed)/`tile_size) + prev_x/`tile_size] <= 1;
							end
							else 
								y <= prev_y;
						end
						else y <= boundary_y1;
						x <= prev_x;
						end
						2'd2:begin // a
						if(prev_x - speed >= boundary_x0 )begin
							if(tilemap[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x - speed)/`tile_size] == 0)begin
								x <= prev_x - speed;
								NextDots[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x - speed)/`tile_size] <= 1;
							end
							else 
								x <= prev_x;
						 end
						 else x <= boundary_x0;
						 y <= prev_y;
						end
						2'd3:begin // d
						if(prev_x + speed <= boundary_x1)begin
							if(tilemap[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x + speed)/`tile_size] == 0)begin
								x <= prev_x + speed;
								NextDots[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x + speed)/`tile_size] <= 1;
							end
							else 
								x <= prev_x;
						end
						else x <= boundary_x1;
						y <= prev_y;
						end
					endcase
				end
        end
    end
endmodule
