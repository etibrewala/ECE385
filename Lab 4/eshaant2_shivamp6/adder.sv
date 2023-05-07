module adder (input A, B, cin, output S, cout);
 
	assign S = A ^ B ^ cin;
	assign cout = (A&B)|(B&cin)|(A&cin);

endmodule



module add_sub9(input logic [7:0] A, B,
                              input logic fn,
                              output logic [8:0] S, output logic Xvalue);


    logic c0,c1,c2,c3,c4,c5,c6,c7;
    logic cout;
    logic A8,num8;
    logic [7:0] num;

    assign A8 = A[7];
    assign num = (B^{8{fn}}); //if subtracting, XOR with B and then add
    assign num8 = num[7];

    adder FA0(.A(A[0]), .B(num[0]), .cin(fn), .S(S[0]), .cout(c0)); //should cin be sub or fn
    adder FA1(.A(A[1]), .B(num[1]), .cin(c0), .S(S[1]), .cout(c1));
    adder FA2(.A(A[2]), .B(num[2]), .cin(c1), .S(S[2]), .cout(c2));
    adder FA3(.A(A[3]), .B(num[3]), .cin(c2), .S(S[3]), .cout(c3));
    adder FA4(.A(A[4]), .B(num[4]), .cin(c3), .S(S[4]), .cout(c4));
    adder FA5(.A(A[5]), .B(num[5]), .cin(c4), .S(S[5]), .cout(c5));
    adder FA6(.A(A[6]), .B(num[6]), .cin(c5), .S(S[6]), .cout(c6));
    adder FA7(.A(A[7]), .B(num[7]), .cin(c6), .S(S[7]), .cout(c7));
    adder FA8(.A(A8), .B(num8), .cin(c7), .S(S[8]), .cout(cout));
	 
	 assign Xvalue = S[8];


endmodule
	
							  
