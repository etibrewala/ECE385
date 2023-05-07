module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a CSA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic c1,
				c2,c3,
				c4, c5,
				c6, c7;
	  logic cout1,
				cout2,
				cout3;
	  logic [3:0] tempSum, tempSum2,
						tempSum3, tempSum4,
						tempSum5, tempSum6;
	  
	  carry_ripple CSA1(.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(S[3:0]), .cout(c1));
	  
	  //bits [7:4] CSA
	  carry_ripple CSA2(.A(A[7:4]), .B(B[7:4]), .cin(1'b0), .S(tempSum), .cout(c2));
	  carry_ripple CSA3(.A(A[7:4]), .B(B[7:4]), .cin(1'b1), .S(tempSum2), .cout(c3));
	  assign cout1 = (c1 & c3 | c2);
	  
	  always_comb begin
	  if(c1==1'b0)
			S[7:4] = tempSum;
	  else
			S[7:4] = tempSum2;
	  end
	  
	  //bits [11:8] CSA
	  carry_ripple CSA4(.A(A[11:8]), .B(B[11:8]), .cin(1'b0), .S(tempSum3), .cout(c4));
	  carry_ripple CSA5(.A(A[11:8]), .B(B[11:8]), .cin(1'b1), .S(tempSum4), .cout(c5));
	  assign cout2 = (cout1 & c5 | c4);
	  
	  always_comb begin
	  if(cout1==1'b0)
			S[11:8] = tempSum3;
	  else
			S[11:8] = tempSum4;
	  end
	  
	  //bits [15:12] CSA
	  carry_ripple CSA6(.A(A[15:12]), .B(B[15:12]), .cin(1'b0), .S(tempSum5), .cout(c6));
	  carry_ripple CSA7(.A(A[15:12]), .B(B[15:12]), .cin(1'b1), .S(tempSum6), .cout(c7));
	  assign cout3 = (cout1 & c7 | c6);
	  
	  always_comb begin
	  if(cout2==1'b0)
			S[15:12] = tempSum5;
	  else
			S[15:12] = tempSum6;
	  end
			
	 assign cout = cout3;
			
	  
	  
				

endmodule

module carry_ripple(input [3:0] A, B,
						  input cin,
						   output [3:0] S,
							output cout);
		
		logic c1,c2,c3;
		
		full_adder FA1(.A(A[0]), .B(B[0]), .cin(cin), .S(S[0]), .cout(c1));
		full_adder FA2(.A(A[1]), .B(B[1]), .cin(c1), .S(S[1]), .cout(c2));
		full_adder FA3(.A(A[2]), .B(B[2]), .cin(c2), .S(S[2]), .cout(c3));
		full_adder FA4(.A(A[3]), .B(B[3]), .cin(c3), .S(S[3]), .cout(cout));

endmodule