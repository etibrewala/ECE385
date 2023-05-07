module testbench();
    logic [9:0] SW;
    logic Clk, Run, Continue;
    logic [9:0] LED;
	 
    logic [6:0] HEX0, HEX1, HEX2, HEX3;
    logic [15:0] PC, IR, MAR, MDR;
	 
    slc3_testtop TEST(.*);

    //Zayd help
	 always begin
	 #1
    assign PC = TEST.slc.d0.PC_Out;
    assign IR = TEST.slc.d0.IR_Out;
    assign MAR = TEST.slc.d0.MAR_Out;
    assign MDR = TEST.slc.d0.MDR_Out; 
    end
	 //

    always begin : CLOCK_GENERATION 
        #1 Clk = ~Clk;
   end

    initial begin: CLOCK_INITIALIZATION 
        Clk = 0;
   end

    initial begin: TEST_VECTORS
    
	 //Reset
		  Run = 1;
        Continue = 1;
		  #2
		  
		  Run = 0;
		  Continue = 0;
        #2
        
		  Run = 1;
        Continue = 1;
        
	//Set and run
		  #4
		  SW = 10'b0000110001;
		  
		  #2
        Run = 0;
        #2 
		  Run = 1;
		  
		  #100
		  SW = 10'b0000000011;
		 
		  #100		  
		  Continue = 0;
		  #2
		  Continue = 1;

		  #50
		  SW = 10'b0000000011;
		  
		  #100
		  Continue = 0;
		  #2
		  Continue = 1;


     
    end


endmodule
