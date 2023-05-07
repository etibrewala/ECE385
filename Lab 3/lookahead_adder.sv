module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic[3:0] PG,GG;
	  logic c1,c2,c3;
	  
	  carry_lookahead CLA1(.A(A[3:0]), .B(B[3:0]), .cin(cin), .PG(PG[0]), .GG(GG[0]), .S(S[3:0]));
	  assign c1 = GG[0] | (cin & PG[0]);
	  
	  carry_lookahead CLA2(.A(A[7:4]), .B(B[7:4]), .cin(c1), .PG(PG[1]), .GG(GG[1]), .S(S[7:4]));
	  assign c2 = GG[1] | (GG[0] & PG[1]) | (cin & PG[0] & PG[1]);
	  
	  carry_lookahead CLA3(.A(A[11:8]), .B(B[11:8]), .cin(c2), .PG(PG[2]), .GG(GG[2]), .S(S[11:8]));
	  assign c3 = GG[2] | (GG[1] & PG[2]) | (GG[0] & PG[1] & PG[2]) | (cin & PG[0] & PG[1] & PG[2]);
	  
	  carry_lookahead CLA4(.A(A[15:12]), .B(B[15:12]), .cin(c3), .PG(PG[3]), .GG(GG[3]), .S(S[15:12]));
	  assign cout = GG[3] | (GG[2] & PG[3]) | (GG[0] & PG[1] & PG[2] & PG[3]) | 
						(cin & PG[0] & PG[1] & PG[2] & PG[3]);
	  
	  

endmodule

module carry_lookahead(input[3:0] A, B, input cin, output PG, GG, output[3:0] S);
	
	logic[3:0] P,G,c;
	
	assign P = A ^ B;
	assign G = A & B;	
		
	
	assign PG = P[0] & P[1] & P[2] & P[3];
	assign GG = G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1]);
	
	assign c[0]=cin;
	assign c[1]=(cin & P[0]) | G[0];
	assign c[2]=(cin & P[0] & P[1]) | (G[0] & P[1]) | G[1];
	assign c[3]=(cin & P[0] & P[1] & P[2]) | (G[0] & P[1] & P[2]) | (G[1] & P[2]) | G[2];
	
	
	assign S = P ^ c;

endmodule
	
