module game(input logic Clk,
                        input logic Reset,
                        input logic collisionFlag,
								input [7:0]keycode,
								input logic [11:0]ballX,
								input logic [11:0]scrollX,
								input logic [1:0] healthbar,
                        output logic gameOver, playerFlag);

enum logic [3:0] {Start, Game,
                        over}State,Next_state;
                        
always_ff @(posedge Clk or posedge Reset) begin
    if(Reset)
        State <= Start;
    else begin
        State <= Next_state;
    end
    
end

always_comb begin
    Next_state = State;
    
    unique case (State)
		Start: if(keycode == 8'h2C)begin
				Next_state = Game;
end            
		Game: if(collisionFlag || (ballX > 2200-scrollX))begin
                    Next_state = over;
            end
            over: if(Reset)
                            Next_state = Game;
    endcase
    case (State)
		Start: begin gameOver = 1'b0;
				playerFlag = 1'b0;  
		end	
		Game:begin gameOver = 1'b0;
				playerFlag = 1'b1;
         end   
      over: begin gameOver = 1'b1;
				    playerFlag = 1'b0;
            end
            default: begin gameOver = 1'b0;
				    playerFlag = 1'b0;
					 end
    endcase
end
endmodule 