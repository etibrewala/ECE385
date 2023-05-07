//module player_fsm(
//    input logic Clk, Reset,
//    input logic [7:0] Keycode,
//    input logic [9:0] y_position,
//    // input logic onTopBlockFlag,
//    //             hitBotBlockFlag,
//
//    output logic [9:0] y_movement
//);																																																																																																																																																																																																																																																																												
// 
//    enum logic [2:0] {
//        IDLE,
//        JUMP_UP,
//		  WHILE_JUMP,
//        FALL_DOWN
//    } state,Next_state;
//
//    logic[9:0] y_motion;
//	 
//	 parameter [9:0] JUMP_VELOCITY = -22; //10'b1111101010;
//	 parameter [9:0] GRAVITY = 2;
//	 
////		logic[9:0] JUMP_VELOCITY = 10'b1111101010; //how to make this negative in actual code
////    logic[2:0] GRAVITY = 2'b10; //keep this positive
//
////22->20->18->16->14->12->10->8->6->4->2->0  (we jumped 132 pixels then we keep decrementing until we fall)
// 
//
//    always_ff @ (posedge Clk) begin
//		if(Reset)
//			state <= IDLE;
//		else
//			state <= Next_state;
//	 end
//	 
//	 always_comb begin
//		Next_state = state;
//		y_motion = 0;
//		
//		unique case (state)
//			IDLE : begin
//				if(Keycode == 8'h1a) 
//					Next_state = JUMP_UP;
////				else
////					Next_state = IDLE;
//			end
//			
//			JUMP_UP : begin
//					Next_state = WHILE_JUMP;
////				else
////					Next_state = JUMP_UP;
//			end
//			
//			WHILE_JUMP : begin
//				if(y_motion == 0)
//					Next_state = FALL_DOWN;
//			end
//			
//			FALL_DOWN : begin
//				if (y_position <= 10'd384)
//					Next_state = IDLE;
////				else
////					Next_state = FALL_DOWN;
//			end
//			
//			default : ;
//		endcase
//		
//		case(state)
//			IDLE : begin
//				y_motion = 0;
//			end
//			
//			JUMP_UP : begin
//				y_motion = JUMP_VELOCITY;
//			end
//			
//			WHILE_JUMP : begin
//				y_motion = y_motion + GRAVITY;
//			end
//			
//			FALL_DOWN : begin
//				y_motion = y_motion + GRAVITY;
//			end
//		endcase
//	end
//	
//	assign y_movement = y_motion;
//				
//		
//		
//	 
//	 
////	 // Define the FSM states and transitions
////    always_ff @(posedge Clk/*, posedge Reset*/) begin
////        if (Reset) begin
////            state <= IDLE;
////            y_motion <= 0;
////        end  
////        else begin
////            state <= Next_state;
////				
////			  unique case (state)
////						 IDLE: begin
////							 // if(y_position != 448 & y_motion == 0 & onTopBlockFlag == 0)begin
////						// 	Next_state = FALL_DOWN
////						// end else begin
////						
////								if (Keycode == 8'h1A && y_position == 10'd384) begin
////											Next_state <= JUMP_UP;
////											y_motion <= JUMP_VELOCITY;
////								end
////								else begin									
////											Next_state <= IDLE;
////											y_motion <= 0;
////								end
////							end
////						// end
////						 JUMP_UP: begin
////						 //   if(hitBotBlockFlag == 0) begin
////								 if (y_motion == 0) begin
////									  Next_state <= FALL_DOWN;
////								 end
////								 else begin
////									  Next_state <= JUMP_UP;
////									  y_motion <= y_motion + JUMP_VELOCITY;
////								 end
////							end
////						 //   end
////						 //   else begin
////						 //       y_motion <= 0;
////						 //       Next_state = FALL_DOWN;
////						 //   end
////						 FALL_DOWN: begin
////						 //   if(onTopBlockFlag== 0) begin //If not on top of block
////								 if (y_position == 10'd384) begin // back on da floor
////									  Next_state <= IDLE;
////									  y_motion <= 0;
////								 end
////								 else begin
////									  Next_state <= FALL_DOWN;
////									  y_motion <= y_motion + JUMP_VELOCITY;
////								 end
////							 end
////						 //   end 
////						 //   else begin
////					// 		Next_state = FALL_DOWN;
////						 //    		y_motion <= 0;
////						 //   end
////
////					endcase
////					
////					JUMP_VELOCITY <= JUMP_VELOCITY + GRAVITY;
////        end
////    end
////	 
////	 assign y_movement = y_motion;
//	 
//endmodule
//
//
//enum logic [4:0] {START,
//						JUMP0,
//						JUMP1,
//						JUMP2,
//						JUMP3,
//						JUMP4,
//						JUMP5,
//						JUMP6,
//						JUMP7,
//						JUMP8,
//						JUMP9,
//						JUMP10,
//						ARCTOP,
//						FALL0,
//						FALL1,
//						FALL2,
//						FALL3,
//						FALL4,
//						FALL5,
//						FALL6,
//						FALL7,
//						FALL8,
//						FALL9,
//						FALL10}State, Next_State;
//						
//always_ff @ (posedge Clk) begin
//	if(Reset)
//		State <= Start;
//	else
//		State <= Next_State;
//end
//
//always_comb begin
//	Next_State = State;
//	
//	unique case (State)
//		START : Next_State = JUMP0;
//		JUMP0 : Next_State = JUMP1;
//		JUMP1 : Next_State = JUMP2;
//		JUMP2 : Next_State = JUMP3;
//		JUMP3 : Next_State = JUMP4;
//		JUMP4 : Next_State = JUMP5;
//		JUMP5 : Next_State = JUMP6;
//		JUMP6 : Next_State = JUMP7;
//		JUMP7 : Next_State = JUMP8;
//		JUMP8 : Next_State = JUMP9;
//		JUMP9 : Next_State = JUMP10;
//		JUMP10 : Next_State = ARCTOP;
//		ARCTOP : Next_State = FALL0;
//		FALL0 : Next_State = FALL1;
//		FALL1 : Next_State = FALL2;
//		FALL2 : Next_State = FALL3;
//		FALL3 : Next_State = FALL4;
//		FALL4 : Next_State = FALL5;
//		FALL5 : Next_State = FALL6;
//		FALL6 : Next_State = FALL7;
//		FALL7 : Next_State = FALL8;
//		FALL8 : Next_State = FALL9;
//		FALL9 : Next_State = FALL10;
//		FALL10 : Next_State = Start;
//	endcase
//	
//	case (State)
//		START : VELOCITY = 0;
//		JUMP0 : VELOCITY = -22;
//		JUMP1 : VELOCITY = -20;
//		JUMP2 : VELOCITY = -18;
//		JUMP3 : VELOCITY = -16;
//		JUMP4 : VELOCITY = -14;
//		JUMP5 : VELOCITY = -12;
//		JUMP6 : VELOCITY = -10;
//		JUMP7 : VELOCITY = -8;
//		JUMP8 : VELOCITY = -6;
//		JUMP9 : VELOCITY = -4;
//		JUMP10 : VELOCITY = -2;
//		ARCTOP : VELOCITY = 0;
//		FALL0 : VELOCITY = 2;
//		FALL1 : VELOCITY = 4;
//		FALL2 : VELOCITY = 6;
//		FALL3 : VELOCITY = 8;
//		FALL4 : VELOCITY = 10;
//		FALL5 : VELOCITY = 12;
//		FALL6 : VELOCITY = 14;
//		FALL7 : VELOCITY = 16;
//		FALL8 : VELOCITY = 18;
//		FALL9 : VELOCITY = 20;
//		FALL10 : VELOCITY = 22;
//	endcase
//end
//		
					
