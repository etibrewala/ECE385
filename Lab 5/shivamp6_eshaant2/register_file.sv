module register_file(input Clk, Reset, LD_REG,
							input [15:0] BUS,
							input [2:0] DRMUX_out, SR1MUX_out, SR2,
							output logic [15:0] SR1_Out, SR2_Out);
							
							logic[15:0] R0_wire, R1_wire, R2_wire, R3_wire, R4_wire, R5_wire, R6_wire, R7_wire;
							
							logic LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7;
							
							sixteen_reg R0(.Clk(Clk), .Reset(Reset), .Load(LD0), .Data_In(BUS), .Data_Out(R0_wire));
							sixteen_reg R1(.Clk(Clk), .Reset(Reset), .Load(LD1), .Data_In(BUS), .Data_Out(R1_wire));
							sixteen_reg R2(.Clk(Clk), .Reset(Reset), .Load(LD2), .Data_In(BUS), .Data_Out(R2_wire));
							sixteen_reg R3(.Clk(Clk), .Reset(Reset), .Load(LD3), .Data_In(BUS), .Data_Out(R3_wire));
							sixteen_reg R4(.Clk(Clk), .Reset(Reset), .Load(LD4), .Data_In(BUS), .Data_Out(R4_wire));
							sixteen_reg R5(.Clk(Clk), .Reset(Reset), .Load(LD5), .Data_In(BUS), .Data_Out(R5_wire));
							sixteen_reg R6(.Clk(Clk), .Reset(Reset), .Load(LD6), .Data_In(BUS), .Data_Out(R6_wire));
							sixteen_reg R7(.Clk(Clk), .Reset(Reset), .Load(LD7), .Data_In(BUS), .Data_Out(R7_wire));
							
							always_comb begin
								LD0 = 1'b0;
								LD1 = 1'b0;
								LD2 = 1'b0;
								LD3 = 1'b0;
								LD4 = 1'b0;
								LD5 = 1'b0;
								LD6 = 1'b0;
								LD7 = 1'b0;
								SR1_Out = {16{1'b0}};
								SR2_Out = {16{1'b0}};
							
							if (LD_REG) begin
								case (DRMUX_out)
									3'b000 : LD0 = 1'b1;  
									3'b001 : LD1 = 1'b1;
									3'b010 : LD2 = 1'b1;
									3'b011 : LD3 = 1'b1;
									3'b100 : LD4 = 1'b1;
									3'b101 : LD5 = 1'b1;
									3'b110 : LD6 = 1'b1;
									3'b111 : LD7 = 1'b1;
									default : ;
								endcase
							end
								
								case(SR1MUX_out)
									3'b000 : SR1_Out = R0_wire;
									3'b001 : SR1_Out = R1_wire;
									3'b010 : SR1_Out = R2_wire;
									3'b011 : SR1_Out = R3_wire;
									3'b100 : SR1_Out = R4_wire;
									3'b101 : SR1_Out = R5_wire;
									3'b110 : SR1_Out = R6_wire;
									3'b111 : SR1_Out = R7_wire;
									default : ;
								endcase
								
								unique case(SR2)
									3'b000 : SR2_Out = R0_wire;
									3'b001 : SR2_Out = R1_wire;
									3'b010 : SR2_Out = R2_wire;
									3'b011 : SR2_Out = R3_wire;
									3'b100 : SR2_Out = R4_wire;
									3'b101 : SR2_Out = R5_wire;
									3'b110 : SR2_Out = R6_wire;
									3'b111 : SR2_Out = R7_wire;
									default : ;
								endcase
						end
endmodule
