module coinAnimation(input Reset, frame_clk, output [1:0] COINSIGNAL);

logic [1:0] coinAnimation;

logic [4:0] COUNTER;

	 always_ff @ (posedge frame_clk) begin
		if(COUNTER == 30)
			COUNTER <= 0;
		else
			COUNTER <= (COUNTER + 1);
	 end
	 
	 always_ff @ (posedge frame_clk) begin
		if(COUNTER % 15 == 0)
			coinAnimation <= coinAnimation + 1;
		else
			coinAnimation <= coinAnimation;
	 end
	 
assign COINSIGNAL = coinAnimation;

endmodule
