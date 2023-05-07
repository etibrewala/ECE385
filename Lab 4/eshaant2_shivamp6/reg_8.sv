module reg_8(input logic Clk, Reset, Shift_In, Load, Shift_En,
					input logic [7:0] Data,
					output logic Shift_Out,
					output logic [7:0] Data_Out);
					
	always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 8'h0;
		 else if (Load)
			  Data_Out <= Data;
		 else if (Shift_En)
		 begin
			  //concatenate shifted in data to the previous left-most 7 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= { Shift_In, Data_Out[7:1] }; 	
	    end
    end
	
    assign Shift_Out = Data_Out[0];

endmodule



//module reg_1(input logic Clk, Reset, Shift_In, Load, Shift_En,
//					input logic Data,
//					output logic Shift_Out,
//					output logic Data_Out);
//					
//	always_ff @ (posedge Clk)
//    begin
//	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
//			  Data_Out <= 8'h0;
//		 else if (Load)
//			  Data_Out <= Data;
//		 else if (Shift_En)
//		 begin
//			  //concatenate shifted in data to the previous left-most 7 bits
//			  //note this works because we are in always_ff procedure block
//			  Data_Out <= { Shift_In, Data_Out[7:1] }; 	
//	    end
//    end
//	
//    assign Shift_Out = Data_Out;
//
//endmodule

//make a one bit register with Data_out_X
//instantiate it where you instantiate all your other registers (in register unit)
//When you call it in register_unit, the 
