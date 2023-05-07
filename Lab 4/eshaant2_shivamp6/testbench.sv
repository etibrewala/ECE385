module testbench();

timeunit 10ns;

timeprecision 1ns;

logic Clk;
logic ClrA_LdB, Execute;
logic Xval;
logic LoadB_Debug;
logic [7:0] SW;
logic [7:0] Aval,
		 		Bval;
logic [6:0] HEX0, HEX1, HEX2, HEX3;

integer ErrorCnt = 0;


multiplier multiplierTest(.*);


always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end


initial begin: TEST_VECTORS
ClrA_LdB = 1;
Execute = 1;


//SW = 8'b00000111; //7
//SW = 8'b11111001; //-7
//SW = 8'b00111011; //59
//SW = 8'b11000101; //-59
//============================================



// 7 * 59 = 413 -> 00000001 10011101

//#10 SW = 8'b00000111;
//
//#5 ClrA_LdB = 0;
//#5 ClrA_LdB = 1;
//
//#10 SW = 8'b00111011;
//
//#10 Execute = 0;
//#20 Execute = 1;
//
//
//#20
//if(Aval != 8'b00000001)
//	begin
//	ErrorCnt++;
//	$display("Aval for 7*59 is wrong");
//	end
//#20
//if(Bval != 8'b10011101)
//	begin
//	ErrorCnt++;
//	$display("Bval for 7*59 is wrong");
//	end
////============================================
//
//// -7 * 59 = -413 -> 11111110 01100011
//	
//#10 SW = 8'b11111001;
//
//#5 ClrA_LdB = 0;
//#5 ClrA_LdB = 1;
//
//#10 SW = 8'b00111011;
//
//#10 Execute = 0;
//#20 Execute = 1;
//
//#20
//if(Aval != 8'b11111110)
//	begin
//	ErrorCnt++;
//	$display("Aval for -7*59 is wrong");
//	end
//#20
//if(Bval != 8'b01100011)
//	begin
//	ErrorCnt++;
//	$display("Bval for -7*59 is wrong");
//	end
	
//============================================

// 7 * -59 = -413 -> 11111110 01100011

//#10 SW = 8'b00000111;
//
//#5 ClrA_LdB = 0;
//#5 ClrA_LdB = 1;
//
//#10 SW = 8'b11000101;
//#10 Execute = 0;
//#20 Execute = 1;
//
//#20
//if(Aval != 8'b11111110)
//	begin
//	ErrorCnt++;
//	$display("Aval for 7*-59 is wrong");
//	end
//
//#20
//if(Bval != 8'b01100011)
//	begin
//	ErrorCnt++;
//	$display("Bval for 7*-59 is wrong");
//	end
//=============================================

// 4 * 3 = 12 * 3 -> 00000000 00100100

#10 SW = 8'b00000100;

#5 ClrA_LdB = 0;
#5 ClrA_LdB = 1;

#10 SW = 8'b00000010;

#10 Execute = 0;
#20 Execute = 1;

#10 SW = 8'b00000010;

#10 Execute = 0;
#20 Execute = 1;

#20
if(Aval != 8'b00000000)
	begin
	ErrorCnt++;
	$display("Aval for 4*3*3 is wrong");
	end
	
#20
if(Bval != 8'b00100100)
	begin
	ErrorCnt++;
	$display("Bval for 4*3*3 is wrong");
	end


//===============================================

//Printing error count or success

if(ErrorCnt == 0)
$display("No errors!");

else
$display("%d errors(s) detected. Go back to lecture ", ErrorCnt);

end
endmodule

//===============================================