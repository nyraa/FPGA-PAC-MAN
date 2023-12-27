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
    output reg [$clog2(`WIDTH) - 1:0] x,
    output reg [$clog2(`HEIGHT) - 1:0] y,
	 output reg [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] Beans // Beans[0]: not be ate,; Beans[1]: be ate
);
reg [1:0] default_direction;
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            x <= 0; // start_x
            y <= 0; // start_y
        end
        else begin
            // TODO : change the condition to collision detection
            if(!w) begin
					 default_direction <= 0;
                if(prev_y - speed >= boundary_y0)begin
						if(tilemap[(`WIDTH / `tile_size)*((prev_y - speed)/`tile_size) + prev_x/`tile_size] == 0)begin
							y <= prev_y - speed;
							Beans[(`WIDTH / `tile_size)*((prev_y - speed)/`tile_size) + prev_x/`tile_size] <= 1;
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
						if(tilemap[(`WIDTH / `tile_size)*((prev_y + speed)/`tile_size) + prev_x/`tile_size] == 0)begin
							y <= prev_y + speed;
							Beans[(`WIDTH / `tile_size)*((prev_y + speed)/`tile_size) + prev_x/`tile_size] <= 1;
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
						if(tilemap[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x - speed)/`tile_size] == 0)begin
							x <= prev_x - speed;
							Beans[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x - speed)/`tile_size] <= 1;
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
						if(tilemap[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x + speed)/`tile_size] == 0)begin
							x <= prev_x + speed;
							Beans[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x + speed)/`tile_size] <= 1;
						end
						else 
							x <= prev_x;
					 end
					else x <= boundary_x1;
               y <= prev_y;
            end
				else begin
					case(default_direction)
						2'd0:begin // w 
						if(prev_y - speed >= boundary_y0)begin
							if(tilemap[(`WIDTH / `tile_size)*((prev_y - speed)/`tile_size) + prev_x/`tile_size] == 0)begin
								y <= prev_y - speed;
								Beans[(`WIDTH / `tile_size)*((prev_y - speed)/`tile_size) + prev_x/`tile_size] <= 1;
							end
							else 
								y <= prev_y;
						 end
						 else y <= boundary_y0;
						 x <= prev_x;
						end
						2'd1:begin
						if(prev_y + speed <= boundary_y1)begin
							if(tilemap[(`WIDTH / `tile_size)*((prev_y + speed)/`tile_size) + prev_x/`tile_size] == 0)begin
								y <= prev_y + speed;
								Beans[(`WIDTH / `tile_size)*((prev_y + speed)/`tile_size) + prev_x/`tile_size] <= 1;
							end
							else 
								y <= prev_y;
						end
						else y <= boundary_y1;
						x <= prev_x;
						end
						2'd2:begin
						if(prev_x - speed >= boundary_x0 )begin
							if(tilemap[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x - speed)/`tile_size] == 0)begin
								x <= prev_x - speed;
								Beans[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x - speed)/`tile_size] <= 1;
							end
							else 
								x <= prev_x;
						 end
						 else x <= boundary_x0;
						 y <= prev_y;
						end
						2'd3:begin
						if(prev_x + speed <= boundary_x1)begin
							if(tilemap[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x + speed)/`tile_size] == 0)begin
								x <= prev_x + speed;
								Beans[(`WIDTH / `tile_size)*(prev_y/`tile_size) + (prev_x + speed)/`tile_size] <= 1;
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
