`include "define.v"
//
//module PlayerControl #(
////     width = 640, height = 480, tile_size = 20,
//    boundary_x0 = 0, boundary_x1 = 620, boundary_y0 = 0, boundary_y1 = 460,
//    speed = 1
//)
//(
//    input clk,
//    input reset,
//    input w, input a, input s, input d,
//    inout reg [$clog2(`WIDTH) - 1:0] x,
//    inout reg [$clog2(`HEIGHT) - 1:0] y, 
//    inout reg [1:0] player_direction,
//	 input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls,
//	 inout reg [`tile_row_num * `tile_col_num - 1:0] tilemap_dots
//);
//
//	 integer i;
//    integer j;
//	 
//	 initial begin
//		x <=400;
//		y <=400; //test
//		for(i = 0; i < `tile_row_num; i = i + 1) begin
//            for(j = 0; j < `tile_col_num; j = j + 1) begin
//                if(i == `tile_row_num - 2 || j == `tile_col_num - 2) begin
//                    tilemap_dots[i * `tile_col_num + j] <= 1'b1;
//                end
//                else begin
//                    tilemap_dots[i * `tile_col_num + j] <= 1'b0;
//                end
//            end
//        end
//	 end
//	 
//    always @(posedge clk or negedge reset) begin
//        if (!reset) begin
//            x <= 20;
//            y <= 20;
//        end
//        else begin
//            if(!w) begin
//                if((y - 20) <= boundary_y0) y <= boundary_y0;
//                else if((y - 20) >= boundary_y1) y <= y;
//					 else if(tilemap_walls[(`WIDTH / `tile_size)*((y - 20)/`tile_size) + x/`tile_size] == 1) y <= y;
//                else y <= y - speed;
//                x <= x;
//                player_direction <= `dir_up;
//            end
//            else if(!s) begin
//                if((y + 20) >= boundary_y1) y <= boundary_y1;
//                else if((y + 20) <= boundary_y0) y <= y;
//					 else if(tilemap_walls[(`WIDTH / `tile_size)*((y + 20)/`tile_size) + x/`tile_size] == 1) y <= y;
//                else y <= y + speed;
//                x <= x;
//                player_direction <= `dir_down;
//            end
//            else if(!a) begin
//                if((x - 20) <= boundary_x0) x <= boundary_x0;
//                else if((x - 20) >= boundary_x1) x <= x;
//					 else if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - 20)/`tile_size] == 1) x <= x;
//                else x <= x - speed;
//                y <= y;
//                player_direction <= `dir_left;
//            end
//            else if(!d) begin
//                if((x + 20) >= boundary_x1) x <= boundary_x1;
//                else if((x + 20) <= boundary_x0) x <= x;
//					 else if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + 20)/`tile_size] == 1) x <= x;
//                else x <= x + speed;
//                y <= y;
//                player_direction <= `dir_right;
//            end
//				
//				else
//					begin
//					case(player_direction)
//						`dir_up:
//						begin
//							player_direction <= 0;
//							if(y >= speed)begin
//								if(tilemap_walls[(`WIDTH / `tile_size)*((y - 20)/`tile_size) + x/`tile_size] == 0)
//								begin
//									y <= y - speed;
//									if( tilemap_dots[(`WIDTH / `tile_size)*((y - 20)/`tile_size) + x/`tile_size] == 1)
//									begin
//										//score <= score + 1;
//										tilemap_dots[(`WIDTH / `tile_size)*((y - 20)/`tile_size) + x/`tile_size] <= 0;
//									end
//								end
//							 end
//							 else y <= boundary_y0;
//						end
//						`dir_down:
//						begin
//							player_direction <= 1;
//							if(y + speed <= boundary_y1)begin
//								if(tilemap_walls[(`WIDTH / `tile_size)*((y + 20)/`tile_size) + x/`tile_size] == 0)
//								begin
//									y <= y + speed;
//									if( tilemap_dots[(`WIDTH / `tile_size)*((y + 20)/`tile_size) + x/`tile_size] == 1)
//									begin
//										//score <= score + 1;
//										tilemap_dots[(`WIDTH / `tile_size)*((y + 20)/`tile_size) + x/`tile_size] <= 0;
//									end
//								end
//							 end
//							 else y <= boundary_y0;
//						end
//						`dir_left:
//						begin
//							player_direction <= 2;
//							if(x >= speed)begin
//								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - 20)/`tile_size] == 0)
//								begin
//									x <= x - speed;
//									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - 20)/`tile_size] == 1)
//									begin
//										//score <= score + 1;
//										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - 20)/`tile_size] <= 0;
//									end
//								end
//							 end
//							 else x <= boundary_x0;
//						end
//						`dir_right:
//						begin
//							player_direction <= 3;
//							if(x >= speed)begin
//								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + 20)/`tile_size] == 0)begin
//									x <= x + speed;
//									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + 20)/`tile_size] == 1)
//									begin
//										//score <= score + 1;
//										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + 20)/`tile_size] <= 0;
//									end
//								end
//							 end
//							 else x <= boundary_x0;
//						end
//					endcase
//				end
//        end
//    end
//endmodule


module PlayerControl #(
//     width = 640, height = 480, tile_size = 20,
    boundary_x0 = 0, boundary_x1 = 620, boundary_y0 = 0, boundary_y1 = 460,
    speed = 20
)
(
    input clk,
    input reset,
    input w, input a, input s, input d,
    inout reg [$clog2(`WIDTH) - 1:0] x,
    inout reg [$clog2(`HEIGHT) - 1:0] y, 
    inout reg [1:0] player_direction,
	 input [`tile_row_num * `tile_col_num - 1:0] tilemap_walls,
	 inout reg [`tile_row_num * `tile_col_num - 1:0] tilemap_dots
);

	 integer i;
    integer j;
	 reg [5:0] counter;
	 
	 
	 
//	 initial begin
//		tilemap_dots <= 768'b000000000000000000000000000000000111111111111100001111111111111001000001000001000010000010000010010000010000010000100000100000100111111111111111111111111111111001000001001000000000010010000010010000010010000000000100100000100111111100111110011111001111111000000001000000100100000010000000000000010011111111111100100000000000000100100000000001001000000000000001111011111111011110000000000000010010000000000100100000000000000100111111111111001000000000000001001000000000010010000000011111111111111001111111111111100100000100000010010000001000001001111001111111111111111110011110000010010010000000000100100100000000100100100000000001001001000001111111001111100111110011111110010000000000001001000000000000100111111111111111111111111111111000000000000000000000000000000000;
//	 end
	 
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            x <= 20;
            y <= 20;
        end
        else if( counter == 20)
		  begin
				counter <= 0;
            if(!w) begin
                if((y - speed) <= boundary_y0) y <= y;
                else if((y - speed) >= boundary_y1) y <= y;
					 else if(tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1)begin
						case(player_direction)
						`dir_up:
						begin
							if(y >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1)
									begin
										// score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_down:
						begin
							if(y + speed <= boundary_y1)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y + `tile_size)/`tile_size) + x/`tile_size] == 1)
									begin
										// score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_left:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 0)
								begin
									x <= x - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1)
									begin
										// score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
						`dir_right:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 0)begin
									x <= x + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + `tile_size)/`tile_size] == 1)
									begin
										// score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
					endcase
					 end
                else
					 begin
						y <= y - speed;
						if( tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1)
						begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] <= 0;
						end
						player_direction <= `dir_up;
					 end
                x <= x;
            end
            else if(!s) begin
                if((y + speed) >= boundary_y1) y <= y;
                else if((y + speed) <= boundary_y0) y <= y;
					 else if(tilemap_walls[(`WIDTH / `tile_size)*((y + `tile_size)/`tile_size) + x/`tile_size] == 1) begin
						case(player_direction)
						`dir_up:
						begin
							if(y >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_down:
						begin
							if(y + speed <= boundary_y1)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y + `tile_size)/`tile_size) + x/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_left:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 0)
								begin
									x <= x - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
						`dir_right:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 0)begin
									x <= x + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + `tile_size)/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
					endcase
					 end
                else 
					 begin 
						if( tilemap_dots[(`WIDTH / `tile_size)*((y + `tile_size)/`tile_size) + x/`tile_size] == 1)
						begin
								//score <= score + 1;
								tilemap_dots[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] <= 0;
						end
						y <= y + speed;
						player_direction <= `dir_down;
					 end
                x <= x;
            end
            else if(!a) begin
                if((x - speed) <= boundary_x0) x <= x;
                else if((x - speed) >= boundary_x1) x <= x;
					 else if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1)begin
						case(player_direction)
						`dir_up:
						begin
							if(y >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_down:
						begin
							if(y + speed <= boundary_y1)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y + `tile_size)/`tile_size) + x/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_left:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 0)
								begin
									x <= x - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
						`dir_right:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 0)begin
									x <= x + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + `tile_size)/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
					endcase
					 end
                else begin
					 if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1)
						begin
								//score <= score + 1;
								tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] <= 0;
						end
						x <= x - speed;
                  player_direction <= `dir_left;
					end
                y <= y;
            end
            else if(!d) begin
                if((x + speed) >= boundary_x1) x <= x;
                else if((x + speed) <= boundary_x0) x <= x;
					 else if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + `tile_size)/`tile_size] == 1)begin
						case(player_direction)
						`dir_up:
						begin
							if(y >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_down:
						begin
							if(y + speed <= boundary_y1)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y + `tile_size)/`tile_size) + x/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_left:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 0)
								begin
									x <= x - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
						`dir_right:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 0)begin
									x <= x + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + `tile_size)/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
					endcase
					 end
                else 
					 begin
					 if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + `tile_size)/`tile_size] == 1)
					begin
						//score <= score + 1;
						tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] <= 0;
					end
						x <= x + speed;
						player_direction <= `dir_right;
					end 
                y <= y;
            end
				
				else
					begin
					case(player_direction)
						`dir_up:
						begin
							if(y >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y - speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_down:
						begin
							if(y + speed <= boundary_y1)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] == 0)
								begin
									y <= y + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*((y + `tile_size)/`tile_size) + x/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*((y + speed)/`tile_size) + x/`tile_size] <= 0;
									end
								end
							 end
							 else y <= y;
						end
						`dir_left:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 0)
								begin
									x <= x - speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x - speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
						`dir_right:
						begin
							if(x >= speed)begin
								if(tilemap_walls[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] == 0)begin
									x <= x + speed;
									if( tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + `tile_size)/`tile_size] == 1)
									begin
										//score <= score + 1;
										tilemap_dots[(`WIDTH / `tile_size)*(y/`tile_size) + (x + speed)/`tile_size] <= 0;
									end
								end
							 end
							 else x <= x;
						end
					endcase
				end
        end
		  else 
		  begin
				counter <= counter + 1;
		  end
    end
endmodule

