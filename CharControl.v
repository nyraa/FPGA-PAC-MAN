module CharControl #(
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
    input [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] tilemap,
    output reg [$clog2(`WIDTH) - 1:0] x,
    output reg [$clog2(`HEIGHT) - 1:0] y
);

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            x <= 0;
            y <= 0;
        end
        else begin
            // TODO : change the condition to collision detection
            if(!w) begin
                if(prev_y - speed >= boundary_y0) y <= prev_y - speed;
                else y <= boundary_y0;
                x <= prev_x;
            end
            else if(!s) begin
                if(prev_y + speed <= boundary_y1) y <= prev_y + speed;
                else y <= boundary_y1;
                x <= prev_x;
            end
            else if(!a) begin
                if(prev_x - speed >= boundary_x0) x <= prev_x - speed;
                else x <= boundary_x0;
                y <= prev_y;
            end
            else if(!d) begin
                if(prev_x + speed <= boundary_x1) x <= prev_x + speed;
                else x <= boundary_x1;
                y <= prev_y;
            end
        end
    end
endmodule