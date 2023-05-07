module driver_mux(input logic [3:0] BUS_MUX,
						input logic [15:0] PC_Out, MDR_Out, ALU_Out, ADDR_Out,
						output logic [15:0] BUS);
						
						always_comb
							begin
							unique case(BUS_MUX)
								4'b1000 : BUS = PC_Out;
								4'b0100 : BUS = MDR_Out;
								4'b0010 : BUS = ALU_Out;
								4'b0001 : BUS = ADDR_Out;
								default : BUS = {16{1'bx}};
							endcase
							end
						
endmodule


module two_one_16(input logic sel,
					input logic [15:0] data0, data1,
					output logic [15:0] muxOut);
					
					always_comb
						begin
						unique case(sel)
							1'b0 : muxOut = data0;
							1'b1 : muxOut = data1;
							default : muxOut = {16{1'bx}};
						endcase
					end
							
endmodule

module pc_mux(input logic [1:0] PC_select,
				  input logic [15:0] BUS, PC, ADDR,
				  output logic [15:0] mux_out);
				  
				  always_comb
						begin
						unique case(PC_select)
							2'b00 : mux_out = PC + 1; //when 0 PC+1
							2'b10 : mux_out = BUS; //when 1 BUS
							2'b11 : mux_out = ADDR; //when 2 ADDR
							default: mux_out = {16{1'bx}};
						endcase
					end

endmodule

module two_one_3(input logic sel,
					input logic [2:0] data0, data1,
					output logic [2:0] muxOut);
					
						always_comb
						begin
						unique case(sel)
							1'b0 : muxOut = data0;
							1'b1 : muxOut = data1;
							default: muxOut = 'x;
						endcase
					end
					
endmodule

