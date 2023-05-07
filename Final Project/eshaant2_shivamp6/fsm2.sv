module health(input logic Clk,
						input logic Reset,
						input logic collisionFlag,
						output logic [1:0] health);

enum logic [3:0] {Halted,
						Health3,
						Health2,
						Health1,
						Health0,
						WaitState3,
						WaitState2,
						WaitState1}State,Next_state;
always_ff @(posedge Clk or posedge Reset) begin
	if(Reset)
		State <= Halted;
	else begin
		State <= Next_state;
	end
	
end

always_comb begin
	Next_state = State;
	health = 2'b11;
	
	unique case (State)
		Halted: Next_state = Health3;
		Health3: 
			if(collisionFlag) begin
				Next_state = WaitState3;
			end else begin
				Next_state = Health3;
			end
		
		WaitState3:begin
			if(collisionFlag)
				Next_state = WaitState3;
			else
				Next_state = Health2;
		end
		
		Health2:begin
			if(collisionFlag)
				Next_state = WaitState2;
			else
				Next_state = Health2;
		end
		
		WaitState2:begin
			if(collisionFlag)
				Next_state = WaitState2;
			else
				Next_state = Health1;
		end
		
		Health1:begin
			if(collisionFlag)
				Next_state = WaitState1;
			else
				Next_state = Health1;
		end
		
		WaitState1:begin
			if(collisionFlag)
				Next_state = WaitState1;
			else
				Next_state = Health0;
		end
		
		Health0 : ;
		
		default : ;
	endcase
	
	case(State)
		Halted 		:
		Health3		: health = 2'b11;
		WaitState3	: health = 2'b10;
		Health2		: health = 2'b10;
		WaitState2	: health = 2'b01;
		Health1		: health = 2'b01;
		WaitState1	: health = 2'b00;
		Health0		: begin
			health = 2'b00;
		end
	endcase	
end

endmodule 