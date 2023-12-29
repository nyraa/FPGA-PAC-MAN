`include "define.v"

module ReadImages(

    output reg [`tile_size * `tile_size * 4 - 1:0] background_r,
    output reg [`tile_size * `tile_size * 4 - 1:0] background_g,
    output reg [`tile_size * `tile_size * 4 - 1:0] background_b,

    output reg [`tile_size * `tile_size * 4 - 1:0] wall_r,
    output reg [`tile_size * `tile_size * 4 - 1:0] wall_g,
    output reg [`tile_size * `tile_size * 4 - 1:0] wall_b,

    output reg [`tile_size * `tile_size - 1:0] player_mask_f1,
    output reg [`tile_size * `tile_size - 1:0] player_mask_f2,

    output reg [`tile_size * `tile_size - 1:0] ghost_mask_f1,
    output reg [`tile_size * `tile_size - 1:0] ghost_mask_f2,

    output reg [`tile_size * `tile_size - 1:0] dot_mask,
    output reg [`tile_size * `tile_size - 1:0] big_dot_mask
);
    reg [`tile_size - 1:0] temp [0: `tile_size - 1];

    integer i;
    integer j;

    initial begin
        for (i = 0; i < `tile_size * `tile_size; i = i + 1) begin
            background_r[i * 4 +: 4] = 4'h13;
            background_g[i * 4 +: 4] = 4'h4;
            background_b[i * 4 +: 4] = 4'h0;
            wall_r[i * 4 +: 4] = 4'h0;
            wall_g[i * 4 +: 4] = 4'h0;
            wall_b[i * 4 +: 4] = 4'hf;
        end
        $readmemb("./images/dot.txt", temp);
        for (i = 0; i < `tile_size; i = i + 1) begin
            for (j = 0; j < `tile_size; j = j + 1) begin
                dot_mask[i * `tile_size + j] = temp[i][j];
            end
        end
        $readmemb("./images/big_dot.txt", temp);
        for (i = 0; i < `tile_size; i = i + 1) begin
            for (j = 0; j < `tile_size; j = j + 1) begin
                big_dot_mask[i * `tile_size + j] = temp[i][j];
            end
        end
        
        $readmemb("./images/pacman_1.txt", temp);
        for (i = 0; i < `tile_size; i = i + 1) begin
            for (j = 0; j < `tile_size; j = j + 1) begin
                player_mask_f1[i * `tile_size + j] = temp[i][j];
            end
        end
        $readmemb("./images/pacman_2.txt", temp);
        for (i = 0; i < `tile_size; i = i + 1) begin
            for (j = 0; j < `tile_size; j = j + 1) begin
                player_mask_f2[i * `tile_size + j] = temp[i][j];
            end
        end

        $readmemb("./images/ghost_1.txt", temp);
        for(i = 0; i < `tile_size; i = i + 1) begin
            for(j = 0; j < `tile_size; j = j + 1) begin
                ghost_mask_f1[i * `tile_size + j] = temp[i][j];
            end
        end

        $readmemb("./images/ghost_2.txt", temp);
        for(i = 0; i < `tile_size; i = i + 1) begin
            for(j = 0; j < `tile_size; j = j + 1) begin
                ghost_mask_f2[i * `tile_size + j] = temp[i][j];
            end
        end
    end

    always @(*) begin
        background_r <= background_r;
        background_g <= background_g;
        background_b <= background_b;
        wall_r <= wall_r;
        wall_g <= wall_g;
        wall_b <= wall_b;
        player_mask_f1 <= player_mask_f1;
        player_mask_f2 <= player_mask_f2;
        ghost_mask_f1 <= ghost_mask_f1;
        ghost_mask_f2 <= ghost_mask_f2;
        dot_mask <= dot_mask;
        big_dot_mask <= big_dot_mask;
    end


endmodule

    