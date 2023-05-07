
//=============================================================
//BACKGROUND
//=============================================================
module mariomap(
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] ScrollX,
	input logic vga_clk, blank,
	output logic marioBoundsFlag,
	output logic marioBrickFlag,
	output logic [3:0] bg1_red, bg1_green, bg1_blue
);

logic [18:0] rom_address;
logic [2:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic MARIOBOUNDS; //when 1'b0 Mario is stuck to middle of the screen when 1'b1 mario can move to edge

logic isCollisionPink;


always_comb begin	

	if(ScrollX >= 2559 - 640) begin
		rom_address = ((((DrawX + 2559 - 640) * 320) / 640) + ((DrawY * 240) / 480) * 1280);
		MARIOBOUNDS <= 1'b1;
	end
	else begin
		rom_address = (((DrawX + ScrollX) * 320) / 640) + (((DrawY * 240) / 480) * 1280);
		MARIOBOUNDS <= 1'b0;
	end
	
end
	
mariomap_rom mainLevel_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

mariomap_palette mainLevel_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);


assign bg1_red = palette_red;
assign bg1_green = palette_green;
assign bg1_blue = palette_blue;

always_comb begin
if(palette_red == 4'hF && palette_green == 4'h0 && palette_blue == 4'hF)
	isCollisionPink = 1'b1;
else
	isCollisionPink = 1'b0;
end
	
assign marioBoundsFlag = MARIOBOUNDS;
assign marioBrickFlag = isCollisionPink;

endmodule

//=============================================================
//GOOMBA WALK 1
//=============================================================
module goomba_sprite (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] GoombaX, GoombaY,
	input logic vga_clk, blank,
	output logic [3:0] goomba_red, goomba_green, goomba_blue
);

logic [9:0] rom_address;
logic [3:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - GoombaX) + ((DrawY - GoombaY) * 32);

goomba_rom goomba_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

goomba_palette goomba_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign goomba_red = palette_red;
assign goomba_green = palette_green;
assign goomba_blue = palette_blue;
endmodule

//===========================================================================
//GOOMBA WALK 2
//===========================================================================
module goomba2 (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] GoombaX, GoombaY,
	input logic vga_clk, blank,
	output logic [3:0] goomba2_red, goomba2_green, goomba2_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - GoombaX) + ((DrawY - GoombaY) * 32);

goomba2_rom goomba2_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

goomba2_palette goomba2_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign goomba2_red = palette_red;
assign goomba2_green = palette_green;
assign goomba2_blue = palette_blue;

endmodule

//==============================================================================
//IDLE MARIO 1
//==============================================================================
module idle_mario_1 (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] MarioX, MarioY,
	input logic vga_clk, blank,
	output logic [3:0] idle_mario_1_red, idle_mario_1_green, idle_mario_1_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - MarioX) + ((DrawY - MarioY) * 32);

mario_rom mario_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

mario_palette mario_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign idle_mario_1_red = palette_red;
assign idle_mario_1_green = palette_green;
assign idle_mario_1_blue = palette_blue;

endmodule

//================================================================================
//IDLE MARIO LEFT
//================================================================================
module marioleft (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] MarioX, MarioY,
	input logic vga_clk, blank,
	output logic [3:0] marioleft_red, marioleft_green, marioleft_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = ((DrawX - MarioX) + ((DrawY - MarioY) * 32));


marioleft_rom marioleft_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

marioleft_palette marioleft_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign marioleft_red = palette_red;
assign marioleft_green = palette_green;
assign marioleft_blue = palette_blue;

endmodule

//==========================================================================
//Mario Dead
//==========================================================================
module mariodead (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] MarioX, MarioY,
	input logic vga_clk, blank,
	output logic [3:0] mariodead_red, mariodead_green, mariodead_blue
);

logic [9:0] rom_address;
logic [2:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - MarioX) + ((DrawY - MarioY) * 32);


mariodead_rom mariodead_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

mariodead_palette mariodead_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign mariodead_red = palette_red;
assign mariodead_green = palette_green;
assign mariodead_blue = palette_blue;

endmodule

//===========================================================
//MARIO LEFT FOOT FACING LEFT
//===========================================================
module marioleftfoot_LEFT (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] MarioX, MarioY,
	input logic vga_clk, blank,
	output logic [3:0] LF_LEFT_red, LF_LEFT_green, LF_LEFT_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - MarioX) + ((DrawY - MarioY) * 32);

marioleftfoot_LEFT_rom marioleftfoot_LEFT_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

marioleftfoot_LEFT_palette marioleftfoot_LEFT_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign LF_LEFT_red = palette_red;
assign LF_LEFT_green = palette_green;
assign LF_LEFT_blue = palette_blue;

endmodule

//===========================================================
//MARIO LEFT FOOT FACING RIGHT
//===========================================================
module marioleftfoot_RIGHT (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] MarioX, MarioY,
	input logic vga_clk, blank,
	output logic [3:0] LF_RIGHT_red, LF_RIGHT_green, LF_RIGHT_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - MarioX) + ((DrawY - MarioY) * 32);

marioleftfoot_RIGHT_rom marioleftfoot_RIGHT_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

marioleftfoot_RIGHT_palette marioleftfoot_RIGHT_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign LF_RIGHT_red = palette_red;
assign LF_RIGHT_green = palette_green;
assign LF_RIGHT_blue = palette_blue;

endmodule

//===========================================================
//MARIO RIGHT FOOT FACING LEFT
//===========================================================
module mariorightfoot_LEFT (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] MarioX, MarioY,
	input logic vga_clk, blank,
	output logic [3:0] RF_LEFT_red, RF_LEFT_green, RF_LEFT_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - MarioX) + ((DrawY - MarioY) * 32);

mariorightfoot_LEFT_rom mariorightfoot_LEFT_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

mariorightfoot_LEFT_palette mariorightfoot_LEFT_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign RF_LEFT_red = palette_red;
assign RF_LEFT_green = palette_green;
assign RF_LEFT_blue = palette_blue;

endmodule

//===========================================================
//MARIO RIGHT FOOT FACING RIGHT
//===========================================================
module mariorightfoot_RIGHT (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] MarioX, MarioY,
	input logic vga_clk, blank,
	output logic [3:0] RF_RIGHT_red, RF_RIGHT_green, RF_RIGHT_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - MarioX) + ((DrawY - MarioY) * 32);

mariorightfoot_RIGHT_rom mariorightfoot_RIGHT_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

mariorightfoot_RIGHT_palette mariorightfoot_RIGHT_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign RF_RIGHT_red = palette_red;
assign RF_RIGHT_green = palette_green;
assign RF_RIGHT_blue = palette_blue;

endmodule

//===========================================================
//MARIO SWITCH FACING LEFT
//===========================================================
module marioswitch_LEFT (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] MarioX, MarioY,
	input logic vga_clk, blank,
	output logic [3:0] SW_LEFT_red, SW_LEFT_green, SW_LEFT_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - MarioX) + ((DrawY - MarioY) * 32);

marioswitch_LEFT_rom marioswitch_LEFT_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

marioswitch_LEFT_palette marioswitch_LEFT_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign SW_LEFT_red = palette_red;
assign SW_LEFT_green = palette_green;
assign SW_LEFT_blue = palette_blue;

endmodule

//===========================================================
//MARIO SWITCH FACING RIGHT
//===========================================================
module marioswitch_RIGHT (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] MarioX, MarioY,
	input logic vga_clk, blank,
	output logic [3:0] SW_RIGHT_red, SW_RIGHT_green, SW_RIGHT_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - MarioX) + ((DrawY - MarioY) * 32);

marioswitch_RIGHT_rom marioswitch_RIGHT_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

marioswitch_RIGHT_palette marioswitch_RIGHT_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign SW_RIGHT_red = palette_red;
assign SW_RIGHT_green = palette_green;
assign SW_RIGHT_blue = palette_blue;

endmodule

//==================================================================
//QUESTION BLOCKS
//==================================================================
module questionBlockSprite(
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] QBX, QBY,
	input logic vga_clk, blank,
	output logic [3:0] qb_red, qb_green, qb_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - QBX) + ((DrawY - QBY) * 32);

questionBlock_rom questionBlock_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

questionBlock_palette questionBlock_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign qb_red = palette_red;
assign qb_green = palette_green;
assign qb_blue = palette_blue;

endmodule

//========================================================================================
//QUESTION BLOCK ANIMATION 2
//========================================================================================
module qb2(
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] QB2X, QB2Y,
	input logic vga_clk, blank,
	output logic [3:0] qb2_red, qb2_green, qb2_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - QB2X) + ((DrawY - QB2Y) * 32);

qb2_rom qb2_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

qb2_palette qb2_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

	assign qb2_red = palette_red;
	assign qb2_green = palette_green;
	assign qb2_blue = palette_blue;

endmodule
//========================================================================================
//QUESTION BLOCK ANIMATION 3
//========================================================================================
module qb3 (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] QB3X, QB3Y,
	input logic vga_clk, blank,
	output logic [3:0] qb3_red, qb3_green, qb3_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - QB3X) + ((DrawY - QB3Y) * 32);


qb3_rom qb3_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

qb3_palette qb3_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

	assign qb3_red = palette_red;
	assign qb3_green = palette_green;
	assign qb3_blue = palette_blue;
	
endmodule
//========================================================================================
//BRICK BLOCKS
//========================================================================================
module brickBlockSprite (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] BBX, BBY,
	input logic vga_clk, blank,
	output logic [3:0] bb_red, bb_green, bb_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - BBX) + ((DrawY - BBY) * 32);

brickBlock_rom brickBlock_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

brickBlock_palette brickBlock_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign bb_red = palette_red;
assign bb_green = palette_green;
assign bb_blue = palette_blue;

endmodule
//====================================================================
//STAIR BLOCKS
//====================================================================
module stairBlockSprite(
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] SBX, SBY,
	input logic vga_clk, blank,
	output logic [3:0] sb_red, sb_green, sb_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - SBX) + ((DrawY - SBY) * 32);

stairBlock_rom stairBlock_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

stairBlock_palette stairBlock_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign sb_red = palette_red;
assign sb_green = palette_green;
assign sb_blue = palette_blue;

endmodule
//================================================================
//PIPE BLOCKS
//================================================================
module pipeBlockSprite(
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] PBX, PBY,
	input logic vga_clk, blank,
	output logic [3:0] pb_red, pb_green, pb_blue
);

logic [11:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - PBX) + ((DrawY - PBY) * 64);

pipe_rom pipe_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

pipe_palette pipe_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign pb_red = palette_red;
assign pb_green = palette_green;
assign pb_blue = palette_blue;

endmodule

//===============================================================
//COIN SPRITES
//===============================================================
module coin (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] COIN_X, COIN_Y,
	input logic vga_clk, blank,
	output logic [3:0] coin_red, coin_green, coin_blue
);

logic [9:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - COIN_X) + ((DrawY - COIN_Y) * 32);


coin_rom coin_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

coin_palette coin_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign coin_red = palette_red;
assign coin_green = palette_green;
assign coin_blue = palette_blue;

endmodule
