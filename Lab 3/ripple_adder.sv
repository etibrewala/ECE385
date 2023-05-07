module ripple_adder
(
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	
	logic [15:0] c;
	full_adder FA1(.A(A[0]), .B(B[0]), .cin(cin), .S(S[0]), .cout(c[0]));
	full_adder FA16(.A(A[15]), .B(B[15]), .cin(c[14]), .cout(cout), .S(S[15]));
	
	genvar i;
	
	generate
	
		for(i=1; i < 15; i++) begin: adder
			full_adder FA_loop(.A(A[i]), .B(B[i]), .cin(c[i-1]), .S(S[i]), .cout(c[i]));
		end
		
	endgenerate
	  
endmodule

module full_adder (input A, B, cin, output S, cout);
 
	assign S = A ^ B ^ cin;
	assign cout = (A&B)|(B&cin)|(A&cin);

endmodule
