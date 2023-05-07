module testbench();

timeunit 10ns;
timeprecision 1ns;


logic Clk;

logic Reset_Clear, Run_Accumulate; 

logic[9:0]SW;

logic[16:0] Out;

logic[9:0]LED;

logic[15:0] S;

logic[6:0] HEX0, 
				HEX1, 
				HEX2, 	
				HEX3, 	
				HEX4,
				HEX5;
				
	
logic [15:0] A, B;
logic cin, cout;
		
lookahead_adder ADDER1(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program


initial begin: TEST_VECTORS
//Reset_Clear = 1;
//Run_Accumulate = 1;
//
//
//#2 Reset_Clear = 0;
//#2 Reset_Clear = 1;
//
//#2 SW = 10'b0000000001;
//#2 Run_Accumulate = 0;
//#2 Run_Accumulate = 1;
//
//#10 Reset_Clear = 0;
//#2 Reset_Clear = 1;
//
//#2 SW =10'b0000000010;
//#2 Run_Accumulate = 0;
//#2 Run_Accumulate = 1;


A = 16'h0001;
B = 16'h0012;
cin=0;


end

endmodule

