module sixteen_reg(input Clk, Reset, Load,
						  input [15:0] Data_In,
						  output logic [15:0] Data_Out);
						  
						  always_ff @ (posedge Clk)
						  begin
						  if(Reset)
								Data_Out <= {16{1'b0}};
						  else if (Load)
								Data_Out <= Data_In;
						  end

endmodule

module ten_reg(input Clk, Reset, Load,
						  input [9:0] Data_In,
						  output logic [9:0] Data_Out);
						  
						  always_ff @ (posedge Clk)
						  begin
						  if(Reset)
								Data_Out <= {9{1'b0}};
						  else if (Load)
								Data_Out <= Data_In;
						  end

endmodule

module nzp(input Clk, Reset, LD_CC,
			  input [15:0] BUS,
			  output logic [2:0] Data_Out);
			  
			  
			  logic [2:0] logic_out, NZP_OUT;
			  
			  always_comb begin
			  if(BUS == 16'b0)
				logic_out = 3'b010;
			  else if(BUS[15] == 1'b1)
				logic_out = 3'b100;
			  else
				logic_out = 3'b001;
			  end
			  
			  three_reg NZP(.Clk(Clk), .Reset(1'b0), .LD_CC(LD_CC),
							.Data_In(logic_out), .Data_Out(NZP_OUT));
							
			
				assign Data_Out = NZP_OUT;

							
endmodule



module three_reg(input Clk, Reset, LD_CC,
						input [2:0] Data_In,
						output logic [2:0] Data_Out);
				
	
	
	always_ff @ (posedge Clk)
	 begin
		if(Reset)
			Data_Out <= 3'b000;
		else if(LD_CC)
			Data_Out <= Data_In;
	end
											
						
endmodule



module ben(input Clk, Reset, LD_BEN,
			  input Data_In,
			  output logic Data_Out);
	
	always_ff @ (posedge Clk)
	 begin
		if(Reset)
			Data_Out <= 1'b0;
		else if(LD_BEN)
			Data_Out <= Data_In;
	end
	
endmodule


				