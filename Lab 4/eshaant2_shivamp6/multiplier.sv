//top-level module for Lab 4
module multiplier(input logic Clk, ClrA_LdB, Execute,
										
				   input logic [7:0] SW,	//Switches
					output logic[7:0] Aval, 
											Bval,
					output logic Xval,
					output logic LoadB_Debug,
					output logic [6:0] HEX0, HEX1, HEX2, HEX3);

	 logic Execute_SH, Reset_SH; 
	 logic opA, opB, Shift_En, Add, Sub, Q;
	 
	 logic[7:0] A,B,SW_S;
	 logic ClearA, LoadB;
	 logic X;
	 logic Xvalue;
	 logic [8:0] sum;
	 
	 assign Aval = A;
	 assign Bval = B;
	 assign Xval = X;
	 
	 //Xval is bring assigned a 
	 
	 reg_8 regA(.Clk(Clk), .Reset(ClearA), .Load(Add | Sub), .Shift_In(Q), .Shift_En(Shift_En), .Data(sum[7:0]), .Shift_Out(opA), .Data_Out(A));
	 
	 reg_8 regB(.Clk(Clk), .Reset(1'b0), .Load(LoadB), .Shift_In(opA), .Shift_En(Shift_En), .Data(SW), .Shift_Out(opB), .Data_Out(B));
	 
	 add_sub9 ADD(.fn(Sub), .A(A), .B(SW), .S(sum), .Xvalue(X));
	 
	 control control_unit(.Clk(Clk), .Execute(Execute_SH), .ClearA_LoadB(Reset_SH), 
									.M(B[0]), .ClearA(ClearA), .LoadB(LoadB), .Shift_En(Shift_En), .Add(Add), .Sub(Sub));
	 

	  
	 
	 
	 
////	 //flip-flop for X bit
	always_ff @ (posedge Clk)
	 begin
		if(ClearA)
			Q <= 1'b0;
		else
			Q <= X;
	end

	 
	 
	 HexDriver        HexAL (
                        .In0(B[3:0]),
                        .Out0(HEX0) );
	 HexDriver        HexBL (
                        .In0(B[7:4]),
                        .Out0(HEX1) );   
								
	 HexDriver        HexAU (
                        .In0(A[3:0]),
                       .Out0(HEX2) );	
	 HexDriver        HexBU (
                       .In0(A[7:4]),
                        .Out0(HEX3) );
								
	  
	  sync button_sync[1:0] (Clk, {~ClrA_LdB, ~Execute}, {Reset_SH, Execute_SH});
	  sync Din_sync[7:0] (Clk, SW, SW_S);
	  
endmodule

					
					
					
					