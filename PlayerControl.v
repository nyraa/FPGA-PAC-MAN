`include "define.v"

module PlayerControl #(
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
    inout reg [1:0] player_direction
);


    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            x <= 0;
            y <= 0;
        end
        else begin
            if(!w) begin
                if((y - speed) <= boundary_y0) y <= boundary_y0;
                else if((y - speed) >= boundary_y1) y <= y;
                else y <= y - speed;
                x <= x;
                player_direction <= `dir_up;
            end
            else if(!s) begin
                if((y + speed) >= boundary_y1) y <= boundary_y1;
                else if((y + speed) <= boundary_y0) y <= y;
                else y <= y + speed;
                x <= x;
                player_direction <= `dir_down;
            end
            else if(!a) begin
                if((x - speed) <= boundary_x0) x <= boundary_x0;
                else if((x - speed) >= boundary_x1) x <= x;
                else x <= x - speed;
                y <= y;
                player_direction <= `dir_left;
            end
            else if(!d) begin
                if((x + speed) >= boundary_x1) x <= boundary_x1;
                else if((x + speed) <= boundary_x0) x <= x;
                else x <= x + speed;
                y <= y;
                player_direction <= `dir_right;
            end
        end
    end
endmodule