`include "define.v"

module PacMan
// #(
//     parameter width = 640, parameter height = 480, parameter target_frequency = 60,
//     parameter hsync_pulse_width = 96, parameter hsync_back_porch = 48, parameter hsync_front_porch = 16,
//     parameter vsync_pulse_width = 2,  parameter vsync_back_porch = 33, parameter vsync_front_porch = 10,
//     parameter tile_size = 20
// )
(
    input clk_50MHz,
    input reset,
    input w,
    input a,
    input s,
    input d,
    output reg hsync,
    output reg vsync,
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue
);

    // clk for VGA
    wire clk_25MHz;
    FrequencyDivider_25MHz clk_divider(clk_50MHz, clk_25MHz);

    wire [1:0] hstate;
    wire [1:0] vstate;

    wire [$clog2(`WIDTH) - 1:0] x;
    wire [$clog2(`HEIGHT) - 1:0] y;

    VGAStateMachine vga_sm(clk_25MHz, reset, x, y, hstate, vstate);


    wire [(`WIDTH / `tile_size) * (`HEIGHT / `tile_size) - 1:0] tilemap;

    // TODO : initialize tilemap

    wire [`tile_size - 1:0] tiled_wall_r [`tile_size - 1:0];
    wire [`tile_size - 1:0] tiled_wall_g [`tile_size - 1:0];
    wire [`tile_size - 1:0] tiled_wall_b [`tile_size - 1:0];

    // TODO : initialize tile_pic_r, tile_pic_g, tile_pic_b

    reg [$clog2(`WIDTH) - 1:0] prev_x;
    reg [$clog2(`HEIGHT) - 1:0] prev_y;
    wire [$clog2(`WIDTH) - 1:0] char_x;
    wire [$clog2(`HEIGHT) - 1:0] char_y;

    // clk for char update
    wire clk_5Hz;
    FrequencyDivider #(.target_frequency(5)) char_clk_divider(clk_50MHz, reset, clk_5Hz);

    CharControl #(
        .boundary_x0(80), .boundary_x1(560), .boundary_y0(60), .boundary_y1(420),
        .speed(5)
    ) char_ctl(clk_5Hz, reset, w, a, s, d, prev_x, prev_y, tilemap, char_x, char_y);

    // TODO : add ghosts' data and behaviors


    always @(posedge clk_25MHz) begin
        if(hstate == `SyncState) hsync <= 1'b0;
        else hsync <= 1'b1;
        if(vstate == `SyncState) vsync <= 1'b0;
        else vsync <= 1'b1;
    end

    always @(posedge clk_25MHz or negedge reset) begin
        if(!reset) begin
            red <= 4'h0;
            green <= 4'h0;
            blue <= 4'h0;
        end
        else begin
            if(hstate == `DisplayState && vstate == `DisplayState) begin
                
                // TODO : change to draw characters and ghosts
                if(((char_x + 15) >= x && x >= (char_x - 15)) && ((char_y + 15) >= y && y >= (char_y - 15))) begin
                    // set to yellow
                    red <= 4'hf;
                    green <= 4'hf;
                    blue <= 4'h0;
                end
                else begin
                    // TODO : change to draw tiles
                    red <= 4'h0;
                    green <= 4'h0;
                    blue <= 4'hf;
                end
            end
            else begin
                red <= 4'h0;
                green <= 4'h0;
                blue <= 4'h0;
            end
            prev_x <= char_x;
            prev_y <= char_y;
        end
    end
endmodule



module FrequencyDivider_25MHz (
    input clk,
    output reg div_clock
);

    always @(posedge clk) begin
        div_clock <= ~div_clock;
    end
endmodule



    