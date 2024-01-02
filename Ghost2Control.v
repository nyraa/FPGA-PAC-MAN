`include "define.v"

// Pink Down-Right
module Ghost2Control #(
    speed = 20
)
(
    input clk,
    input reset,
    input [$clog2(`WIDTH) - 1:0] x,
    input [$clog2(`HEIGHT) - 1:0] y,
    output reg [$clog2(`WIDTH) - 1:0] next_x,
    output reg [$clog2(`HEIGHT) - 1:0] next_y,
    inout reg [1:0] ghost_direction,
    input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls
);

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            next_x <= 340;
            next_y <= 240;
            ghost_direction <= `dir_up;
        end
        else begin
            if((x == 420 && y == 200) || (x == 600 && y == 320)||(x == 480 && y == 380)||(x == 480 && y == 60)||(x == 280 && y == 20)||(x == 200 && y == 60)||(x == 140 && y == 120)||(x == 20 && y == 320)||(x == 340 && y == 120))begin
                next_y <= y + speed;
                    next_x <= x;
                ghost_direction <= `dir_down;
            end
            else if((x == 340 && y == 200) || (x == 360 && y == 380)||(x == 340 && y == 280)||(x == 420 && y == 240)||(x == 480 && y == 160)||(x == 20 && y == 440)||(x == 140 && y == 380)||(x == 200 && y == 320)||(x == 200 && y == 160)||(x == 280 && y == 120)||(x == 340 && y == 160))begin
                next_y <= y;
                next_x <= x + speed;
                ghost_direction <= `dir_right;
            end
            else if((x == 340 && y == 240) || (x == 360 && y == 440)||(x == 420 && y == 380)||(x == 340 && y == 320)||(x == 420 && y == 280)||(x == 480 && y == 240)||(x == 600 && y == 160)||(x == 540 && y == 120)||(x == 420 && y == 120)||(x == 340 && y == 60)||(x == 140 && y == 440)||(x == 200 && y == 380)||(x == 280 && y == 320)||(x == 200 && y == 280)||(x == 280 && y == 160))begin
                next_y <= y - speed;
                next_x <= x;
                ghost_direction <= `dir_up;
            end
            else if((x == 600 && y == 380)||(x == 480 && y == 440)||(x == 420 && y == 320)||(x == 600 && y == 120)||(x == 540 && y == 60)||(x == 480 && y == 120)||(x == 420 && y == 60)||(x == 340 && y == 20)||(x == 280 && y == 60)||(x == 200 && y == 120)||(x == 140 && y == 320)||(x == 280 && y == 280))begin
                next_y <= y;
                next_x <= x - speed;
                ghost_direction <= `dir_left;
            end
            else begin
                case(ghost_direction)
                    `dir_up: begin
                        next_y <= y - speed;
                        next_x <= x;
                    end
                    `dir_down: begin
                        next_y <= y + speed;
                        next_x <= x;
                    end
                    `dir_left: begin
                        next_y <= y;
                        next_x <= x - speed;
                    end
                    `dir_right: begin
                        next_y <= y;
                        next_x <= x + speed;
                    end
                endcase
            end
        end
    end
endmodule
