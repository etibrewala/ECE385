//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk, VGA_Clk,
					input [7:0] keycode, keycode1,
					input       MarioFlag,
					input [9:0] DrawX, DrawY,
					input marioBrickFlag,
					input marioBoundsFlag,
					
					input PipeCollisionLeft,
					input PipeCollisionRight,
					input PipeCollisionTop,

					input Pipe2CollisionLeft,
					input Pipe2CollisionRight,
					input Pipe2CollisionTop,
					
					input Brick1CollisionLeft,
					input Brick1CollisionTop,
					input Brick1CollisionRight,
					
					input Brick2CollisionLeft,
					input Brick2CollisionTop,
					input Brick2CollisionRight,					
		
					input Brick3CollisionLeft,
					input Brick3CollisionTop,
					input Brick3CollisionRight,

					input Brick4CollisionLeft,
					input Brick4CollisionTop,
					input Brick4CollisionRight,
					
					input StairCollisionLeft,
					input StairCollisionTop,
					input StairCollisionRight,
					input playerflagtemp,
									
					output MARIOFLAGTEST, //debug ground flag
					output [11:0] VELOCITYOUT,
					output [5:0] JUMPTEST, //jump fsm debug
					output MarioDirection,
					output [3:0] FSM_OUT,
               output [11:0]  BallX, BallY, BallS,
				   output [11:0] ScrollXOut);
	 
    logic [11:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
//================================================
//Mario Floor Flags
//================================================
logic MarioGroundFlag;

logic MarioPipeFloorFlag;
logic MarioPipe2FloorFlag;

logic Block5FloorFlag;
logic Block2_1FloorFlag;
logic Block2_2FloorFlag;
logic Block4FloorFlag;
logic StairFloorFlag;

//================================================
	 

	logic MARIO_DIRECTION; //If 1'b1 move right, if 1'b0 move left
	logic MARIO_JUMP;
	logic [11:0] ScrollX;
	
	
	 //mario start coordinates
    parameter [11:0] Ball_X_Start = 32;  // Center position on the X axis
    parameter [11:0] Ball_Y_Start = 388;  // Center position on the Y axis
	 
    
	 //bounds of the screen
	 parameter [11:0] Ball_X_Min = 0;       // Leftmost point on the X axis
    logic [11:0] Ball_X_Max;     // Rightmost point on the X axis
	 
    parameter [11:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [11:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
	 

    assign Ball_Size = 32;

//===============================================================================================
//MARIO SCROLLING BOUNDS
//===============================================================================================
	always_comb begin
		if(marioBoundsFlag)
			Ball_X_Max = 10'd639;
		else
			Ball_X_Max = 10'd319;
	end
	
	always_ff @ (posedge frame_clk or posedge Reset) begin
		if (Reset)
			ScrollX<= 0;
		else begin
			//SCREEN SCROLLING LOGIC
			if((Ball_X_Pos + Ball_Size) >= Ball_X_Max && keycode == 8'h07 && PipeCollisionRight == 1'b0 && Brick1CollisionRight == 1'b0 && Pipe2CollisionRight == 1'b0 && StairCollisionRight == 1'b0)
				ScrollX <= ScrollX + 3;
			else
				ScrollX <= ScrollX;
		end
	end
//===============================================================================================
//END MARIO SCROLLING
//===============================================================================================



//===============================================================================================
//MARIO WALKING ANIMATION LOGIC
//===============================================================================================	 	
	//logic START_FSM;
	logic [9:0] COUNTER;
	
	always_ff @ (posedge frame_clk) begin
		if (COUNTER >= 1000) begin
			COUNTER <= 0;
		end
		else begin
			COUNTER <= COUNTER + 1;
		end
	end
		
	logic DIRECTION, SWITCH, LEFTFOOT, RIGHTFOOT;
	
	enum logic [3:0] {Idle,
							LeftFoot_Left,
							RightFoot_Left,
							Switch1_Left,
							Switch2_Left,
							LeftFoot_Right,
							RightFoot_Right,
							Switch1_Right,
							Switch2_Right} State, Next_State;
	
	always_ff @ (posedge frame_clk) begin
		if(Reset)
			State <= Idle;
		else begin
			if(COUNTER % 5 == 0)
				State <= Next_State;
			else
				State <= State;
		end
	end
	
	always_comb begin
		Next_State = State;
		DIRECTION = 1'b0;
		SWITCH = 1'b0;
		LEFTFOOT = 1'b0;
		RIGHTFOOT = 1'b0;
		
		unique case (State)
			
			Idle : begin
						if(MARIO_DIRECTION == 1'b0 && keycode == 8'h04)
							Next_State = LeftFoot_Left;
						else if(MARIO_DIRECTION == 1'b1 && keycode == 8'h07)
							Next_State = LeftFoot_Right;
					 end
					 
			LeftFoot_Left : begin
									if(keycode == 8'h04)
										Next_State = Switch1_Left;
									else
										Next_State = Idle;
								 end
			
			Switch1_Left : begin
									if(keycode == 8'h04)
										Next_State = RightFoot_Left;
									else
										Next_State = Idle;
								 end			
			
			RightFoot_Left : begin
									if(keycode == 8'h04)
										Next_State = Switch2_Left;
									else
										Next_State = Idle;
								 end

			Switch2_Left : begin
									if(keycode == 8'h04)
										Next_State = LeftFoot_Left;
									else
										Next_State = Idle;
								 end 

			LeftFoot_Right : begin
									if(keycode == 8'h07)
										Next_State = Switch1_Right;
									else
										Next_State = Idle;
								 end
			
			Switch1_Right : begin
									if(keycode == 8'h07)
										Next_State = RightFoot_Right;
									else
										Next_State = Idle;
								 end
			
			RightFoot_Right : begin
									if(keycode == 8'h07)
										Next_State = Switch2_Right;
									else
										Next_State = Idle;
								 end

			Switch2_Right : begin
									if(keycode == 8'h07)
										Next_State = LeftFoot_Right;
									else
										Next_State = Idle;
								 end
								 
			default : ;
		
		endcase
		
		case (State)
			Idle : begin
						DIRECTION = MARIO_DIRECTION;
						SWITCH = 1'b0;
						RIGHTFOOT = 1'b0;
						LEFTFOOT = 1'b0;
					end
					
			Switch1_Left : begin
						DIRECTION = 1'b0;
						SWITCH = 1'b1;
						RIGHTFOOT = 1'b0;
						LEFTFOOT = 1'b0;
					end
			
			Switch2_Left : begin
						DIRECTION = 1'b0;
						SWITCH = 1'b1;
						RIGHTFOOT = 1'b0;
						LEFTFOOT = 1'b0;
					end

			LeftFoot_Left : begin
						DIRECTION = 1'b0;
						SWITCH = 1'b0;
						RIGHTFOOT = 1'b0;
						LEFTFOOT = 1'b1;
					end

			RightFoot_Left : begin
						DIRECTION = 1'b1;
						SWITCH = 1'b0;
						RIGHTFOOT = 1'b0;
						LEFTFOOT = 1'b0;
					end
					
			Switch1_Right : begin
						DIRECTION = 1'b1;
						SWITCH = 1'b1;
						RIGHTFOOT = 1'b0;
						LEFTFOOT = 1'b0;
					end
					
			Switch2_Right : begin
						DIRECTION = 1'b1;
						SWITCH = 1'b1;
						RIGHTFOOT = 1'b0;
						LEFTFOOT = 1'b0;
					end

			RightFoot_Right : begin
						DIRECTION = 1'b1;
						SWITCH = 1'b0;
						RIGHTFOOT = 1'b1;
						LEFTFOOT = 1'b0;
					end	

			LeftFoot_Right : begin
						DIRECTION = 1'b1;
						SWITCH = 1'b0;
						RIGHTFOOT = 1'b0;
						LEFTFOOT = 1'b1;
					end				
		endcase
	end
	
	assign FSM_OUT = {DIRECTION, SWITCH, RIGHTFOOT, LEFTFOOT};
//============================================================================================
//END MARIO WALKING ANIMATION
//============================================================================================



//=============================================================================================
//COLLISION CALLS
//=============================================================================================

										 
//=============================================================================================
//END COLISION CALLS
//=============================================================================================






//============================================================================================
//MARIO JUMP ANIMATION LOGIC
//============================================================================================
	
	logic [11:0] VELOCITY;
	
	enum logic [5:0] {START,
							JUMP0,
							JUMP1,
							JUMPA,
							JUMP2,
							JUMP3,
							JUMP4,
							JUMP5,
							JUMP6,
							JUMP7,
							JUMP8,
							JUMP9,
							JUMP10,
							ARCTOP,
							FALL0,
							FALL1,
							FALL2,
							FALL3,
							FALL4,
							FALL5,
							FALL6,
							FALL7,
							FALL8,
							FALL9,
							FALL10,
							FALL11,
							FALL12,
							FALL13,
							FALL14,
							FALL15
							//HOLD
//							HOLD2,
							/*HOLD3*/} State1, Next_State1;
							
	always_ff @ (posedge frame_clk) begin
		if(Reset)
			State1 <= START;
			
		else begin
			if(COUNTER % 2 == 0 || PipeCollisionTop || MarioGroundFlag || Pipe2CollisionTop || 
			   Brick1CollisionTop || Brick2CollisionTop || Brick3CollisionTop || Brick4CollisionTop || StairCollisionTop)
				State1 <= Next_State1;
			else
				State1 <= State1;
		end
	end

	always_comb begin
		
		Next_State1 = START;	
		VELOCITY = 0;
		
//		if(PipeCollisionTop == 1'b1 && MarioPipeFloorFlag == 1'b1)
//			//Next_State1 = FALL0;
//			Next_State1 = HOLD;
	
		if ((PipeCollisionTop == 1'b0 && Pipe2CollisionTop == 1'b0 && MarioGroundFlag == 1'b0 && Brick1CollisionTop == 1'b0 && 
		    Brick2CollisionTop == 1'b0 && Brick3CollisionTop == 1'b0 && Brick4CollisionTop == 1'b0 && StairCollisionTop == 1'b0) || State1 == START) begin
			unique case (State1)
				START : begin
							if(keycode == 8'h1a || keycode1 == 8'h1a)
								Next_State1 = JUMP1;
								
							else if(MarioPipeFloorFlag == 1'b0 && MarioPipe2FloorFlag == 1'b0 && MarioGroundFlag == 1'b0 && Block5FloorFlag == 1'b0 
							        && Block2_1FloorFlag == 1'b0 && Block2_2FloorFlag == 1'b0 && Block4FloorFlag == 1'b0 && StairFloorFlag == 1'b0)
								Next_State1 = FALL1;
							
							else
								Next_State1 = START;
							end
							
				JUMP0 : Next_State1 = JUMP1;
				JUMP1 : Next_State1 = JUMPA;
				JUMPA : Next_State1 = JUMP2;
				JUMP2 : Next_State1 = JUMP3;
				JUMP3 : Next_State1 = JUMP4;
				JUMP4 : Next_State1 = JUMP5;
				JUMP5 : Next_State1 = JUMP6;
				JUMP6 : Next_State1 = JUMP7;
				JUMP7 : Next_State1 = JUMP8;
				JUMP8 : Next_State1 = JUMP9;
				JUMP9 : Next_State1 = JUMP10;
				JUMP10 : Next_State1 = ARCTOP;
				ARCTOP : Next_State1 = FALL0;
				FALL0 : Next_State1 = FALL1;
				FALL1 : Next_State1 = FALL2;
				FALL2 : Next_State1 = FALL3;
				FALL3 : Next_State1 = FALL4;
				FALL4 : Next_State1 = FALL5;
				FALL5 : Next_State1 = FALL6;
				FALL6 : Next_State1 = FALL7;
				FALL7 : Next_State1 = FALL8;
				FALL8 : Next_State1 = FALL9;
				FALL9 : Next_State1 = FALL10;
				FALL10 : Next_State1 = FALL11;
				FALL11 : Next_State1 = FALL12;
				FALL12 : Next_State1 = FALL13;
				FALL13 : Next_State1 = FALL14;
				FALL14 : Next_State1 = FALL15;				
				FALL15 : Next_State1 = START;
				
//				HOLD1 : Next_State1 = HOLD2;
//				HOLD2 : Next_State1 = HOLD3;
//				HOLD : begin
//							if((keycode == 8'h1a || keycode1 == 8'h1a))
//								Next_State1 = JUMP0;
//							else
//								Next_State1 = HOLD;
//							end				
			endcase

			
			case (State1)
				START : begin
							if(keycode == 8'h1a || keycode1 == 8'h1a)
								VELOCITY = -11;
							else if(MarioPipeFloorFlag == 1'b0 && MarioPipe2FloorFlag == 1'b0 && MarioGroundFlag == 1'b0 && Block5FloorFlag == 1'b0 && 
							        Block2_1FloorFlag == 1'b0 && Block2_2FloorFlag == 1'b0 && Block4FloorFlag == 1'b0 && StairFloorFlag == 1'b0)
								VELOCITY = 1;
							else
								VELOCITY = 0;
						  end
				JUMP0 : VELOCITY = -11; //-11
				JUMP1 : VELOCITY = -11; //-10
				JUMPA : VELOCITY = -10;
				JUMP2 : VELOCITY = -9;
				JUMP3 : VELOCITY = -8;
				JUMP4 : VELOCITY = -7;
				JUMP5 : VELOCITY = -6;
				JUMP6 : VELOCITY = -5;
				JUMP7 : VELOCITY = -4;
				JUMP8 : VELOCITY = -3;
				JUMP9 : VELOCITY = -2;
				JUMP10 : VELOCITY = -1;
				ARCTOP : VELOCITY = 0;
				FALL0 : VELOCITY = 1;
				FALL1 : VELOCITY = 2;
				FALL2 : VELOCITY = 3;
				FALL3 : VELOCITY = 4;
				FALL4 : VELOCITY = 5;
				FALL5 : VELOCITY = 6;
				FALL6 : VELOCITY = 7;
				FALL7 : VELOCITY = 8;
				FALL8 : VELOCITY = 9;
				FALL9 : VELOCITY = 10;
				FALL10 : VELOCITY = 11; //11
				FALL11 : VELOCITY = 11; //12
				FALL12 : VELOCITY = 12; //13
				FALL13 : VELOCITY = 12; //14
				FALL14 : VELOCITY = 13; //15
				FALL15 : VELOCITY = 13; //16
			endcase
		end
	end		
//============================================================================================
//END
//============================================================================================
	 
   
    always_ff @ (posedge Reset or posedge frame_clk ) begin
	 
        if (Reset) begin 
            Ball_Y_Motion <= 10'd0;
				Ball_X_Motion <= 10'd0;
				Ball_X_Pos <= Ball_X_Start;
				Ball_Y_Pos <= Ball_Y_Start;
				MARIO_DIRECTION <= 1'b1;
				MARIO_JUMP <= 1'b0;
        end
           
		  else begin  
				 if(playerflagtemp) begin
				 case (keycode)
                    8'h04 : begin
                                if(!((Ball_X_Pos - Ball_Size) <= Ball_X_Min) && (MarioFlag == 1'b0) && (Pipe2CollisionLeft == 1'b0) && 
											 (PipeCollisionLeft == 1'b0) && (Brick1CollisionLeft == 1'b0) && (Brick2CollisionLeft == 1'b0) && 
											 (Brick3CollisionLeft == 1'b0) && Brick4CollisionLeft == 1'b0 && StairCollisionLeft == 1'b0) 
										  begin
												MARIO_DIRECTION <= 0;
												Ball_X_Motion <= -3;
											end
											else begin
											 Ball_X_Motion <= 0;
											end
									end
                            
                    8'h07 : begin
                              if(!((Ball_X_Pos + Ball_Size) >= Ball_X_Max) && (MarioFlag == 1'b0) && (Pipe2CollisionRight == 1'b0) && 
										  (PipeCollisionRight == 1'b0) && (Brick1CollisionRight == 1'b0) && (Brick2CollisionRight == 1'b0) &&
										  (Brick3CollisionRight == 1'b0) && Brick4CollisionRight == 1'b0 && StairCollisionRight == 1'b0) 
										begin
												MARIO_DIRECTION <= 1;
												Ball_X_Motion <= 3;
											end
                              else begin
											Ball_X_Motion <= 0;
                              end 
                            end
////======================================================================
////TO DELETE							
//							8'h1a : begin
//									Ball_Y_Motion <= -3;
//									end
//							
//							8'h16 : begin
//										Ball_Y_Motion <= 3;
//									end
////======================================================================
							
							
					default: ;
					endcase
				end
				if(playerflagtemp)begin
						case(keycode1)
							  8'h04 : begin
											  if(!((Ball_X_Pos - Ball_Size) <= Ball_X_Min) && (MarioFlag == 1'b0) && (Pipe2CollisionLeft == 1'b0) && 
												 (PipeCollisionLeft == 1'b0) && (Brick1CollisionLeft == 1'b0) && (Brick2CollisionLeft == 1'b0) &&
												 (Brick3CollisionLeft == 1'b0) && Brick4CollisionLeft == 1'b0 && StairCollisionLeft == 1'b0) 
											  begin			
													MARIO_DIRECTION <= 0;
													Ball_X_Motion <= -3;
											  end
											  else begin 
													Ball_X_Motion <= 0;
											  end
											end
										 
							  8'h07 : begin
											 if(!((Ball_X_Pos + Ball_Size) >= Ball_X_Max) && (MarioFlag == 1'b0) && (Pipe2CollisionRight == 1'b0) && 
												(PipeCollisionRight == 1'b0) && (Brick1CollisionRight == 1'b0) && (Brick2CollisionRight == 1'b0) &&
												(Brick3CollisionRight == 1'b0) && Brick4CollisionRight == 1'b0 && StairCollisionRight == 1'b0) 
											 begin													
												MARIO_DIRECTION <= 1;
												Ball_X_Motion <= 3;
											end
											
											else begin
												Ball_X_Motion <= 0;
											end 
										 end
						default: ;
					endcase
				end		
			
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				 
//				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);//to delete
				 Ball_Y_Pos <= (Ball_Y_Pos + VELOCITY);
				 
				
				if(Ball_Y_Pos + Ball_Size >= 421)
						Ball_Y_Pos <= Ball_Y_Start;
				
				if(Ball_Y_Pos == Ball_Y_Start && (keycode != 8'h1a && keycode1 != 8'h1a))
					MarioGroundFlag = 1'b1;
				
				if(keycode == 8'h1a || keycode1 == 8'h1a)
					MarioGroundFlag = 1'b0;
				
				if(PipeCollisionTop)
					MarioPipeFloorFlag = 1'b1;
				else
					MarioPipeFloorFlag = 1'b0;
				
				if(Pipe2CollisionTop)
					MarioPipe2FloorFlag = 1'b1;
				else
					MarioPipe2FloorFlag = 1'b0;
				
				if(Brick1CollisionTop == 1'b1)
					Block5FloorFlag = 1'b1;
				else
					Block5FloorFlag = 1'b0;
					
				if(Brick2CollisionTop == 1'b1)
					Block2_1FloorFlag = 1'b1;
				else
					Block2_1FloorFlag = 1'b0;
					
				if(Brick3CollisionTop == 1'b1)
					Block2_2FloorFlag = 1'b1;
				else
					Block2_2FloorFlag = 1'b0;
				
				if(Brick4CollisionTop == 1'b1)
					Block4FloorFlag = 1'b1;
				else
					Block4FloorFlag = 1'b0;
				
				if(StairCollisionTop == 1'b1)
					StairFloorFlag = 1'b1;
				else
					StairFloorFlag = 1'b0;

				 
				if(Ball_Y_Motion != 0 || Ball_X_Motion != 0) begin
					Ball_X_Motion <= 0;
//					Ball_Y_Motion <= 0; // to delete
				end
		  end
    end
	 

    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
	 
	 assign ScrollXOut = ScrollX;

	 assign MarioDirection = MARIO_DIRECTION;
	 
	 assign VELOCITYOUT = VELOCITY;
	 
//	 assign MARIOFLAGTEST = mariocollides; //debug signal wiring
	 
	 assign JUMPTEST = State1;
	 
endmodule
