`include "define.v"

module MatrixDisplay
(
	input [1:0] dir,
	input clk,
    input clk_switch,
	output reg[7:0] dot_row_dir,
	output reg[7:0] dot_col_dir,
	output reg[7:0] dot_col_char
);
wire [7:0] row [8:0];
reg [5:0] cnt;
reg [3:0] in;
assign row[0] = 8'b01111111;
assign row[1] = 8'b10111111;
assign row[2] = 8'b11011111;
assign row[3] = 8'b11101111;
assign row[4] = 8'b11110111;
assign row[5] = 8'b11111011;
assign row[6] = 8'b11111101;
assign row[7] = 8'b11111110;
wire [7:0] dir_col [3:0][8:0]; // dir -> eight_col
wire [7:0] Pac_col [3:0][8:0]; // dir -> eight_col
wire [7:0] Pac_col_Mouthclose;
reg PacState;
// w
assign dir_col[0][0] = 8'b00000000;
assign dir_col[0][1] = 8'b00000000;
assign dir_col[0][2] = 8'b10000001;
assign dir_col[0][3] = 8'b10011001;
assign dir_col[0][4] = 8'b10100101;
assign dir_col[0][5] = 8'b01000010;
assign dir_col[0][6] = 8'b00000000;
assign dir_col[0][7] = 8'b00000000;
// s
assign dir_col[1][0] = 8'b00000000;
assign dir_col[1][1] = 8'b00111100;
assign dir_col[1][2] = 8'b01000010;
assign dir_col[1][3] = 8'b01000000;
assign dir_col[1][4] = 8'b00111100;
assign dir_col[1][5] = 8'b00000010;
assign dir_col[1][6] = 8'b01000010;
assign dir_col[1][7] = 8'b00111100;
// a
assign dir_col[2][0] = 8'b00011000;
assign dir_col[2][1] = 8'b00100100;
assign dir_col[2][2] = 8'b01000010;
assign dir_col[2][3] = 8'b01111110;
assign dir_col[2][4] = 8'b01111110;
assign dir_col[2][5] = 8'b01000010;
assign dir_col[2][6] = 8'b01000010;
assign dir_col[2][7] = 8'b00000000;
// d
assign dir_col[3][0] = 8'b00000000;
assign dir_col[3][1] = 8'b00111000;
assign dir_col[3][2] = 8'b00100100;
assign dir_col[3][3] = 8'b00100010;
assign dir_col[3][4] = 8'b00100010;
assign dir_col[3][5] = 8'b00100100;
assign dir_col[3][6] = 8'b00111000;
assign dir_col[3][7] = 8'b00000000;


// Pac_w
assign Pac_col[0][0] = 8'b01000010;
assign Pac_col[0][1] = 8'b11100111;
assign Pac_col[0][2] = 8'b11100111;
assign Pac_col[0][3] = 8'b11100111;
assign Pac_col[0][4] = 8'b11111111;
assign Pac_col[0][5] = 8'b11111111;
assign Pac_col[0][6] = 8'b01111110;
assign Pac_col[0][7] = 8'b00111100;

// Pac_s
assign Pac_col[1][0] = 8'b00111100;
assign Pac_col[1][1] = 8'b01111110;
assign Pac_col[1][2] = 8'b11111111;
assign Pac_col[1][3] = 8'b11111111;
assign Pac_col[1][4] = 8'b11100111;
assign Pac_col[1][5] = 8'b11100111;
assign Pac_col[1][6] = 8'b11100111;
assign Pac_col[1][7] = 8'b01000010;

// Pac_a

assign Pac_col[2][0] = 8'b01111100;
assign Pac_col[2][1] = 8'b11111110;
assign Pac_col[2][2] = 8'b01111111;
assign Pac_col[2][3] = 8'b00001111;
assign Pac_col[2][4] = 8'b00001111;
assign Pac_col[2][5] = 8'b01111111;
assign Pac_col[2][6] = 8'b11111110;
assign Pac_col[2][7] = 8'b01111100;

// Pac_d

assign Pac_col[3][0] = 8'b00111110;
assign Pac_col[3][1] = 8'b01111111;
assign Pac_col[3][2] = 8'b11111110;
assign Pac_col[3][3] = 8'b11110000;
assign Pac_col[3][4] = 8'b11110000;
assign Pac_col[3][5] = 8'b11111110;
assign Pac_col[3][6] = 8'b01111111;
assign Pac_col[3][7] = 8'b00111110;

assign Pac_col_Mouthclose[0] = 8'b00111100;
assign Pac_col_Mouthclose[1] = 8'b01111110;
assign Pac_col_Mouthclose[2] = 8'b11111111;
assign Pac_col_Mouthclose[3] = 8'b11111111;
assign Pac_col_Mouthclose[4] = 8'b11111111;
assign Pac_col_Mouthclose[5] = 8'b11111111;
assign Pac_col_Mouthclose[6] = 8'b01111110;
assign Pac_col_Mouthclose[7] = 8'b00111100;

always@(posedge clk)
begin
	dot_row_dir <= row[in];
	dot_col_dir <= dir_col[dir][in];
	// if( cnt == 500 ) begin
	// 	PacState <= ~PacState;
	// 	cnt <= 0;
	// end
	// 	cnt <= cnt + 1;
	
	case(clk_switch)
		0:dot_col_char <= Pac_col[dir][in];
		1:dot_col_char <= Pac_col_Mouthclose[in];
	endcase
	
	if( in == 8)
		in <= 0;
	else 
		in <= in + 1;
end
endmodule 
