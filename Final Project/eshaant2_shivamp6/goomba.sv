module  goomba ( input Reset, frame_clk,
					input [7:0] keycode,
					input [11:0] ScrollX,
					input  GoombaFlag,
               output [11:0]  goombaX, goombaY, goombaS,
					output goombaAnimationFlag,
					output overflowFlag);
	 
    logic [11:0] goomba_X_Motion, goomba_Y_Motion;
	 logic [11:0] goomba_X_Pos, goomba_Y_Pos, goomba_Size;
	 	 
	
	 //mario start coordinates
    parameter [11:0] goomba_X_Start = 256;  // Center position on the X axis //256 NORMALLY
    parameter [11:0] goomba_Y_Start = 388;  // Center position on the Y axis *388 NORMALLY, TESTING SCROLLING
	 
    
	 //bounds of the screen
	 parameter [11:0] goomba_X_Min=192;       // Leftmost point on the X axis //192
    parameter [11:0] goomba_X_Max=320;     // Rightmost point on the X axis //320
	 
    parameter [11:0] goomba_Y_Min=0;       // Topmost point on the Y axis
    parameter [11:0] goomba_Y_Max=415;     // Bottommost point on the Y axis
	 
	 parameter [11:0] goomba_X_Step=1;      // Step size on the X axis
	 
	 //Goomba Direction
	 logic DIRECTION_FLAG;  //1'b1 for right, 1'b0 for left
	
	 logic GOOMBA_ANIMATION;
	 logic [4:0] GOOMBA_TIMER;
	 
	 always_ff @ (posedge frame_clk) begin
		if(GOOMBA_TIMER == 15)
			GOOMBA_TIMER <= 0;
		else
			GOOMBA_TIMER <= (GOOMBA_TIMER + 1);
	 end
	 
	 always_ff @ (posedge frame_clk) begin
		if(GOOMBA_TIMER == 15)
			 GOOMBA_ANIMATION <= ~GOOMBA_ANIMATION;
	 end
	 
	 assign goombaAnimationFlag = GOOMBA_ANIMATION;

    assign goomba_Size = 32;
   
    
	 logic overflowCheck;
	 logic [11:0] goombaCheck;
	 logic [31:0] countOverflow;
	 
	 always_ff @ (posedge Reset or posedge frame_clk ) begin
	 
        if (Reset) begin 
            goomba_Y_Motion <= 10'd0;
				goomba_X_Motion <= 10'd0;
				goomba_Y_Pos <= goomba_Y_Start;
				goomba_X_Pos <= goomba_X_Start;
				DIRECTION_FLAG <= 1'b1;
				overflowCheck <= 1'b0;
				countOverflow <= 32'b0;
				goombaCheck <= 12'b0;
        end
		  
		  else begin
		  
				goombaCheck <= goomba_X_Pos - ScrollX;
				
				if(goombaCheck[11] == 1'b1)
					countOverflow <= (countOverflow + 1'b1);
			
				if(countOverflow > 0)
					overflowCheck <= 1'b1;
				
				else
					overflowCheck <= 1'b0;
				
				if ((goomba_X_Pos + goomba_Size) >= goomba_X_Max)
					DIRECTION_FLAG <= 1'b0;
					
				else if (goomba_X_Pos <= goomba_X_Min )
					DIRECTION_FLAG <= 1'b1;
				
				else
					DIRECTION_FLAG <= DIRECTION_FLAG + 1'b0;
				
				unique case (DIRECTION_FLAG)
					1'b1: goomba_X_Motion <= 1;
					1'b0: goomba_X_Motion <= -1;
				endcase
				
				if(GoombaFlag == 1'b0)
				goomba_X_Pos <= (goomba_X_Pos + goomba_X_Motion);
				else
				goomba_X_Pos <= (goomba_X_Pos);
				
		  end
		end
           
	
//	 logic overflowCheck;
//	 logic [9:0] goombaCheck; 
//	 logic [31:0] countOverflow;
//	 
//	 	
//	 
//	 always_ff @ (posedge frame_clk) begin	
//			
//			goombaCheck <= goomba_X_Pos - ScrollX;
//			
//			if(goombaCheck[9] == 1'b1)
//				countOverflow <= (countOverflow + 1'b1);
//		
//			if(countOverflow > 0)
//				overflowCheck <= 1'b1;
//			
//			else
//				overflowCheck <= 1'b0;
//	 end
		
    assign overflowFlag = overflowCheck;
	 
	 assign goombaX = goomba_X_Pos - ScrollX;
   
    assign goombaY = goomba_Y_Pos;
   
    assign goombaS = goomba_Size;
	 
endmodule

