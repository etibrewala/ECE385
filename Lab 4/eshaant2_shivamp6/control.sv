module control(input logic Clk, Execute, ClearA_LoadB, M,
					output logic Shift_En, Add, Sub, ClearA, LoadB);
					
					enum logic [4:0] {add0, sh0,
											add1, sh1,
											add2, sh2,
											add3, sh3,
											add4, sh4,
											add5, sh5,
											add6, sh6,
											sub7, sh7,
											start, hold,extra} //control states
											curr_state, next_state;
					
					//updates flip flop, current state is the only one
					always_ff @ (posedge Clk)  
					
					begin
						if (ClearA_LoadB)
							curr_state <= start;
						else
							curr_state <= next_state;
					end
					
				
					always_comb
					begin
						next_state = curr_state;
						
						unique case (curr_state)
							
							start: if(Execute)
								next_state = extra;
								
							extra: next_state = add0;
							
							add0: next_state = sh0;
							
							sh0: next_state = add1;
							
							add1: next_state = sh1;
							
							sh1: next_state = add2;
							
							add2: next_state = sh2;
							
							sh2: next_state = add3;
							
							add3: next_state = sh3;
							
							sh3: next_state = add4;
							
							add4: next_state = sh4;
							
							sh4: next_state = add5;
							
							add5: next_state = sh5;
							
							sh5: next_state = add6;
							
							add6: next_state = sh6;
							
							sh6: next_state = sub7;
							
							sub7: next_state = sh7;
							
							sh7: next_state = hold;
							
							hold: if(~Execute)
										next_state = start;		
							
					endcase
					
					case (curr_state)
						
						start:
						begin
							ClearA = 1'b0;
							LoadB = ClearA_LoadB;
							Add = 1'b0;
							Sub = 1'b0;
							Shift_En = 1'b0;
						end
						
						add0,
						add1,
						add2,
						add3,
						add4,
						add5,
						add6:
							begin
								if(M)
									Add = 1'b1;
								else
									Add = 1'b0;
									
								Sub = 1'b0;
								Shift_En = 1'b0;
								ClearA = 1'b0;
								LoadB = 1'b0;
							end
						
						
						sub7:
						begin
							if(M)
								Sub = 1'b1;
							else
								Sub = 1'b0;
							
							Add = 1'b0;
							Shift_En = 1'b0;
							ClearA = 1'b0;
							LoadB = 1'b0;
						end
							
							
						default:
						begin
							Add = 1'b0;
							Sub = 1'b0;
							Shift_En = 1'b1;
							ClearA = 1'b0;
							LoadB = 1'b0;
						end
						
						hold:
						begin
							ClearA = 1'b0;
							LoadB = 1'b0;
							Add = 1'b0;
							Sub = 1'b0;
							Shift_En = 1'b0;
						end
						
						extra: 
						begin
							ClearA = 1'b1;
							LoadB = 1'b0;
							Add = 1'b0;
							Sub =1'b0;
							Shift_En = 1'b0;
							
						end
					endcase
				end
endmodule
							
							
						