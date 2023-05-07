//==========================================================================
//MARIO AND GOOMBA COLLISION LOGIC
//==========================================================================

module marioGoombaCollision(input frame_clk,
									 input [11:0] MarioX, MarioY, MarioS,
									 input [11:0] GoombaX, GoombaY, GoombaS,
									 output MarioFlag, GoombaFlag);
									 

									 
logic MARIO_FLAG;
logic GOOMBA_FLAG;			 
									 
always_ff @ (posedge frame_clk) begin

	if((((MarioY >= GoombaY) && (MarioY <= (GoombaY + GoombaS))) || (((MarioY + MarioS) >= GoombaY ) && ((MarioY + MarioS) <= (GoombaY + GoombaS)))) &&
	 (((MarioX >= GoombaX) && (MarioX <= (GoombaX + GoombaS))) || (((MarioX + MarioS) >= GoombaX ) && ((MarioX + MarioS) <= (GoombaX + GoombaS))))) begin
		
			MARIO_FLAG <= 1'b1;		
			GOOMBA_FLAG <= 1'b1;
	end
	else begin
		MARIO_FLAG <= 1'b0;
		GOOMBA_FLAG <= 1'b0;
	end	
end

assign MarioFlag = MARIO_FLAG;
assign GoombaFlag = GOOMBA_FLAG;

endmodule
//==============================================================================================
//MARIO BRICK COLLISIONS
//==============================================================================================


module marioPipeCollision(input frame_clk, Clk,
									 input [11:0] MarioX, MarioY, MarioS,
									 input [11:0] PipeX, PipeY, PipeS,
									 output PIPE_FLAGLEFT,
									 output PIPE_FLAGRIGHT,
									 output PIPE_FLAGTOP);
									 

									 
logic pipeFlagLeft;
logic pipeFlagRight;
logic pipeFlagTop; 
									 
always_comb begin
	
	pipeFlagLeft = 1'b0;
	pipeFlagRight = 1'b0;
	pipeFlagTop = 1'b0;
	
 if((((MarioY >= PipeY) && (PipeY <= (MarioY + MarioS))) || (((MarioY + MarioS) >= PipeY ) && ((MarioY + MarioS) <= (PipeY + PipeS))))
	&& (((MarioX >= PipeX) && (MarioX <= (PipeX + PipeS))) || (((MarioX + MarioS) >= PipeX ) && ((MarioX + MarioS) <= (PipeX + PipeS)))))
	begin 

		if((MarioX >= PipeX) && (MarioX <= PipeX + PipeS) && (MarioY >= PipeY)) begin
			pipeFlagLeft = 1'b1;
			pipeFlagRight = 1'b0;
		end
		
		else if((MarioX + MarioS >= PipeX) && (MarioX + MarioS <= (PipeX + PipeS)) && (MarioY >= PipeY)) begin
			pipeFlagLeft = 1'b0;
			pipeFlagRight = 1'b1;
		end
		
		else if((((MarioY + MarioS) >= PipeY) && ((MarioY + MarioS) <= (PipeY + PipeS))) && 
		(((MarioX + MarioS >= PipeX) && (MarioX + MarioS <= (PipeX + PipeS))) || ((MarioX >= PipeX) && (MarioX <= PipeX + PipeS)))) begin
			pipeFlagTop = 1'b1;
		end
	end
end


assign PIPE_FLAGLEFT = pipeFlagLeft;
assign PIPE_FLAGRIGHT = pipeFlagRight;
assign PIPE_FLAGTOP = pipeFlagTop;

endmodule
//===================================================================================
//MARIO BRICK COLLISIONS
//===================================================================================
module Mario5BricksCollision(input [11:0] MarioX, MarioY, MarioS,
									input [11:0] BlockX, BlockY, BlockS,
									input [11:0] VelocityIn,
									output BRICK_FLAGLEFT,
									output BRICK_FLAGRIGHT,
									output BRICK_FLAGTOP
									//output BRICK_FLAGBOTTOM
									);
									
logic brickFlagLeft;
logic brickFlagRight;
logic brickFlagTop;
//logic brickFlagBottom;

always_comb begin

	brickFlagLeft = 1'b0;
	brickFlagRight = 1'b0;
	brickFlagTop = 1'b0;
	
	if  (((MarioY + MarioS >= BlockY) && (MarioY + MarioS <= BlockY + 4)) &&

		 (((MarioX >= BlockX + 2) && (MarioX <= (BlockX + BlockS + (32*4)))) ||
		 
		 ((MarioX + MarioS >= BlockX) && (MarioX + MarioS <= (BlockX + BlockS + (32*4)))))) begin
		 
		 brickFlagTop = 1'b1;
		 brickFlagLeft = 1'b0;
		 brickFlagRight = 1'b0;
		
	end
	//============================================================================
	//MARIO COLLISION LEFT
	else if	 (((MarioX + MarioS >= BlockX) && (MarioX + MarioS <= BlockX + BlockS)) &&

		 (((MarioY >= BlockY) && (MarioY <= BlockY + BlockS))  ||
		 
		 ((MarioY + MarioS >= BlockY) && (MarioY + MarioS <= BlockY + BlockS)))) begin
		 
		 brickFlagRight = 1'b1;
	
	end
	//============================================================================
	//MARIO COLLISION RIGHT
	else if	 (((MarioX >= BlockX) && (MarioX <= (BlockX + BlockS + (32*4)) &&
		 
		 (((MarioY >= BlockY) && (MarioY <= BlockY + BlockS)) ||
		 
		 ((MarioY + MarioS >= BlockY) && (MarioY + MarioS <= BlockY + BlockS)))))) begin
		 
		 brickFlagLeft = 1'b1;
	end

	 
end
	
		assign BRICK_FLAGTOP = brickFlagTop;
		//assign BRICK_FLAGBOTTOM = brickFlagBottom;
		assign BRICK_FLAGRIGHT = brickFlagRight;
		assign BRICK_FLAGLEFT = brickFlagLeft;
		
endmodule
	  
//=============================================================================
//2 BLOCK GROUP STATES
//=============================================================================
	  
module Mario2BricksCollision(input [11:0] MarioX, MarioY, MarioS,
									input [11:0] BlockX, BlockY, BlockS,
									input [11:0] VelocityIn,
									output BRICK2_FLAGLEFT,
									output BRICK2_FLAGRIGHT,
									output BRICK2_FLAGTOP
									//output BRICK_FLAGBOTTOM
									);
									
logic brickFlagLeft;
logic brickFlagRight;
logic brickFlagTop;
//logic brickFlagBottom;


always_comb begin

	brickFlagLeft = 1'b0;
	brickFlagRight = 1'b0;
	brickFlagTop = 1'b0;
	
	if  (((MarioY + MarioS >= BlockY) && (MarioY + MarioS <= BlockY + 4)) &&

		 (((MarioX >= BlockX + 2) && (MarioX <= (BlockX + BlockS + 32))) ||
		 
		 ((MarioX + MarioS >= BlockX) && (MarioX + MarioS <= (BlockX + BlockS + 32))))) begin
		 
		 brickFlagTop = 1'b1;
		 brickFlagLeft = 1'b0;
		 brickFlagRight = 1'b0;
		
	end
	//============================================================================
	//MARIO COLLISION LEFT
	else if	 (((MarioX + MarioS >= BlockX) && (MarioX + MarioS <= BlockX + BlockS)) &&

		 (((MarioY >= BlockY) && (MarioY <= BlockY + BlockS))  ||
		 
		 ((MarioY + MarioS >= BlockY) && (MarioY + MarioS <= BlockY + BlockS)))) begin
		 
		 brickFlagRight = 1'b1;
	
	end
	//============================================================================
	//MARIO COLLISION RIGHT
	else if	 (((MarioX >= BlockX) && (MarioX <= (BlockX + BlockS + 32) &&
		 
		 (((MarioY >= BlockY) && (MarioY <= BlockY + BlockS)) ||
		 
		 ((MarioY + MarioS >= BlockY) && (MarioY + MarioS <= BlockY + BlockS)))))) begin
		 
		 brickFlagLeft = 1'b1;
	end

	 
end
	
		assign BRICK2_FLAGTOP = brickFlagTop;
		//assign BRICK_FLAGBOTTOM = brickFlagBottom;
		assign BRICK2_FLAGRIGHT = brickFlagRight;
		assign BRICK2_FLAGLEFT = brickFlagLeft;
		
endmodule

//=====================================================================
//SINGLE BRICK COLLISION
//=====================================================================

module Mario1BricksCollision(input [11:0] MarioX, MarioY, MarioS,
									input [11:0] BlockX, BlockY, BlockS,
									input [11:0] VelocityIn,
									output BRICK_1_FLAGLEFT,
									output BRICK_1_FLAGRIGHT,
									output BRICK_1_FLAGTOP);
									
logic brickFlagLeft;
logic brickFlagRight;
logic brickFlagTop;


always_comb begin

	brickFlagLeft = 1'b0;
	brickFlagRight = 1'b0;
	brickFlagTop = 1'b0;

	
 if  (((MarioY + MarioS >= BlockY) && (MarioY + MarioS <= BlockY + 4)) &&

		 (((MarioX >= BlockX + 2) && (MarioX <= (BlockX + BlockS))) ||
		 
		 ((MarioX + MarioS >= BlockX) && (MarioX + MarioS <= (BlockX + BlockS))))) begin
		 
		 brickFlagTop = 1'b1;
		 brickFlagLeft = 1'b0;
		 brickFlagRight = 1'b0;
		
	end
	//============================================================================
	//MARIO COLLISION LEFT
	else if	 (((MarioX + MarioS >= BlockX) && (MarioX + MarioS <= BlockX + BlockS)) &&

		 (((MarioY >= BlockY) && (MarioY <= BlockY + BlockS))  ||
		 
		 ((MarioY + MarioS >= BlockY) && (MarioY + MarioS <= BlockY + BlockS)))) begin
		 
		 brickFlagRight = 1'b1;
	
	end
	//============================================================================
	//MARIO COLLISION RIGHT
	else if	 (((MarioX >= BlockX) && (MarioX <= (BlockX + BlockS) &&
		 
		 (((MarioY >= BlockY) && (MarioY <= BlockY + BlockS)) ||
		 
		 ((MarioY + MarioS >= BlockY) && (MarioY + MarioS <= BlockY + BlockS)))))) begin
		 
		 brickFlagLeft = 1'b1;
	end

	 
end
	
		assign BRICK_1_FLAGTOP = brickFlagTop;
		assign BRICK_1_FLAGRIGHT = brickFlagRight;
		assign BRICK_1_FLAGLEFT = brickFlagLeft;
		
endmodule

//=====================================================================================================================
//MARIO MYSTERY BOX COLLISIONS
//=====================================================================================================================	 
module marioMysteryCollision(input [11:0] MarioX, MarioY, MarioS,
									  input [11:0] QBlockX, QBlockY, QBlockS,
									  output collision);

 logic COLLISIONFLAG;
 
	
		always_comb begin
		 COLLISIONFLAG = 1'b0;
		 
		 if  (((MarioY + MarioS >= QBlockY) && (MarioY + MarioS <= QBlockY + 4)) &&

			 (((MarioX >= QBlockX + 2) && (MarioX <= (QBlockX + QBlockS))) ||
			 
			 ((MarioX + MarioS >= QBlockX) && (MarioX + MarioS <= (QBlockX + QBlockS))))) begin
			 
			COLLISIONFLAG = 1'b1;
			
		end

		else if	 (((MarioX + MarioS >= QBlockX) && (MarioX + MarioS <= QBlockX + QBlockS)) &&

			 (((MarioY >= QBlockY) && (MarioY <= QBlockY + QBlockS))  ||
			 
			 ((MarioY + MarioS >= QBlockY) && (MarioY + MarioS <= QBlockY + QBlockS)))) begin
			 
			 COLLISIONFLAG = 1'b1;
		
		end

		else if	 (((MarioX >= QBlockX) && (MarioX <= (QBlockX + QBlockS) &&
			 
			 (((MarioY >= QBlockY) && (MarioY <= QBlockY + QBlockS)) ||
			 
			 ((MarioY + MarioS >= QBlockY) && (MarioY + MarioS <= QBlockY + QBlockS)))))) begin
			 
			 COLLISIONFLAG = 1'b1;
		end
	end
	
	assign collision = COLLISIONFLAG;
			
endmodule

module marioCoinCollision(input [11:0] MarioX, MarioY, MarioS,
									  input [11:0] CBlockX, CBlockY, CBlockS,
									  output collision);
									  
logic COINCOLLISION;

always_comb begin
	COINCOLLISION = 1'b0;
	
	if((((MarioY >= CBlockY) && (MarioY <= (CBlockY + CBlockS))) || (((MarioY + MarioS) >= CBlockY ) && ((MarioY + MarioS) <= (CBlockY + CBlockS)))) &&
	 (((MarioX >= CBlockX) && (MarioX <= (CBlockX + CBlockS))) || (((MarioX + MarioS) >= CBlockX ) && ((MarioX + MarioS) <= (CBlockX + CBlockS)))))
		COINCOLLISION = 1'b1;
end

assign collision = COINCOLLISION;
		
endmodule



