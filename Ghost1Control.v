`include "define.v"

module Ghost1Control #(
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
    inout [1:0] ghost1_direction,
	 input [`width_log2 - 1:0] player_x,
	 input [`width_log2 - 1:0] player_y
);

//reg [2:0] curr_state;
//reg [2:0] next_state;
//parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101; 


    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            x <= 100;
            y <= 100;
//				curr_state <= S0;
        end
        else begin
		  
//				curr_state <= next_state;
		  
            if(!w) begin
                if((y - speed) <= boundary_y0) y <= boundary_y0;
                else if((y - speed) >= boundary_y1) y <= y;
                else y <= y - speed;
                x <= x;
//                ghost1_direction <= `dir_up;
					 
            end
            else if(!s) begin
                if((y + speed) >= boundary_y1) y <= boundary_y1;
                else if((y + speed) <= boundary_y0) y <= y;
                else y <= y + speed;
                x <= x;
//                ghost1_direction <= `dir_down;
            end
            else if(!a) begin
                if((x - speed) <= boundary_x0) x <= boundary_x0;
                else if((x - speed) >= boundary_x1) x <= x;
                else x <= x - speed;
                y <= y;
//                ghost1_direction <= `dir_left;
            end
            else if(!d) begin
                if((x + speed) >= boundary_x1) x <= boundary_x1;
                else if((x + speed) <= boundary_x0) x <= x;
                else x <= x + speed;
                y <= y;
//                ghost1_direction <= `dir_right;
            end
        end
    end
endmodule

