`defeine dir_up 2'b00
`defeine dir_down 2'b01
`defeine dir_left 2'b10
`defeine dir_right 2'b11

module Control #(speed = 5)
(
    input clk,
    input w, input a, input s, input d,
    reg [31:0] tilemap_walls,
    reg [31:0] tilemap_dots,
    reg [31:0] player_x,
    reg [31:0] player_y,
    reg [31:0] score
);
    reg [1:0] dir;
    reg [31:0] next_x;
    reg [31:0] next_y;
    reg [31:0] next_tile_idx;

    always @ (posedge clk) begin
        decide_next_pos();
        validate_next_pos();
        next_tile_idx = get_tile_idx(next_x, next_y);
        if (tilemap_dots[next_tile_idx]) begin
            tilemap_dots[next_tile_idx] <= 0;
            score <= score + 1;
        end
    end
    
endmodule