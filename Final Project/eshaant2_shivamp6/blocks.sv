module questionBlock(input Reset, frame_clk,
							 input [11:0] ScrollX,
							 input [11:0] QB_X_Start, QB_Y_Start,
							 output [11:0] QB_X, QB_Y, QB_S);

	logic [11:0] QB_Size = 32;

	assign QB_X = QB_X_Start - ScrollX;
	assign QB_Y = QB_Y_Start;
	assign QB_S = QB_Size;

endmodule

module brickBlock(input Reset, frame_clk,
							 input [11:0] ScrollX,
							 input [11:0] BB_X_Start, BB_Y_Start,
							 output [11:0] BB_X, BB_Y, BB_S);

	logic [11:0] BB_Size = 32;

	assign BB_X = BB_X_Start - ScrollX;
	assign BB_Y = BB_Y_Start;
	assign BB_S = BB_Size;

endmodule

module stairBlock(input Reset, frame_clk,
							 input [11:0] ScrollX,
							 input [11:0] SB_X_Start, SB_Y_Start,
							 output [11:0] SB_X, SB_Y, SB_S);

	logic [11:0] SB_Size = 32;

	assign SB_X = SB_X_Start - ScrollX;
	assign SB_Y = SB_Y_Start;
	assign SB_S = SB_Size;

endmodule

module pipeBlock(input Reset, frame_clk,
					  input [11:0] ScrollX,
					  input [11:0] PB_X_Start, PB_Y_Start,
					  output [11:0] PB_X, PB_Y, PB_S);
					  
	 logic [11:0] PB_Size = 64;
	 
	 assign PB_X = PB_X_Start - ScrollX;
	 assign PB_Y = PB_Y_Start;
	 assign PB_S = PB_Size;

endmodule

module coinBlock( 	 input [11:0] ScrollX,
							 input [11:0] CB_X_Start, CB_Y_Start,
							 output [11:0] CB_X, CB_Y, CB_S);
							 
	logic [11:0] CB_Size = 32;

	assign CB_X = CB_X_Start - ScrollX;
	assign CB_Y = CB_Y_Start;
	assign CB_S = CB_Size;
endmodule



//module one_life(input [11:0] ScrollX,
//					 input [11:0] H1_X_Start, H1_Y_Start,
//					 output [11:0] H1_X, H1_Y, H1_S);
//					 
//					 
//							 
//endmodule
//
//module two_life(input [11:0] ScrollX,
//					 input [11:0] H2_X_Start, H2_Y_Start,
//					 output [11:0] H2_X, H2_Y, H2_S);
//							 
//endmodule
//
//module three_life(input [11:0] ScrollX,
//					 input [11:0] H3_X_Start, H3_Y_Start,
//					 output [11:0] H3_X, H3_Y, H3_S);
//							 
//endmodule
