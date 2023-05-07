//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        Reset, frame_clk,
							  input        [11:0] BallX, BallY, Ball_size,
							  input        [9:0] DrawX, DrawY,
							  input        MarioFlag,
							  input			[11:0] GoombaX, GoombaY, Goomba_size,
							  
							  input			[11:0] SB1X, SB1Y, SB1_size,
							  
							  input			[11:0] QB1X, QB1Y, QB1_size,
							  input			[11:0] QB4X, QB4Y, QB4_size,
							  input			[11:0] QB5X, QB5Y, QB5_size,
							  input			[11:0] QB6X, QB6Y, QB6_size,
							  input			[11:0] QB7X, QB7Y, QB7_size,
							  input			[11:0] QB8X, QB8Y, QB8_size,
							  input			[11:0] QB9X, QB9Y, QB9_size,
							  
							  input			[11:0] BB1X, BB1Y, BB1_size,
							  input			[11:0] BB2X, BB2Y, BB2_size,
							  input			[11:0] BB3X, BB3Y, BB3_size,
							  input			[11:0] BB4X, BB4Y, BB4_size,
							  input			[11:0] BB5X, BB5Y, BB5_size,
							  input			[11:0] BB6X, BB6Y, BB6_size,
							  input			[11:0] BB7X, BB7Y, BB7_size,
							  input			[11:0] BB8X, BB8Y, BB8_size,
							  input			[11:0] BB9X, BB9Y, BB9_size,
							  input			[11:0] BB10X, BB10Y, BB10_size,
							  
							  input			[11:0] CB1X, CB1Y, CB1_size,
							  input			[11:0] CB2X, CB2Y, CB2_size,
							  input			[11:0] CB3X, CB3Y, CB3_size,
							  input			[11:0] CB4X, CB4Y, CB4_size,
							  input			[11:0] CB5X, CB5Y, CB5_size,
							  input			[11:0] CB6X, CB6Y, CB6_size,
							  input			[11:0] CB7X, CB7Y, CB7_size,
							  
							  input			[11:0] PBX, PBY, PB_size,
							  input			[11:0] PB2X, PB2Y, PB2_size,
							  
							  input			[3:0] marioLevel, MARIO_FSM,
							  input 			[11:0] ScrollX,
							  input logic [1:0] healthbar,
							  input		  goombaOverflowFlag,
							  input 		  marioDirection, //mario direction flag,
							  input logic vga_clk, blank, goombaAnimationFlag, gameovertemp,
							  output logic marioBoundsFlag,
							  
							  output logic COINCOLLISION,
							  output logic COINCOLLISION2,
							  output logic COINCOLLISION3,
							  output logic COINCOLLISION4,
							  output logic COINCOLLISION5,
							  output logic COINCOLLISION6,
							  output logic COINCOLLISION7,
							  
							  output logic SCORECOLLISION,
							  output logic SCORECOLLISION2,							  
							  output logic SCORECOLLISION3,
							  output logic SCORECOLLISION4,
							  output logic SCORECOLLISION5,
							  output logic SCORECOLLISION6,
							  output logic SCORECOLLISION7,
							  
							  output logic [3:0] MARIOSCORE,
							  
							  output logic marioBrickFlag,
                       output logic [7:0]  Red, Green, Blue);
    
    logic ball_on;
	 logic goomba_on;
	 
	 logic QB1_on;
	 logic QB4_on;
	 logic QB5_on;
	 logic QB6_on;
	 logic QB7_on;
	 logic QB8_on;
	 logic QB9_on;

	 logic BB1_on;
	 logic BB2_on;
	 logic BB3_on;
	 logic BB4_on;
	 logic BB5_on;
	 logic BB6_on;
	 logic BB7_on;
	 logic BB8_on;
	 logic BB9_on;
	 logic BB10_on;
	 
	 logic SB1_on;
	 
	 logic PB_on;
	 logic PB2_on;
	 
	 logic CB1_on;
	 logic CB2_on;
	 logic CB3_on;
	 logic CB4_on;
	 logic CB5_on;
	 logic CB6_on;
	 logic CB7_on;
	 
	 logic heart3_on;
	 logic heart2_on;
	 logic heart1_on;
	 
	 logic [11:0] HeartDistX, HeartDistY;
	 assign HeartDistX = DrawX - LIFE3X;
	 assign HeartDistY = DrawY - LIFE3Y;
	 
	 always_comb begin
		if((HeartDistX <= 93) && (HeartDistY <= 32))begin
			heart3_on <= 1'b1;
			heart2_on <= 1'b1;
			heart1_on <= 1'b1;
			end
		else begin
			heart3_on <= 1'b0;
			heart2_on <= 1'b0;
			heart1_on <= 1'b0;
		end
	end
//============================================================	 
	logic[11:0] CB1DistX, CB1DistY, CB1Size;
	assign CB1DistX = DrawX - CB1X;
	assign CB1DistY = DrawY - CB1Y;
	assign CB1Size = CB1_size;
	
	always_comb
	begin:CB1_on_proc
		
		if((CB1DistX <= CB1Size) && (CB1DistY <= CB1Size) && holdCOLLISION)
			CB1_on <= 1'b1;
		else
			CB1_on <= 1'b0;
	end
//========================================================
	logic[11:0] CB2DistX, CB2DistY, CB2Size;
	assign CB2DistX = DrawX - CB2X;
	assign CB2DistY = DrawY - CB2Y;
	assign CB2Size = CB2_size;
	
	always_comb
	begin:CB2_on_proc
		
		if((CB2DistX <= CB2Size) && (CB2DistY <= CB2Size) && holdCOLLISION2)
			CB2_on <= 1'b1;
		else
			CB2_on <= 1'b0;
	end	

	logic[11:0] CB3DistX, CB3DistY, CB3Size;
	assign CB3DistX = DrawX - CB3X;
	assign CB3DistY = DrawY - CB3Y;
	assign CB3Size = CB3_size;
	
	always_comb
	begin:CB3_on_proc
		
		if((CB3DistX <= CB3Size) && (CB3DistY <= CB3Size) && holdCOLLISION3)
			CB3_on <= 1'b1;
		else
			CB3_on <= 1'b0;
	end	

	logic[11:0] CB4DistX, CB4DistY, CB4Size;
	assign CB4DistX = DrawX - CB4X;
	assign CB4DistY = DrawY - CB4Y;
	assign CB4Size = CB1_size;
	
	always_comb
	begin:CB4_on_proc
		
		if((CB4DistX <= CB4Size) && (CB4DistY <= CB4Size) && holdCOLLISION4)
			CB4_on <= 1'b1;
		else
			CB4_on <= 1'b0;
	end	

	logic[11:0] CB5DistX, CB5DistY, CB5Size;
	assign CB5DistX = DrawX - CB5X;
	assign CB5DistY = DrawY - CB5Y;
	assign CB5Size = CB5_size;
	
	always_comb
	begin:CB5_on_proc
		
		if((CB5DistX <= CB5Size) && (CB5DistY <= CB5Size) && holdCOLLISION5)
			CB5_on <= 1'b1;
		else
			CB5_on <= 1'b0;
	end	

	logic[11:0] CB6DistX, CB6DistY, CB6Size;
	assign CB6DistX = DrawX - CB6X;
	assign CB6DistY = DrawY - CB6Y;
	assign CB6Size = CB6_size;
	
	always_comb
	begin:CB6_on_proc
		
		if((CB6DistX <= CB6Size) && (CB6DistY <= CB6Size) && holdCOLLISION6)
			CB6_on <= 1'b1;
		else
			CB6_on <= 1'b0;
	end	

	logic[11:0] CB7DistX, CB7DistY, CB7Size;
	assign CB7DistX = DrawX - CB7X;
	assign CB7DistY = DrawY - CB7Y;
	assign CB7Size = CB7_size;
	
	always_comb
	begin:CB7_on_proc
		
		if((CB7DistX <= CB7Size) && (CB7DistY <= CB7Size) && holdCOLLISION7)
			CB7_on <= 1'b1;
		else
			CB7_on <= 1'b0;
	end		

//================================================================



	
    logic [11:0] DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
	 logic[11:0] goombaDistX, goombaDistY, goombaSize;
	 assign goombaDistX = DrawX - GoombaX;
	 assign goombaDistY = DrawY - GoombaY;
	 assign goombaSize = Goomba_size;

//===========================================================
	logic[11:0] SB1DistX, SB1DistY, SB1Size;
	assign SB1DistX = DrawX - SB1X;
	assign SB1DistY = DrawY - SB1Y;
	assign SB1Size = SB1_size;
	
	always_comb
	begin:SB1_on_proc
		
		if((SB1DistX <= SB1Size) && (SB1DistY <= SB1Size))
			SB1_on <= 1'b1;
		else
			SB1_on <= 1'b0;
	end
	
//===========================================================
	 
//============================================================
	logic[11:0] QB1DistX, QB1DistY, QB1Size;
	assign QB1DistX = DrawX - QB1X;
	assign QB1DistY = DrawY - QB1Y;
	assign QB1Size = QB1_size;
	
	always_comb
	begin:QB1_on_proc
		
		if(holdCOLLISION == 1'b0) begin
			if((QB1DistX <= QB1Size) && (QB1DistY <= QB1Size))
				QB1_on <= 1'b1;
			else
				QB1_on <= 1'b0;
		end
		else
			QB1_on <= 1'b0;
	end
	
	logic[11:0] QB4DistX, QB4DistY, QB4Size;
	assign QB4DistX = DrawX - QB4X;
	assign QB4DistY = DrawY - QB4Y;
	assign QB4Size = QB4_size;
	
	always_comb
	begin:QB4_on_proc
		
		if((QB4DistX <= QB4Size) && (QB4DistY <= QB4Size))
			QB4_on <= 1'b1;
		else
			QB4_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] QB5DistX, QB5DistY, QB5Size;
	assign QB5DistX = DrawX - QB5X;
	assign QB5DistY = DrawY - QB5Y;
	assign QB5Size = QB5_size;
	
	always_comb
	begin:QB5_on_proc
		
		if((QB5DistX <= QB5Size) && (QB5DistY <= QB5Size))
			QB5_on <= 1'b1;
		else
			QB5_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] QB6DistX, QB6DistY, QB6Size;
	assign QB6DistX = DrawX - QB6X;
	assign QB6DistY = DrawY - QB6Y;
	assign QB6Size = QB6_size;
	
	always_comb
	begin:QB6_on_proc
		
		if((QB6DistX <= QB6Size) && (QB6DistY <= QB6Size))
			QB6_on <= 1'b1;
		else
			QB6_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] QB7DistX, QB7DistY, QB7Size;
	assign QB7DistX = DrawX - QB7X;
	assign QB7DistY = DrawY - QB7Y;
	assign QB7Size = QB7_size;
	
	always_comb
	begin:QB7_on_proc
		
		if((QB7DistX <= QB7Size) && (QB7DistY <= QB7Size))
			QB7_on <= 1'b1;
		else
			QB7_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] QB8DistX, QB8DistY, QB8Size;
	assign QB8DistX = DrawX - QB8X;
	assign QB8DistY = DrawY - QB8Y;
	assign QB8Size = QB8_size;
	
	always_comb
	begin:QB8_on_proc
		
		if((QB8DistX <= QB8Size) && (QB8DistY <= QB8Size))
			QB8_on <= 1'b1;
		else
			QB8_on <= 1'b0;
	end
	
//-------------------------------------------------------------
	logic[11:0] QB9DistX, QB9DistY, QB9Size;
	assign QB9DistX = DrawX - QB9X;
	assign QB9DistY = DrawY - QB9Y;
	assign QB9Size = QB9_size;
	
	always_comb
	begin:QB9_on_proc
		
		if((QB9DistX <= QB9Size) && (QB9DistY <= QB9Size))
			QB9_on <= 1'b1;
		else
			QB9_on <= 1'b0;
	end
	 
//============================================================

//============================================================
//BRICK BLOCKS
//============================================================
	logic[11:0] BB1DistX, BB1DistY, BB1Size;
	assign BB1DistX = DrawX - BB1X;
	assign BB1DistY = DrawY - BB1Y;
	assign BB1Size = BB1_size;
	
	always_comb
	begin:BB1_on_proc
		
		if((BB1DistX <= BB1Size) && (BB1DistY <= BB1Size))
			BB1_on <= 1'b1;
		else
			BB1_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] BB2DistX, BB2DistY, BB2Size;
	assign BB2DistX = DrawX - BB2X;
	assign BB2DistY = DrawY - BB2Y;
	assign BB2Size = BB2_size;
	
	always_comb
	begin:BB2_on_proc
		
		if((BB2DistX <= BB2Size) && (BB2DistY <= BB2Size))
			BB2_on <= 1'b1;
		else
			BB2_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] BB3DistX, BB3DistY, BB3Size;
	assign BB3DistX = DrawX - BB3X;
	assign BB3DistY = DrawY - BB3Y;
	assign BB3Size = BB3_size;
	
	always_comb
	begin:BB3_on_proc
		
		if((BB3DistX <= BB3Size) && (BB3DistY <= BB3Size))
			BB3_on <= 1'b1;
		else
			BB3_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] BB4DistX, BB4DistY, BB4Size;
	assign BB4DistX = DrawX - BB4X;
	assign BB4DistY = DrawY - BB4Y;
	assign BB4Size = BB4_size;
	
	always_comb
	begin:BB4_on_proc
		
		if((BB4DistX <= BB4Size) && (BB4DistY <= BB4Size))
			BB4_on <= 1'b1;
		else
			BB4_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] BB5DistX, BB5DistY, BB5Size;
	assign BB5DistX = DrawX - BB5X;
	assign BB5DistY = DrawY - BB5Y;
	assign BB5Size = BB5_size;
	
	always_comb
	begin:BB5_on_proc
		
		if((BB5DistX <= BB5Size) && (BB5DistY <= BB5Size))
			BB5_on <= 1'b1;
		else
			BB5_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] BB6DistX, BB6DistY, BB6Size;
	assign BB6DistX = DrawX - BB6X;
	assign BB6DistY = DrawY - BB6Y;
	assign BB6Size = BB6_size;
	
	always_comb
	begin:BB6_on_proc
		
		if((BB6DistX <= BB6Size) && (BB6DistY <= BB6Size))
			BB6_on <= 1'b1;
		else
			BB6_on <= 1'b0;
	end
	
//-------------------------------------------------------------
	logic[11:0] BB7DistX, BB7DistY, BB7Size;
	assign BB7DistX = DrawX - BB7X;
	assign BB7DistY = DrawY - BB7Y;
	assign BB7Size = BB7_size;
	
	always_comb
	begin:BB7_on_proc
		
		if((BB7DistX <= BB7Size) && (BB7DistY <= BB7Size))
			BB7_on <= 1'b1;
		else
			BB7_on <= 1'b0;
	end
//-------------------------------------------------------------
	logic[11:0] BB8DistX, BB8DistY, BB8Size;
	assign BB8DistX = DrawX - BB8X;
	assign BB8DistY = DrawY - BB8Y;
	assign BB8Size = BB8_size;
	
	always_comb
	begin:BB8_on_proc
		
		if((BB8DistX <= BB8Size) && (BB8DistY <= BB8Size))
			BB8_on <= 1'b1;
		else
			BB8_on <= 1'b0;
	end
//-------------------------------------------------------------	
	logic[11:0] BB9DistX, BB9DistY, BB9Size;
	assign BB9DistX = DrawX - BB9X;
	assign BB9DistY = DrawY - BB9Y;
	assign BB9Size = BB9_size;
	
	always_comb
	begin:BB9_on_proc
		
		if((BB9DistX <= BB9Size) && (BB9DistY <= BB9Size))
			BB9_on <= 1'b1;
		else
			BB9_on <= 1'b0;
	end
//-------------------------------------------------------------	
	logic[11:0] BB10DistX, BB10DistY, BB10Size;
	assign BB10DistX = DrawX - BB10X;
	assign BB10DistY = DrawY - BB10Y;
	assign BB10Size = BB10_size;
	
	always_comb
	begin:BB10_on_proc
		
		if((BB10DistX <= BB10Size) && (BB10DistY <= BB10Size))
			BB10_on <= 1'b1;
		else
			BB10_on <= 1'b0;
	end

//============================================================
//PIPE BLOCK
//============================================================
	logic[11:0] PBDistX, PBDistY, PBSize;
	assign PBDistX = DrawX - PBX;
	assign PBDistY = DrawY - PBY;
	assign PBSize = PB_size;
	
	always_comb
	begin:PB_on_proc
		
		if((PBDistX <= PBSize) && (PBDistY <= PBSize))
			PB_on <= 1'b1;
		else
			PB_on <= 1'b0;
	end
//================================================================
	logic[11:0] PB2DistX, PB2DistY, PB2Size;
	assign PB2DistX = DrawX - PB2X;
	assign PB2DistY = DrawY - PB2Y;
	assign PB2Size = PB2_size;
	
	always_comb
	begin:PB2_on_proc
		
		if((PB2DistX <= PB2Size) && (PB2DistY <= PB2Size))
			PB2_on <= 1'b1;
		else
			PB2_on <= 1'b0;
	end
//=================================================================

    always_comb
    begin:sprite_on_proc
	 
        if ((DistX <= Size) && (DistY <= Size))
            ball_on = 1'b1;
		 else
				ball_on = 1'b0;
     end 
//============================================================
	  
	  
	  always_comb
	  begin: goomba_on_proc
			if(goombaOverflowFlag == 1'b1)
				goomba_on = 1'b0;
			
			else begin
				if((goombaDistX <= goombaSize && goombaDistY <= goombaSize))
					goomba_on = 1'b1;
				else
					goomba_on = 1'b0;
			end
	  end
		
//=============================================================
		
		
   always_ff @ (posedge vga_clk) begin
		Red <= 8'h00;
		Green <= 8'h00;
		Blue <= 8'h00;
		
		if(blank) begin //if drawing in on screen	
			
			if(gameovertemp) begin
				Red <= 8'h00;
				Green <= 8'h00;
				Blue <= 8'h00;
			
			end
			
			else if(QB1_on == 1'b1) begin
				unique case (coinsignal)
				2'b00 : begin
					Red <= qb1_red;
					Green <= qb1_green;
					Blue <= qb1_blue;
					end
				2'b01 : begin
					Red <= qb2_1_red;
					Green <= qb2_1_green;
					Blue <= qb2_1_blue;
					end
				
				2'b10 : begin
					Red <= qb3_1_red;
					Green <= qb3_1_green;
					Blue <= qb3_1_blue;
					end
				
				2'b11 : begin
					Red <= qb2_1_red;
					Green <= qb2_1_green;
					Blue <= qb2_1_blue;
					end
				endcase
			end
			
			else if(QB4_on == 1'b1) begin
				unique case (coinsignal)
				2'b00 : begin
					Red <= qb4_red;
					Green <= qb4_green;
					Blue <= qb4_blue;
					end
				2'b01 : begin
					Red <= qb2_2_red;
					Green <= qb2_2_green;
					Blue <= qb2_2_blue;
					end
				
				2'b10 : begin
					Red <= qb3_2_red;
					Green <= qb3_2_green;
					Blue <= qb3_2_blue;
					end
				
				2'b11 : begin
					Red <= qb2_2_red;
					Green <= qb2_2_green;
					Blue <= qb2_2_blue;
					end
				endcase
			end
			
			else if(QB5_on == 1'b1) begin
				unique case (coinsignal)
				2'b00 : begin
					Red <= qb5_red;
					Green <= qb5_green;
					Blue <= qb5_blue;
					end
				2'b01 : begin
					Red <= qb2_3_red;
					Green <= qb2_3_green;
					Blue <= qb2_3_blue;
					end
				
				2'b10 : begin
					Red <= qb3_3_red;
					Green <= qb3_3_green;
					Blue <= qb3_3_blue;
					end
				
				2'b11 : begin
					Red <= qb2_3_red;
					Green <= qb2_3_green;
					Blue <= qb2_3_blue;
					end
				endcase
			end
			
			else if(QB6_on == 1'b1) begin
				unique case (coinsignal)
				2'b00 : begin
					Red <= qb6_red;
					Green <= qb6_green;
					Blue <= qb6_blue;
					end
				2'b01 : begin
					Red <= qb2_4_red;
					Green <= qb2_4_green;
					Blue <= qb2_4_blue;
					end
				
				2'b10 : begin
					Red <= qb3_4_red;
					Green <= qb3_4_green;
					Blue <= qb3_4_blue;
					end
				
				2'b11 : begin
					Red <= qb2_4_red;
					Green <= qb2_4_green;
					Blue <= qb2_4_blue;
					end
				endcase
			end
			
			else if(QB7_on == 1'b1) begin
				unique case (coinsignal)
				2'b00 : begin
					Red <= qb7_red;
					Green <= qb7_green;
					Blue <= qb7_blue;
					end
				2'b01 : begin
					Red <= qb2_5_red;
					Green <= qb2_5_green;
					Blue <= qb2_5_blue;
					end
				
				2'b10 : begin
					Red <= qb3_5_red;
					Green <= qb3_5_green;
					Blue <= qb3_5_blue;
					end
				
				2'b11 : begin
					Red <= qb2_5_red;
					Green <= qb2_5_green;
					Blue <= qb2_5_blue;
					end
				endcase
			end
			
			else if(QB8_on == 1'b1) begin
				unique case (coinsignal)
				2'b00 : begin
					Red <= qb8_red;
					Green <= qb8_green;
					Blue <= qb8_blue;
					end
				2'b01 : begin
					Red <= qb2_6_red;
					Green <= qb2_6_green;
					Blue <= qb2_6_blue;
					end
				
				2'b10 : begin
					Red <= qb3_6_red;
					Green <= qb3_6_green;
					Blue <= qb3_6_blue;
					end
				
				2'b11 : begin
					Red <= qb2_6_red;
					Green <= qb2_6_green;
					Blue <= qb2_6_blue;
					end
				endcase
			end
			
			else if(QB9_on == 1'b1) begin
				unique case (coinsignal)
				2'b00 : begin
					Red <= qb9_red;
					Green <= qb9_green;
					Blue <= qb9_blue;
					end
				2'b01 : begin
					Red <= qb2_7_red;
					Green <= qb2_7_green;
					Blue <= qb2_7_blue;
					end
				
				2'b10 : begin
					Red <= qb3_7_red;
					Green <= qb3_7_green;
					Blue <= qb3_7_blue;
					end
				
				2'b11 : begin
					Red <= qb2_7_red;
					Green <= qb2_7_green;
					Blue <= qb2_7_blue;
					end
				endcase
			end
			
//			else if(heart3_on == 1'b1 && healthbar == 2'b11) begin
//				Red <= heart_red;
//				Green <= heart_green;
//				Blue <= heart_blue;
//			end
//			else if(heart2_on == 1'b1 && healthbar == 2'b10) begin
//				Red <= 	heart2_red;
//				Green <= heart2_green;
//				Blue <= 	heart2_blue;
//			end
//
//			else if(heart1_on == 1'b1 && healthbar == 2'b01) begin
//				Red <= 	heart1_red;
//				Green <= heart1_green;
//				Blue <= 	heart1_blue;
//			end
			
			else if(CB1_on == 1'b1) begin
				if(!((coin1_red == 4'hF) && (coin1_green == 4'h0) && (coin1_blue == 4'hD))) begin
					Red <= coin1_red;
					Green <= coin1_green;
					Blue <= coin1_blue;
				end
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end
			
			else if(CB2_on == 1'b1) begin
				if(!((coin2_red == 4'hF) && (coin2_green == 4'h0) && (coin2_blue == 4'hD))) begin
					Red <= coin2_red;
					Green <= coin2_green;
					Blue <= coin2_blue;
				end
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end
//			
			else if(CB3_on == 1'b1) begin
				if(!((coin3_red == 4'hF) && (coin3_green == 4'h0) && (coin3_blue == 4'hD))) begin
					Red <= 	coin3_red;
					Green <= coin3_green;
					Blue <= 	coin3_blue;
				end
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end
			else if(CB4_on == 1'b1) begin
				if(!((coin4_red == 4'hF) && (coin4_green == 4'h0) && (coin4_blue == 4'hD))) begin
					Red <= 	coin4_red;
					Green <= coin4_green;
					Blue <= 	coin4_blue;
				end
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end
			else if(CB5_on == 1'b1) begin
				if(!((coin5_red == 4'hF) && (coin5_green == 4'h0) && (coin5_blue == 4'hD))) begin
					Red <= 	coin5_red;
					Green <= coin5_green;
					Blue <= 	coin5_blue;
				end
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end
			else if(CB6_on == 1'b1) begin
				if(!((coin6_red == 4'hF) && (coin6_green == 4'h0) && (coin6_blue == 4'hD))) begin
					Red <= 	coin6_red;
					Green <= coin6_green;
					Blue <= 	coin6_blue;
				end
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end
			else if(CB7_on == 1'b1) begin
				if(!((coin7_red == 4'hF) && (coin7_green == 4'h0) && (coin7_blue == 4'hD))) begin
					Red <= 	coin7_red;
					Green <= coin7_green;
					Blue <= 	coin7_blue;
				end
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end

			
			else if(BB1_on == 1'b1) begin
				Red <= bb1_red;
				Green <= bb1_green;
				Blue <= bb1_blue;
			end
			else if(BB2_on == 1'b1) begin
				Red <= bb2_red;
				Green <= bb2_green;
				Blue <= bb2_blue;
			end
			else if(BB3_on == 1'b1) begin
				Red <= bb3_red;
				Green <= bb3_green;
				Blue <= bb3_blue;
			end
			else if(BB4_on == 1'b1) begin
				Red <= bb4_red;
				Green <= bb4_green;
				Blue <= bb4_blue;
			end
			else if(BB5_on == 1'b1) begin
				Red <= bb5_red;
				Green <= bb5_green;
				Blue <= bb5_blue;
			end
			else if(BB6_on == 1'b1) begin
				Red <= bb6_red;
				Green <= bb6_green;
				Blue <= bb6_blue;
			end
			
			else if(BB7_on == 1'b1) begin
				Red <= bb7_red;
				Green <= bb7_green;
				Blue <= bb7_blue;
			end
			
			else if(BB8_on == 1'b1) begin
				Red <= bb8_red;
				Green <= bb8_green;
				Blue <= bb8_blue;
			end

			else if(BB9_on == 1'b1) begin
				Red <= bb9_red;
				Green <= bb9_green;
				Blue <= bb9_blue;
			end
			
			else if(BB10_on == 1'b1) begin
				Red <= bb10_red;
				Green <= bb10_green;
				Blue <= bb10_blue;
			end
			
			else if(SB1_on == 1'b1) begin
				Red <= sb1_red;
				Green <= sb1_green;
				Blue <= sb1_blue;
			end

			
			else if(ball_on == 1'b1) begin //if drawing mario
				if(MarioFlag == 1'b0) begin //if mario is alive
					if(marioDirection) begin //if mario is facing right
						case (MARIO_FSM[2:0])
							3'b000 : begin //idle
											if(!((idle_mario_1_red == 4'hF) && (idle_mario_1_green == 4'h0) && (idle_mario_1_blue == 4'hD))) begin
												Red <= idle_mario_1_red;
												Green <= idle_mario_1_green;
												Blue <= idle_mario_1_blue;
											end
											else begin
												Red <= BG_RED;
												Green <= BG_GREEN;
												Blue <= BG_BLUE;
											end
										end //idle
										
							3'b100 : begin //switch
											if(!((SW_RIGHT_red == 4'hF) && (SW_RIGHT_green == 4'h0) && (SW_RIGHT_blue == 4'hD))) begin
												Red <= SW_RIGHT_red;
												Green <= SW_RIGHT_green;
												Blue <= SW_RIGHT_blue;
											end
											else begin
												Red <= BG_RED;
												Green <= BG_GREEN;
												Blue <= BG_BLUE;
											end
										end
										
							3'b010 : begin //right foot
											if(!((RF_RIGHT_red == 4'hF) && (RF_RIGHT_green == 4'h0) && (RF_RIGHT_blue == 4'hD))) begin
												Red <= RF_RIGHT_red;
												Green <= RF_RIGHT_green;
												Blue <= RF_RIGHT_blue;
											end
											else begin
												Red <= BG_RED;
												Green <= BG_GREEN;
												Blue <= BG_BLUE;
											end
										end
										
							3'b001 : begin //left foot
											if(!((LF_RIGHT_red == 4'hF) && (LF_RIGHT_green == 4'h0) && (LF_RIGHT_blue == 4'hD))) begin
												Red <= LF_RIGHT_red;
												Green <= LF_RIGHT_green;
												Blue <= LF_RIGHT_blue;
											end
											else begin
												Red <= BG_RED;
												Green <= BG_GREEN;
												Blue <= BG_BLUE;
											end
										end
								
							default : ;
						endcase
							
					end //if mario right close
					
					else if (marioDirection == 1'b0) begin //if drawing mario left
						case (MARIO_FSM[2:0])
							3'b000 : begin //idle
											if(!((marioleft_red == 4'hF) && (marioleft_green == 4'h0) && (marioleft_blue == 4'hD))) begin
												Red <= marioleft_red;
												Green <= marioleft_green;
												Blue <= marioleft_blue;
											end
											else begin
												Red <= BG_RED;
												Green <= BG_GREEN;
												Blue <= BG_BLUE;
											end
										end //idle
										
							3'b100 : begin //switch
											if(!((SW_LEFT_red == 4'hF) && (SW_LEFT_green == 4'h0) && (SW_LEFT_blue == 4'hD))) begin
												Red <= SW_LEFT_red;
												Green <= SW_LEFT_green;
												Blue <= SW_LEFT_blue;
											end
											else begin
												Red <= BG_RED;
												Green <= BG_GREEN;
												Blue <= BG_BLUE;
											end
										end
										
							3'b010 : begin //right foot
											if(!((RF_LEFT_red == 4'hF) && (RF_LEFT_green == 4'h0) && (RF_LEFT_blue == 4'hD))) begin
												Red <= RF_LEFT_red;
												Green <= RF_LEFT_green;
												Blue <= RF_LEFT_blue;
											end
											else begin
												Red <= BG_RED;
												Green <= BG_GREEN;
												Blue <= BG_BLUE;
											end
										end
										
							3'b001 : begin //left foot
											if(!((LF_LEFT_red == 4'hF) && (LF_LEFT_green == 4'h0) && (LF_LEFT_blue == 4'hD))) begin
												Red <= LF_LEFT_red;
												Green <= LF_LEFT_green;
												Blue <= LF_LEFT_blue;
											end
											else begin
												Red <= BG_RED;
												Green <= BG_GREEN;
												Blue <= BG_BLUE;
											end
										end
							default : ;
						endcase	
					end //if mario facing left close
					
					else begin //draw background
						Red <= BG_RED;
						Green <= BG_GREEN;
						Blue <= BG_BLUE;
					end
				end//if mario is alive close
				else if (MarioFlag == 1'b1) begin //if mario dead
					if(!((mariodead_red == 4'hF) && (mariodead_green == 4'h0) && (mariodead_blue == 4'hD))) begin
							Red <= mariodead_red;
							Green <= mariodead_green;
							Blue <= mariodead_blue;
					end
					
					else begin
						Red <= BG_RED;
						Green <= BG_GREEN;
						Blue <= BG_BLUE;
					end
				end //if mario dead close
				
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end //if drawing mario close
			
			else if(PB_on == 1'b1) begin
				if(!(pb_red == 4'hF && pb_green == 4'h0 && pb_blue == 4'hD)) begin
					Red <= pb_red;
					Green <= pb_green;
					Blue <= pb_blue;
				end
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end

			else if(PB2_on == 1'b1) begin
				if(!(pb2_red == 4'hF && pb2_green == 4'h0 && pb2_blue == 4'hD)) begin
					Red <= pb2_red;
					Green <= pb2_green;
					Blue <= pb2_blue;
				end
				else begin
					Red <= BG_RED;
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
				end
			end		   
			
			else if((goomba_on == 1'b1 && goombaAnimationFlag == 1'b1) && !((goomba_red == 4'hF) && (goomba_green == 4'h0) && (goomba_blue == 4'hD))) 
				begin
					Red <= goomba_red;
					Green <= goomba_green;
					Blue <= goomba_blue;
				end
		   
			else if((goomba_on == 1'b1 && goombaAnimationFlag == 1'b0) && !((goomba2_red == 4'hF) && (goomba2_green == 4'h0) && (goomba2_blue == 4'hD)))
				begin
					Red <= goomba2_red;
					Green <= goomba2_green;
					Blue <= goomba2_blue;
				end
         
			else begin
					Red <= BG_RED; 
					Green <= BG_GREEN;
					Blue <= BG_BLUE;
			end //if drawing character close      
	   end //if blank end
	end //always_ff end

//============================================================================
//SPRITE RAM CALLS
//============================================================================
logic [3:0] bg1_red, bg1_green, bg1_blue;
logic [3:0] BG_RED, BG_GREEN, BG_BLUE;	
logic marioboundssig; //don't know why wiring like this but it works so FIWB
logic mariobricksig;

assign marioBoundsFlag = marioboundssig;
assign marioBrickFlag = mariobricksig;

mariomap BG1(.*, .ScrollX(ScrollX), .marioBoundsFlag(marioboundssig), .marioBrickFlag(mariobricksig));

drawBackground AVOIDPINK(.red(bg1_red),
								 .green(bg1_green),
								 .blue(bg1_blue),
								 .red_out(BG_RED),
								 .green_out(BG_GREEN),
								 .blue_out(BG_BLUE));

logic [3:0] goomba_red, goomba_green, goomba_blue;
goomba_sprite GOOMBA(.*);

logic [3:0] goomba2_red, goomba2_green, goomba2_blue;
goomba2 GOOMBA2(.*);

logic [3:0] idle_mario_1_red, idle_mario_1_green, idle_mario_1_blue;
idle_mario_1 IDLE_MARIO_1(.*, .MarioX(BallX), .MarioY(BallY));

logic [3:0] mariodead_red, mariodead_green, mariodead_blue;
mariodead MARIODEAD(.*, .MarioX(BallX), .MarioY(BallY));

logic [3:0] marioleft_red, marioleft_green, marioleft_blue;
marioleft MARIOLEFT(.*, .MarioX(BallX), .MarioY(BallY));

logic [3:0] SW_LEFT_red, SW_LEFT_green, SW_LEFT_blue;
marioswitch_LEFT SWITCHLEFT(.*, .MarioX(BallX), .MarioY(BallY));

logic [3:0] SW_RIGHT_red, SW_RIGHT_green, SW_RIGHT_blue;
marioswitch_RIGHT SWITCHRIGHT(.*, .MarioX(BallX), .MarioY(BallY));

logic [3:0] LF_LEFT_red, LF_LEFT_green, LF_LEFT_blue;
marioleftfoot_LEFT LFL(.*, .MarioX(BallX), .MarioY(BallY));

logic [3:0] LF_RIGHT_red, LF_RIGHT_green, LF_RIGHT_blue;
marioleftfoot_RIGHT LFR(.*, .MarioX(BallX), .MarioY(BallY));

logic [3:0] RF_LEFT_red, RF_LEFT_green, RF_LEFT_blue;
mariorightfoot_LEFT RFL(.*, .MarioX(BallX), .MarioY(BallY));

logic [3:0] RF_RIGHT_red, RF_RIGHT_green, RF_RIGHT_blue;
mariorightfoot_RIGHT RFR(.*, .MarioX(BallX), .MarioY(BallY));

//===========================================================
//QUESTION BLOCK SPRITES
//===========================================================

logic [3:0] qb1_red, qb1_green, qb1_blue;
questionBlockSprite QB1(.*, .qb_red(qb1_red), .qb_green(qb1_green), .qb_blue(qb1_blue), .QBX(QB1X), .QBY(QB1Y));

logic [3:0] qb4_red, qb4_green, qb4_blue;
questionBlockSprite QB4(.*, .qb_red(qb4_red), .qb_green(qb4_green), .qb_blue(qb4_blue), .QBX(QB4X), .QBY(QB4Y));

logic [3:0] qb5_red, qb5_green, qb5_blue;
questionBlockSprite QB5(.*, .qb_red(qb5_red), .qb_green(qb5_green), .qb_blue(qb5_blue), .QBX(QB5X), .QBY(QB5Y));

logic [3:0] qb6_red, qb6_green, qb6_blue;
questionBlockSprite QB6(.*, .qb_red(qb6_red), .qb_green(qb6_green), .qb_blue(qb6_blue), .QBX(QB6X), .QBY(QB6Y));

logic [3:0] qb7_red, qb7_green, qb7_blue;
questionBlockSprite QB7(.*, .qb_red(qb7_red), .qb_green(qb7_green), .qb_blue(qb7_blue), .QBX(QB7X), .QBY(QB7Y));

logic [3:0] qb8_red, qb8_green, qb8_blue;
questionBlockSprite QB8(.*, .qb_red(qb8_red), .qb_green(qb8_green), .qb_blue(qb8_blue), .QBX(QB8X), .QBY(QB8Y));

logic [3:0] qb9_red, qb9_green, qb9_blue;
questionBlockSprite QB9(.*, .qb_red(qb9_red), .qb_green(qb9_green), .qb_blue(qb9_blue), .QBX(QB9X), .QBY(QB9Y));

//==========================================================
//QUESTION BLOCK ANIMATION
//==========================================================
logic [1:0] coinsignal;

coinAnimation COINS(.Reset(Reset), .frame_clk(frame_clk), .COINSIGNAL(coinsignal));


logic [3:0] qb2_1_red, qb2_1_green, qb2_1_blue;
qb2 QB2_1(.*, .qb2_red(qb2_1_red), .qb2_green(qb2_1_green), .qb2_blue(qb2_1_blue), .QB2X(QB1X), .QB2Y(QB1Y));

logic [3:0] qb3_1_red, qb3_1_green, qb3_1_blue;
qb3 QB3_1(.*, .qb3_red(qb3_1_red), .qb3_green(qb3_1_green), .qb3_blue(qb3_1_blue), .QB3X(QB1X), .QB3Y(QB1Y));


logic [3:0] qb2_2_red, qb2_2_green, qb2_2_blue;
qb2 QB2_2(.*, .qb2_red(qb2_2_red), .qb2_green(qb2_2_green), .qb2_blue(qb2_2_blue), .QB2X(QB4X), .QB2Y(QB4Y));

logic [3:0] qb3_2_red, qb3_2_green, qb3_2_blue;
qb3 QB3_2(.*, .qb3_red(qb3_2_red), .qb3_green(qb3_2_green), .qb3_blue(qb3_2_blue), .QB3X(QB4X), .QB3Y(QB4Y));


logic [3:0] qb2_3_red, qb2_3_green, qb2_3_blue;
qb2 QB2_3(.*, .qb2_red(qb2_3_red), .qb2_green(qb2_3_green), .qb2_blue(qb2_3_blue), .QB2X(QB5X), .QB2Y(QB5Y));

logic [3:0] qb3_3_red, qb3_3_green, qb3_3_blue;
qb3 QB3_3(.*, .qb3_red(qb3_3_red), .qb3_green(qb3_3_green), .qb3_blue(qb3_3_blue), .QB3X(QB5X), .QB3Y(QB5Y));


logic [3:0] qb2_4_red, qb2_4_green, qb2_4_blue;
qb2 QB2_4(.*, .qb2_red(qb2_4_red), .qb2_green(qb2_4_green), .qb2_blue(qb2_4_blue), .QB2X(QB6X), .QB2Y(QB6Y));

logic [3:0] qb3_4_red, qb3_4_green, qb3_4_blue;
qb3 QB3_4(.*, .qb3_red(qb3_4_red), .qb3_green(qb3_4_green), .qb3_blue(qb3_4_blue), .QB3X(QB6X), .QB3Y(QB6Y));

logic [3:0] qb2_5_red, qb2_5_green, qb2_5_blue;
qb2 QB2_5(.*, .qb2_red(qb2_5_red), .qb2_green(qb2_5_green), .qb2_blue(qb2_5_blue), .QB2X(QB7X), .QB2Y(QB7Y));

logic [3:0] qb3_5_red, qb3_5_green, qb3_5_blue;
qb3 QB3_5(.*, .qb3_red(qb3_5_red), .qb3_green(qb3_5_green), .qb3_blue(qb3_5_blue), .QB3X(QB7X), .QB3Y(QB7Y));


logic [3:0] qb2_6_red, qb2_6_green, qb2_6_blue;
qb2 QB2_6(.*, .qb2_red(qb2_6_red), .qb2_green(qb2_6_green), .qb2_blue(qb2_6_blue), .QB2X(QB8X), .QB2Y(QB8Y));

logic [3:0] qb3_6_red, qb3_6_green, qb3_6_blue;
qb3 QB3_6(.*, .qb3_red(qb3_6_red), .qb3_green(qb3_6_green), .qb3_blue(qb3_6_blue), .QB3X(QB8X), .QB3Y(QB8Y));


logic [3:0] qb2_7_red, qb2_7_green, qb2_7_blue;
qb2 QB2_7(.*, .qb2_red(qb2_7_red), .qb2_green(qb2_7_green), .qb2_blue(qb2_7_blue), .QB2X(QB9X), .QB2Y(QB9Y));

logic [3:0] qb3_7_red, qb3_7_green, qb3_7_blue;
qb3 QB3_7(.*, .qb3_red(qb3_7_red), .qb3_green(qb3_7_green), .qb3_blue(qb3_7_blue), .QB3X(QB9X), .QB3Y(QB9Y));

//=========================================================
//BRICK BLOCK SPRITES
//=========================================================
logic [3:0] bb1_red, bb1_green, bb1_blue;
brickBlockSprite BB1(.*, .bb_red(bb1_red), .bb_green(bb1_green), .bb_blue(bb1_blue), .BBX(BB1X), .BBY(BB1Y));

logic [3:0] bb2_red, bb2_green, bb2_blue;
brickBlockSprite BB2(.*, .bb_red(bb2_red), .bb_green(bb2_green), .bb_blue(bb2_blue), .BBX(BB2X), .BBY(BB2Y));

logic [3:0] bb3_red, bb3_green, bb3_blue;
brickBlockSprite BB3(.*, .bb_red(bb3_red), .bb_green(bb3_green), .bb_blue(bb3_blue), .BBX(BB3X), .BBY(BB3Y));

logic [3:0] bb4_red, bb4_green, bb4_blue;
brickBlockSprite BB4(.*, .bb_red(bb4_red), .bb_green(bb4_green), .bb_blue(bb4_blue), .BBX(BB4X), .BBY(BB4Y));

logic [3:0] bb5_red, bb5_green, bb5_blue;
brickBlockSprite BB5(.*, .bb_red(bb5_red), .bb_green(bb5_green), .bb_blue(bb5_blue), .BBX(BB5X), .BBY(BB5Y));

logic [3:0] bb6_red, bb6_green, bb6_blue;
brickBlockSprite BB6(.*, .bb_red(bb6_red), .bb_green(bb6_green), .bb_blue(bb6_blue), .BBX(BB6X), .BBY(BB6Y));

logic [3:0] bb7_red, bb7_green, bb7_blue;
brickBlockSprite BB7(.*, .bb_red(bb7_red), .bb_green(bb7_green), .bb_blue(bb7_blue), .BBX(BB7X), .BBY(BB7Y));

logic [3:0] bb8_red, bb8_green, bb8_blue;
brickBlockSprite BB8(.*, .bb_red(bb8_red), .bb_green(bb8_green), .bb_blue(bb8_blue), .BBX(BB8X), .BBY(BB8Y));

logic [3:0] bb9_red, bb9_green, bb9_blue;
brickBlockSprite BB9(.*, .bb_red(bb9_red), .bb_green(bb9_green), .bb_blue(bb9_blue), .BBX(BB9X), .BBY(BB9Y));

logic [3:0] bb10_red, bb10_green, bb10_blue;
brickBlockSprite BB10(.*, .bb_red(bb10_red), .bb_green(bb10_green), .bb_blue(bb10_blue), .BBX(BB10X), .BBY(BB10Y));

//================================================================
//STAIR BLOCK SPRITES
//================================================================
logic [3:0] sb1_red, sb1_green, sb1_blue;
stairBlockSprite SB1(.*, .sb_red(sb1_red), .sb_green(sb1_green), .sb_blue(sb1_blue), .SBX(SB1X), .SBY(SB1Y));

//==============================================================================================================
//PIPE BLOCK SPRITES
//==============================================================================================================
logic [3:0] pb_red, pb_green, pb_blue;
pipeBlockSprite PB1(.*, .pb_red(pb_red), .pb_green(pb_green), .pb_blue(pb_blue), .PBX(PBX), .PBY(PBY));

logic [3:0] pb2_red, pb2_green, pb2_blue;
pipeBlockSprite PB2(.*, .pb_red(pb2_red), .pb_green(pb2_green), .pb_blue(pb2_blue), .PBX(PB2X), .PBY(PB2Y));
//================================================================================================================

logic [3:0] coin1_red, coin1_green, coin1_blue;
coin COIN1(.*, .coin_red(coin1_red), .coin_green(coin1_green), .coin_blue(coin1_blue), .COIN_X(CB1X), .COIN_Y(CB1Y));

logic [3:0] coin2_red, coin2_green, coin2_blue;
coin COIN2(.*, .coin_red(coin2_red), .coin_green(coin2_green), .coin_blue(coin2_blue), .COIN_X(CB2X), .COIN_Y(CB2Y));

logic [3:0] coin3_red, coin3_green, coin3_blue;
coin COIN3(.*, .coin_red(coin3_red), .coin_green(coin3_green), .coin_blue(coin3_blue), .COIN_X(CB3X), .COIN_Y(CB3Y));

logic [3:0] coin4_red, coin4_green, coin4_blue;
coin COIN4(.*, .coin_red(coin4_red), .coin_green(coin4_green), .coin_blue(coin4_blue), .COIN_X(CB4X), .COIN_Y(CB4Y));

logic [3:0] coin5_red, coin5_green, coin5_blue;
coin COIN5(.*, .coin_red(coin5_red), .coin_green(coin5_green), .coin_blue(coin5_blue), .COIN_X(CB5X), .COIN_Y(CB5Y));

logic [3:0] coin6_red, coin6_green, coin6_blue;
coin COIN6(.*, .coin_red(coin6_red), .coin_green(coin6_green), .coin_blue(coin6_blue), .COIN_X(CB6X), .COIN_Y(CB6Y));

logic [3:0] coin7_red, coin7_green, coin7_blue;
coin COIN7(.*, .coin_red(coin7_red), .coin_green(coin7_green), .coin_blue(coin7_blue), .COIN_X(CB7X), .COIN_Y(CB7Y));

logic [11:0] LIFE3X = 400;
logic [11:0] LIFE3Y = 50;

logic [3:0] heart_red, heart_green, heart_blue, heart2_red, heart2_green, heart2_blue, heart1_red, heart1_green, heart1_blue;

//life3 LIFE3(.DrawX(DrawX), .DrawY(DrawY), .ScrollX(ScrollX), .LIFEX(LIFE3X), .LIFEY(LIFE3Y), .vga_clk(vga_clk), .blank(blank),
//				.heart_red(heart_red), .heart_green(heart_green), .heart_blue(heart_blue));
//				
//life2 LIFE2(.DrawX(DrawX), .DrawY(DrawY), .ScrollX(ScrollX), .LIFEX(LIFE3X), .LIFEY(LIFE3Y), .vga_clk(vga_clk), .blank(blank),
//				.heart_red(heart2_red), .heart_green(heart2_green), .heart_blue(heart2_blue));
//
//life1 LIFE1(.DrawX(DrawX), .DrawY(DrawY), .ScrollX(ScrollX), .LIFEX(LIFE3X), .LIFEY(LIFE3Y), .vga_clk(vga_clk), .blank(blank),
//				.heart_red(heart1_red), .heart_green(heart1_green), .heart_blue(heart1_blue));




logic boxCollisionsig;
logic boxCollisionsig2;
logic boxCollisionsig3;
logic boxCollisionsig4;
logic boxCollisionsig5;
logic boxCollisionsig6;
logic boxCollisionsig7;

logic coinCollisionsig;
logic coinCollisionsig2;
logic coinCollisionsig3;
logic coinCollisionsig4;
logic coinCollisionsig5;
logic coinCollisionsig6;
logic coinCollisionsig7;

logic holdCOLLISION;
logic holdCOLLISION2;
logic holdCOLLISION3;
logic holdCOLLISION4;
logic holdCOLLISION5;
logic holdCOLLISION6;
logic holdCOLLISION7;

logic holdCoinCOLLISION;
logic holdCoinCOLLISION2;
logic holdCoinCOLLISION3;
logic holdCoinCOLLISION4;
logic holdCoinCOLLISION5;
logic holdCoinCOLLISION6;
logic holdCoinCOLLISION7;



always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCOLLISION <= 1'b0;
	
	else if(boxCollisionsig)
		holdCOLLISION <= 1'b1;
end


always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCOLLISION2 <= 1'b0;
	
	else if(boxCollisionsig2)
		holdCOLLISION2 <= 1'b1;
end


always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCOLLISION3 <= 1'b0;
	
	else if(boxCollisionsig3)
		holdCOLLISION3 <= 1'b1;
end

always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCOLLISION4 <= 1'b0;
	
	else if(boxCollisionsig4)
		holdCOLLISION4 <= 1'b1;
end

always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCOLLISION5 <= 1'b0;
	
	else if(boxCollisionsig5)
		holdCOLLISION5 <= 1'b1;
end


always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCOLLISION6 <= 1'b0;
	
	else if(boxCollisionsig6)
		holdCOLLISION6 <= 1'b1;
end


always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCOLLISION7 <= 1'b0;
	
	else if(boxCollisionsig7)
		holdCOLLISION7 <= 1'b1;
end




always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCoinCOLLISION <= 1'b0;
		
	else if(coinCollisionsig)
		holdCoinCOLLISION <= 1'b1;
end


always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCoinCOLLISION2 <= 1'b0;
	else if(coinCollisionsig2)
		holdCoinCOLLISION2 <= 1'b1;
end

always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset) 
		holdCoinCOLLISION3 <= 1'b0;

	else if(coinCollisionsig3)
		holdCoinCOLLISION3 <= 1'b1;
end

always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset) 
		holdCoinCOLLISION4 <= 1'b0;
	
	else if(coinCollisionsig4)
		holdCoinCOLLISION4 <= 1'b1;
end

always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		holdCoinCOLLISION5 <= 1'b0;
	
	else if(coinCollisionsig5)
		holdCoinCOLLISION5 <= 1'b1;
end

always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset) 
		holdCoinCOLLISION6 <= 1'b0;

	else if(coinCollisionsig6)
		holdCoinCOLLISION6 <= 1'b1;
end

always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset) 
		holdCoinCOLLISION7 <= 1'b0;
	
	else if(coinCollisionsig7)
		holdCoinCOLLISION7 <= 1'b1;
end




logic [3:0] score;



always_ff @ (posedge frame_clk or posedge Reset) begin
	if(Reset)
		score <= 0;
	else if(coinCollisionsig || coinCollisionsig2 || coinCollisionsig3 || coinCollisionsig4 || coinCollisionsig5 || coinCollisionsig6 || coinCollisionsig7)
		score <= score + 1;
end
		
	
							
marioMysteryCollision QBCollision1(.MarioX(BallX),
											  .MarioY(BallY),
											  .MarioS(Ball_size),
											  .QBlockX(QB1X),
											  .QBlockY(QB1Y),
											  .QBlockS(QB1_size),
											  .collision(boxCollisionsig));
											  

marioCoinCollision CBCollision1(.MarioX(BallX),
										  .MarioY(BallY),
										  .MarioS(Ball_size),
										  .CBlockX(CB1X),
										  .CBlockY(CB1Y),
										  .CBlockS(CB1_size),
										  .collision(coinCollisionsig));



assign COINCOLLISION = holdCOLLISION;
assign SCORECOLLISION = holdCoinCOLLISION;



//2
marioMysteryCollision QBCollision2(.MarioX(BallX),
											  .MarioY(BallY),
											  .MarioS(Ball_size),
											  .QBlockX(QB4X),
											  .QBlockY(QB4Y),
											  .QBlockS(QB4_size),
											  .collision(boxCollisionsig2));
											  

marioCoinCollision CBCollision2(.MarioX(BallX),
										  .MarioY(BallY),
										  .MarioS(Ball_size),
										  .CBlockX(CB2X),
										  .CBlockY(CB2Y),
										  .CBlockS(CB2_size),
										  .collision(coinCollisionsig2));



assign COINCOLLISION2 = holdCOLLISION2;


assign SCORECOLLISION2 = holdCoinCOLLISION2;
//3
marioMysteryCollision QBCollision3(.MarioX(BallX),
											  .MarioY(BallY),
											  .MarioS(Ball_size),
											  .QBlockX(QB5X),
											  .QBlockY(QB5Y),
											  .QBlockS(QB5_size),
											  .collision(boxCollisionsig3));
											  

marioCoinCollision CBCollision3(.MarioX(BallX),
										  .MarioY(BallY),
										  .MarioS(Ball_size),
										  .CBlockX(CB3X),
										  .CBlockY(CB3Y),
										  .CBlockS(CB3_size),
										  .collision(coinCollisionsig3));



assign COINCOLLISION3 = holdCOLLISION3;


assign SCORECOLLISION3 = holdCoinCOLLISION3;
//4
marioMysteryCollision QBCollision4(.MarioX(BallX),
											  .MarioY(BallY),
											  .MarioS(Ball_size),
											  .QBlockX(QB6X),
											  .QBlockY(QB6Y),
											  .QBlockS(QB6_size),
											  .collision(boxCollisionsig4));
											  

marioCoinCollision CBCollision4(.MarioX(BallX),
										  .MarioY(BallY),
										  .MarioS(Ball_size),
										  .CBlockX(CB4X),
										  .CBlockY(CB4Y),
										  .CBlockS(CB4_size),
										  .collision(coinCollisionsig4));



assign COINCOLLISION4 = holdCOLLISION4;


assign SCORECOLLISION4 = holdCoinCOLLISION4;
//5
marioMysteryCollision QBCollision5(.MarioX(BallX),
											  .MarioY(BallY),
											  .MarioS(Ball_size),
											  .QBlockX(QB7X),
											  .QBlockY(QB7Y),
											  .QBlockS(QB7_size),
											  .collision(boxCollisionsig5));
											  

marioCoinCollision CBCollision5(.MarioX(BallX),
										  .MarioY(BallY),
										  .MarioS(Ball_size),
										  .CBlockX(CB5X),
										  .CBlockY(CB5Y),
										  .CBlockS(CB5_size),
										  .collision(coinCollisionsig5));



assign COINCOLLISION5 = holdCOLLISION5;


assign SCORECOLLISION5 = holdCoinCOLLISION5;
//6
marioMysteryCollision QBCollision6(.MarioX(BallX),
											  .MarioY(BallY),
											  .MarioS(Ball_size),
											  .QBlockX(QB8X),
											  .QBlockY(QB8Y),
											  .QBlockS(QB8_size),
											  .collision(boxCollisionsig6));
											  

marioCoinCollision CBCollision6(.MarioX(BallX),
										  .MarioY(BallY),
										  .MarioS(Ball_size),
										  .CBlockX(CB6X),
										  .CBlockY(CB6Y),
										  .CBlockS(CB6_size),
										  .collision(coinCollisionsig6));



assign COINCOLLISION6 = holdCOLLISION6;


assign SCORECOLLISION6 = holdCoinCOLLISION6;
//7
marioMysteryCollision QBCollision7(.MarioX(BallX),
											  .MarioY(BallY),
											  .MarioS(Ball_size),
											  .QBlockX(QB9X),
											  .QBlockY(QB9Y),
											  .QBlockS(QB9_size),
											  .collision(boxCollisionsig7));
											  

marioCoinCollision CBCollision7(.MarioX(BallX),
										  .MarioY(BallY),
										  .MarioS(Ball_size),
										  .CBlockX(CB7X),
										  .CBlockY(CB7Y),
										  .CBlockS(CB7_size),
										  .collision(coinCollisionsig7));



assign COINCOLLISION7 = holdCOLLISION7;


assign SCORECOLLISION7 = holdCoinCOLLISION7;



assign MARIOSCORE = score;




//
//int a,zero, ten;
//assign a= scrore;
//assign zero=a%10;
//assign ten = ((a-zero)/10)+1;
//
//            if (DrawX>528&&DrawY>110&&DrawY<=124&&DrawX<538)begin
//                                number_address <= (((zero)*10+DrawX -527) + ((DrawY -108) * 100));
//                                Red<=Palette_red;
//                                Green <= Palette_green;
//                                Blue <= Palette_blue;
//         end
//            if (DrawX>518&&DrawY>110&&DrawY<=124&&DrawX<528)begin
//                                number_address <= (((ten)*10+DrawX -527) + ((DrawY -108) * 100));
//                                Red<=Palette_red;
//                                Green <= Palette_green;
//                                Blue <= Palette_blue;
//         end



endmodule

//=================================================================================
//LMAO HELPER FUNCTION FOR BACKGROUND COLORING
//=================================================================================

module drawBackground(input logic [3:0] red, green, blue,
							 output logic [3:0] red_out, green_out, blue_out);
							 
	logic [3:0] RED, GREEN, BLUE;
	
	always_comb begin
	
		if((red == 4'hF) && (green == 4'h0) && (blue == 4'hF)) begin
			RED = 4'h5;
			GREEN = 4'h9;
			BLUE = 4'hF;
		end
		
		else begin
			RED = red;
			GREEN = green;
			BLUE = blue;
		end
	end
	
	assign red_out = RED;
	assign green_out = GREEN;
	assign blue_out = BLUE;
			
		
endmodule
