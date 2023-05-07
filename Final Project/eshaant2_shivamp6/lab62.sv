//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);



logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig;
	logic [11:0] ballxsig, ballysig, ballsizesig;
	logic [11:0] goombaxsig, goombaysig, goombasizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode, keycode1;
	
	logic [11:0] velocitysig;
	
//=======================================================
//FLAG DECLARATIONS
//=======================================================
logic gAnimationFlag;
logic gFlag;
logic mFlag;
logic marioDirectionsig;
logic switchHandssig;
logic rightHandsig;
logic leftHandsig;
logic [3:0] marioFSMsig;
logic [11:0] scrollxsig;
logic marioboundssig;
logic goombaoverflowsig;

logic pipecollleftsig;
logic pipecollrightsig;
logic pipecolltopsig;
logic pipe2collleftsig;
logic pipe2collrightsig;
logic pipe2colltopsig;

logic MARIOTESTSIGNALS;

logic [5:0] jumptestsig;

logic brick1topsig, brick1bottomsig, brick1rightsig, brick1leftsig;

logic brick2topsig, brick2rightsig, brick2leftsig;
logic brick3topsig, brick3rightsig, brick3leftsig;

logic brick4topsig, brick4rightsig, brick4leftsig;
logic stairtopsig, stairrightsig, stairleftsig;

//=======================================================
//FLAGPOST SIGNALS
//=======================================================
logic [11:0] SB1Xsig, SB1Ysig, SB1sizesig;
parameter [11:0] SB1_X_Start = 1908;
parameter [11:0] SB1_Y_Start = 388;	
//=======================================================
//BLOCK SIGNALS
//=======================================================
logic [11:0] QB1Xsig, QB1Ysig, QB1sizesig;
logic [11:0] QB1_X_Start;
logic [11:0] QB1_Y_Start;
always_comb begin
	QB1_X_Start = 388;
	QB1_Y_Start = 292;
	if(moveCoinsig) begin
		QB1_X_Start = 0;
		QB1_Y_Start = 0;
	end
end

logic [11:0] QB4Xsig, QB4Ysig, QB4sizesig;
logic [11:0] QB4_X_Start;
logic [11:0] QB4_Y_Start;
always_comb begin
	QB4_X_Start = 580;
	QB4_Y_Start = 164;
	if(moveCoinsig2) begin
		QB4_X_Start = 0;
		QB4_Y_Start = 0;
	end
end

logic [11:0] QB5Xsig, QB5Ysig, QB5sizesig;
logic [11:0] QB5_X_Start;
logic [11:0] QB5_Y_Start;
always_comb begin
	QB5_X_Start = 788;
	QB5_Y_Start = 262;
	if(moveCoinsig3) begin
		QB5_X_Start = 0;
		QB5_Y_Start = 0;
	end
end

logic [11:0] QB6Xsig, QB6Ysig, QB6sizesig;
logic [11:0] QB6_X_Start;
logic [11:0] QB6_Y_Start;
always_comb begin
	QB6_X_Start = 1190;
	QB6_Y_Start = 292;
	if(moveCoinsig4) begin
		QB6_X_Start = 0;
		QB6_Y_Start = 0;
	end
end

logic [11:0] QB7Xsig, QB7Ysig, QB7sizesig;
logic [11:0] QB7_X_Start;
logic [11:0] QB7_Y_Start;
always_comb begin
	QB7_X_Start = 1286;
	QB7_Y_Start = 164;
	if(moveCoinsig5) begin
		QB7_X_Start = 0;
		QB7_Y_Start = 0;
	end
end

logic [11:0] QB8Xsig, QB8Ysig, QB8sizesig;
logic [11:0] QB8_X_Start;
logic [11:0] QB8_Y_Start;
always_comb begin
	QB8_X_Start = 1382;
	QB8_Y_Start = 292;
	if(moveCoinsig6) begin
		QB8_X_Start = 0;
		QB8_Y_Start = 0;
	end
end

logic [11:0] QB9Xsig, QB9Ysig, QB9sizesig;
logic [11:0] QB9_X_Start;
logic [11:0] QB9_Y_Start;
always_comb begin
	QB9_X_Start = 1564;
	QB9_Y_Start = 262;
	if(moveCoinsig7) begin
		QB9_X_Start = 0;
		QB9_Y_Start = 0;
	end
end


//===========================================
//BRICK BLOCK PARAMETERS
//===========================================

logic [11:0] BB1Xsig, BB1Ysig, BB1sizesig;
parameter [11:0] BB1_X_Start = 516;
parameter [11:0] BB1_Y_Start = 292;

logic [11:0] BB2Xsig, BB2Ysig, BB2sizesig;
parameter [11:0] BB2_X_Start = 580;
parameter [11:0] BB2_Y_Start = 292;

logic [11:0] BB3Xsig, BB3Ysig, BB3sizesig;
parameter [11:0] BB3_X_Start = 644;
parameter [11:0] BB3_Y_Start = 292;

logic [11:0] BB4Xsig, BB4Ysig, BB4sizesig;
parameter [11:0] BB4_X_Start = 998;
parameter [11:0] BB4_Y_Start = 292;

logic [11:0] BB5Xsig, BB5Ysig, BB5sizesig;
parameter [11:0] BB5_X_Start = 1030;
parameter [11:0] BB5_Y_Start = 292;

logic [11:0] BB6Xsig, BB6Ysig, BB6sizesig;
parameter [11:0] BB6_X_Start = 1286;
parameter [11:0] BB6_Y_Start = 292;


logic [11:0] BB7Xsig, BB7Ysig, BB7sizesig;
parameter [11:0] BB7_X_Start = 548;
parameter [11:0] BB7_Y_Start = 292;

logic [11:0] BB8Xsig, BB8Ysig, BB8sizesig;
parameter [11:0] BB8_X_Start = 612;
parameter [11:0] BB8_Y_Start = 292;	

logic [11:0] BB9Xsig, BB9Ysig, BB9sizesig;
parameter [11:0] BB9_X_Start = 1736;
parameter [11:0] BB9_Y_Start = 290;

logic [11:0] BB10Xsig, BB10Ysig, BB10sizesig;
parameter [11:0] BB10_X_Start = 1768;
parameter [11:0] BB10_Y_Start = 290;	
//=========================================

logic [11:0] PBXsig, PBYsig, PBsizesig;
parameter [11:0] PB_X_Start = 772;
parameter [11:0] PB_Y_Start = 356;

logic [11:0] PB2Xsig, PB2Ysig, PB2sizesig;
parameter [11:0] PB2_X_Start = 1548;
parameter [11:0] PB2_Y_Start = 356;


//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (1'b0, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (scoresig, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (1'b0, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (1'b0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[3:0];
	assign VGA_B = Blue[3:0]; 
	assign VGA_G = Green[3:0]; 
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		.keycode1_export(keycode1)
		
	 );

logic moveCoinsig;
logic moveCoinsig2;
logic moveCoinsig3;
logic moveCoinsig4;
logic moveCoinsig5;
logic moveCoinsig6;
logic moveCoinsig7;

logic coingonesig;
logic coin2gonesig;
logic coin3gonesig;
logic coin4gonesig;
logic coin5gonesig;
logic coin6gonesig;
logic coin7gonesig;

logic [3:0] scoresig;

vga_controller VGA(.Clk(MAX10_CLK1_50), 
						 .Reset(Reset_h), 
						 .hs(VGA_HS), 
						 .vs(VGA_VS), 
						 .pixel_clk(VGA_Clk), 
						 .blank(blank), 
						 .sync(sync), 
						 .DrawX(drawxsig), 
						 .DrawY(drawysig));

color_mapper CM(.Reset(Reset_h),
					 .frame_clk(VGA_VS),
					 .BallX(ballxsig), 
					 .BallY(ballysig), 
					 .GoombaX(goombaxsig), 
					 .GoombaY(goombaysig), 
					 .Goomba_size(goombasizesig),
					 .MarioFlag(mFlag),
					 .marioDirection(marioDirectionsig),
					 .goombaAnimationFlag(gAnimationFlag),
					 .MARIO_FSM(marioFSMsig),
					 .DrawX(drawxsig), 
					 .DrawY(drawysig), 
					 .Ball_size(ballsizesig), 
					 .Red(Red), 
					 .Blue(Blue), 
					 .Green(Green),
					 .blank(blank), 
					 .vga_clk(VGA_Clk),
					 .ScrollX(scrollxsig),
					 .marioBoundsFlag(marioboundssig),
					 .marioBrickFlag(blockcollisionsig),
					 .goombaOverflowFlag(goombaoverflowsig),
					 .gameovertemp(gameovertemp),
					 .healthbar(healthbar),
					 
					 .QB1X(QB1Xsig),
					 .QB1Y(QB1Ysig),
					 .QB1_size(QB1sizesig),
					 .QB4X(QB4Xsig),
					 .QB4Y(QB4Ysig),
					 .QB4_size(QB4sizesig),
					 .QB5X(QB5Xsig),
					 .QB5Y(QB5Ysig),
					 .QB5_size(QB5sizesig),
					 .QB6X(QB6Xsig),
					 .QB6Y(QB6Ysig),
					 .QB6_size(QB6sizesig),
					 .QB7X(QB7Xsig),
					 .QB7Y(QB7Ysig),
					 .QB7_size(QB7sizesig),
					 .QB8X(QB8Xsig),
					 .QB8Y(QB8Ysig),
					 .QB8_size(QB8sizesig),
					 .QB9X(QB9Xsig),
					 .QB9Y(QB9Ysig),
					 .QB9_size(QB9sizesig),
					 
					 .BB1X(BB1Xsig),
					 .BB1Y(BB1Ysig),
					 .BB1_size(BB1sizesig),
					 .BB2X(BB2Xsig),
					 .BB2Y(BB2Ysig),
					 .BB2_size(BB2sizesig),
					 .BB3X(BB3Xsig),
					 .BB3Y(BB3Ysig),
					 .BB3_size(BB3sizesig),
					 .BB4X(BB4Xsig),
					 .BB4Y(BB4Ysig),
					 .BB4_size(BB4sizesig),
					 .BB5X(BB5Xsig),
					 .BB5Y(BB5Ysig),
					 .BB5_size(BB5sizesig),
					 .BB6X(BB6Xsig),
					 .BB6Y(BB6Ysig),
					 .BB6_size(BB6sizesig),
					 .BB7X(BB7Xsig),
					 .BB7Y(BB7Ysig),
					 .BB7_size(BB7sizesig),
					 .BB8X(BB8Xsig),
					 .BB8Y(BB8Ysig),
					 .BB8_size(BB8sizesig),
					 .BB9X(BB9Xsig),
					 .BB9Y(BB9Ysig),
					 .BB9_size(BB9sizesig),
					 .BB10X(BB10Xsig),
					 .BB10Y(BB10Ysig),
					 .BB10_size(BB10sizesig),					
					 
					 .SB1X(SB1Xsig),
					 .SB1Y(SB1Ysig),
					 .SB1_size(SB1sizesig),
					 
					 .PBX(PBXsig),
					 .PBY(PBYsig),
					 .PB_size(PBsizesig),
					 .PB2X(PB2Xsig),
					 .PB2Y(PB2Ysig),
					 .PB2_size(PB2sizesig),
					 
					 .CB1X(CB1Xsig),
					 .CB1Y(CB1Ysig),
					 .CB1_size(CB1sizesig),
					 
					 .CB2X(CB2Xsig),
					 .CB2Y(CB2Ysig),
					 .CB2_size(CB2sizesig),
					 
					 .CB3X(CB3Xsig),
					 .CB3Y(CB3Ysig),
					 .CB3_size(CB3sizesig),
					 
					 .CB4X(CB4Xsig),
					 .CB4Y(CB4Ysig),
					 .CB4_size(CB4sizesig),
					 
					 .CB5X(CB5Xsig),
					 .CB5Y(CB5Ysig),
					 .CB5_size(CB5sizesig),
					 
					 .CB6X(CB6Xsig),
					 .CB6Y(CB6Ysig),
					 .CB6_size(CB6sizesig),
					 
					 .CB7X(CB7Xsig),
					 .CB7Y(CB7Ysig),
					 .CB7_size(CB7sizesig),
					 
					 .COINCOLLISION(moveCoinsig),
					 .COINCOLLISION2(moveCoinsig2),
					 .COINCOLLISION3(moveCoinsig3),
					 .COINCOLLISION4(moveCoinsig4),
					 .COINCOLLISION5(moveCoinsig5),
					 .COINCOLLISION6(moveCoinsig6),
					 .COINCOLLISION7(moveCoinsig7),
					 
			       
					 .SCORECOLLISION2(coin2gonesig),
					 .SCORECOLLISION3(coin3gonesig),
					 .SCORECOLLISION4(coin4gonesig),
					 .SCORECOLLISION5(coin5gonesig),
					 .SCORECOLLISION6(coin6gonesig),
					 .SCORECOLLISION7(coin7gonesig),
					 .SCORECOLLISION(coingonesig),
					 
					 
					 .MARIOSCORE(scoresig));
	 

 
ball BA(.Reset(Reset_h), 
		  .frame_clk(VGA_VS),
		  .VGA_Clk(VGA_Clk), 
		  .keycode(keycode),
		  .keycode1(keycode1),
		  .MarioFlag(mFlag),
		  .DrawX(drawxsig),
		  .DrawY(drawysig),
		  .MarioDirection(marioDirectionsig),
		  .FSM_OUT(marioFSMsig),
		  .BallX(ballxsig), 
		  .BallY(ballysig), 
		  .BallS(ballsizesig),
		  .ScrollXOut(scrollxsig),
		  .marioBrickFlag(mariocollisionsig),
		  .marioBoundsFlag(marioboundssig),
		  .playerflagtemp(playerflagtemp),
		  
		  .PipeCollisionLeft(pipecollleftsig),
		  .PipeCollisionRight(pipecollrightsig),
		  .PipeCollisionTop(pipecolltopsig),
		  
		  .Pipe2CollisionLeft(pipe2collleftsig),
		  .Pipe2CollisionRight(pipe2collrightsig),
		  .Pipe2CollisionTop(pipe2colltopsig),
		  
		  
		  .MARIOFLAGTEST(MARIOTESTSIGNALS),
		  .JUMPTEST(jumptestsig),
		  
		  .VELOCITYOUT(velocitysig),
		  
		  .Brick1CollisionTop(brick1topsig),
		  .Brick1CollisionLeft(brick1leftsig),
		  .Brick1CollisionRight(brick1rightsig),
		  
		  .Brick2CollisionTop(brick2topsig),
		  .Brick2CollisionLeft(brick2leftsig),
		  .Brick2CollisionRight(brick2rightsig),
		  
	     .Brick3CollisionTop(brick3topsig),
		  .Brick3CollisionLeft(brick3leftsig),
		  .Brick3CollisionRight(brick3rightsig),
		  
	     .Brick4CollisionTop(brick4topsig),
		  .Brick4CollisionLeft(brick4leftsig),
		  .Brick4CollisionRight(brick4rightsig),
		  
		  .StairCollisionTop(stairtopsig),
		  .StairCollisionLeft(stairleftsig),
		  .StairCollisionRight(stairrightsig));



goomba GOOM(.Reset(Reset_h), 
				.frame_clk(VGA_VS),
				.ScrollX(scrollxsig),
				.keycode(keycode),
				.GoombaFlag(gFlag),
				.goombaAnimationFlag(gAnimationFlag),
				.overflowFlag(goombaoverflowsig),
				.goombaX(goombaxsig), 
				.goombaY(goombaysig), 
				.goombaS(goombasizesig));
				
				
marioGoombaCollision COLLISION(.frame_clk(VGA_VS),
										 .MarioX(ballxsig), 
										 .MarioY(ballysig), 
										 .MarioS(ballsizesig),
										 .GoombaX(goombaxsig), 
										 .GoombaY(goombaysig), 
										 .GoombaS(goombasizesig),
										 .MarioFlag(mFlag), 
										 .GoombaFlag(gFlag));
										 

//===========================================================
//QUESTION BLOCK CALLS
//===========================================================										
						 
questionBlock QUESTIONBLOCK1(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.QB_X_Start(QB1_X_Start),
										.QB_Y_Start(QB1_Y_Start),
										.QB_X(QB1Xsig),
										.QB_Y(QB1Ysig),
										.QB_S(QB1sizesig));
//============================================================																			
							 
questionBlock QUESTIONBLOCK4(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.QB_X_Start(QB4_X_Start),
										.QB_Y_Start(QB4_Y_Start),
										.QB_X(QB4Xsig),
										.QB_Y(QB4Ysig),
										.QB_S(QB4sizesig));
										

//===========================================================										
						 
questionBlock QUESTIONBLOCK5(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.QB_X_Start(QB5_X_Start),
										.QB_Y_Start(QB5_Y_Start),
										.QB_X(QB5Xsig),
										.QB_Y(QB5Ysig),
										.QB_S(QB5sizesig));
//===========================================================										
						 
questionBlock QUESTIONBLOCK6(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.QB_X_Start(QB6_X_Start),
										.QB_Y_Start(QB6_Y_Start),
										.QB_X(QB6Xsig),
										.QB_Y(QB6Ysig),
										.QB_S(QB6sizesig));
//===========================================================										
					 
questionBlock QUESTIONBLOCK7(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.QB_X_Start(QB7_X_Start),
										.QB_Y_Start(QB7_Y_Start),
										.QB_X(QB7Xsig),
										.QB_Y(QB7Ysig),
										.QB_S(QB7sizesig));
//===========================================================										
							 
questionBlock QUESTIONBLOCK8(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.QB_X_Start(QB8_X_Start),
										.QB_Y_Start(QB8_Y_Start),
										.QB_X(QB8Xsig),
										.QB_Y(QB8Ysig),
										.QB_S(QB8sizesig));
//===========================================================										
							 
questionBlock QUESTIONBLOCK9(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.QB_X_Start(QB9_X_Start),
										.QB_Y_Start(QB9_Y_Start),
										.QB_X(QB9Xsig),
										.QB_Y(QB9Ysig),
										.QB_S(QB9sizesig));
//===========================================================
//BRICK BLOCK CALLS
//===========================================================


brickBlock BRICKBLOCK1(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB1_X_Start),
										.BB_Y_Start(BB1_Y_Start),
										.BB_X(BB1Xsig),
										.BB_Y(BB1Ysig),
										.BB_S(BB1sizesig));
//============================================================
logic gameovertemp, playerflagtemp;
game GAME(.Clk(VGA_VS),
			.Reset(Reset_h),
			.keycode(keycode),
         .collisionFlag(mFlag),
          .gameOver(gameovertemp), 
			 .ballX(ballxsig),
			 .healthbar(healthbar),
			 .scrollX(scrollxsig),
			 .playerFlag(playerflagtemp));
//
logic[1:0] healthbar;
//health HEALTH(.Clk(VGA_VS),.Reset(Reset_h),.collisionFlag(mFlag),
//						.health(healthbar));
			 
brickBlock BRICKBLOCK2(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB2_X_Start),
										.BB_Y_Start(BB2_Y_Start),
										.BB_X(BB2Xsig),
										.BB_Y(BB2Ysig),
										.BB_S(BB2sizesig));
//============================================================


brickBlock BRICKBLOCK3(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB3_X_Start),
										.BB_Y_Start(BB3_Y_Start),
										.BB_X(BB3Xsig),
										.BB_Y(BB3Ysig),
										.BB_S(BB3sizesig));
//============================================================


brickBlock BRICKBLOCK4(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB4_X_Start),
										.BB_Y_Start(BB4_Y_Start),
										.BB_X(BB4Xsig),
										.BB_Y(BB4Ysig),
										.BB_S(BB4sizesig));
//============================================================


brickBlock BRICKBLOCK5(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB5_X_Start),
										.BB_Y_Start(BB5_Y_Start),
										.BB_X(BB5Xsig),
										.BB_Y(BB5Ysig),
										.BB_S(BB5sizesig));


brickBlock BRICKBLOCK6(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB6_X_Start),
										.BB_Y_Start(BB6_Y_Start),
										.BB_X(BB6Xsig),
										.BB_Y(BB6Ysig),
										.BB_S(BB6sizesig));
										
brickBlock BRICKBLOCK7(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB7_X_Start),
										.BB_Y_Start(BB7_Y_Start),
										.BB_X(BB7Xsig),
										.BB_Y(BB7Ysig),
										.BB_S(BB7sizesig));
										
brickBlock BRICKBLOCK8(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB8_X_Start),
										.BB_Y_Start(BB8_Y_Start),
										.BB_X(BB8Xsig),
										.BB_Y(BB8Ysig),
										.BB_S(BB8sizesig));
										
brickBlock BRICKBLOCK9(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB9_X_Start),
										.BB_Y_Start(BB9_Y_Start),
										.BB_X(BB9Xsig),
										.BB_Y(BB9Ysig),
										.BB_S(BB9sizesig));
										
brickBlock BRICKBLOCK10(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.BB_X_Start(BB10_X_Start),
										.BB_Y_Start(BB10_Y_Start),
										.BB_X(BB10Xsig),
										.BB_Y(BB10Ysig),
										.BB_S(BB10sizesig));
										
//===============================================================
//FLAGPOST BLOCK CALL
//===============================================================
stairBlock STAIRBLOCK1(.Reset(Reset_h),
										.frame_clk(VGA_VS),
										.ScrollX(scrollxsig),
										.SB_X_Start(SB1_X_Start),
										.SB_Y_Start(SB1_Y_Start),
										.SB_X(SB1Xsig),
										.SB_Y(SB1Ysig),
										.SB_S(SB1sizesig));
										
//===============================================================
//PIPE BLOCK CALL
//===============================================================										

pipeBlock PIPEBLOCK(.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.ScrollX(scrollxsig),
							.PB_X_Start(PB_X_Start),
							.PB_Y_Start(PB_Y_Start),
							.PB_X(PBXsig),
							.PB_Y(PBYsig),
							.PB_S(PBsizesig));
							
pipeBlock PIPEBLOCK2(.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.ScrollX(scrollxsig),
							.PB_X_Start(PB2_X_Start),
							.PB_Y_Start(PB2_Y_Start),
							.PB_X(PB2Xsig),
							.PB_Y(PB2Ysig),
							.PB_S(PB2sizesig));
//================================================================
//TEST COLLISION CALLS
//================================================================



marioPipeCollision PIPECOLLISION(.Clk(MAX10_CLK1_50),
											.frame_clk(VGA_VS),
											.MarioX(ballxsig),
											.MarioY(ballysig),
											.MarioS(ballsizesig),
											.PipeX(PBXsig),
											.PipeY(PBYsig),
											.PipeS(PBsizesig),
											.PIPE_FLAGLEFT(pipecollleftsig),
											.PIPE_FLAGRIGHT(pipecollrightsig),
											.PIPE_FLAGTOP(pipecolltopsig));
											
marioPipeCollision PIPECOLLISION2(.Clk(MAX10_CLK1_50),
											.frame_clk(VGA_VS),
											.MarioX(ballxsig),
											.MarioY(ballysig),
											.MarioS(ballsizesig),
											.PipeX(PB2Xsig),
											.PipeY(PB2Ysig),
											.PipeS(PB2sizesig),
											.PIPE_FLAGLEFT(pipe2collleftsig),
											.PIPE_FLAGRIGHT(pipe2collrightsig),
											.PIPE_FLAGTOP(pipe2colltopsig));		
											
											

											
//==================================================================
//BRICK COLLISION CALLS
//==================================================================

Mario5BricksCollision BRICK1(.MarioX(ballxsig),
									.MarioY(ballysig),
									.MarioS(ballsizesig),
									.BlockX(BB1Xsig),
									.BlockY(BB1Ysig),
									.BlockS(BB1sizesig),
									.BRICK_FLAGLEFT(brick1leftsig),
									.BRICK_FLAGRIGHT(brick1rightsig),
									.BRICK_FLAGTOP(brick1topsig),
									//.BRICK_FLAGBOTTOM(brick1bottomsig)
									);
									
			
Mario2BricksCollision BRICK2(.MarioX(ballxsig),
									.MarioY(ballysig),
									.MarioS(ballsizesig),
									.BlockX(BB4Xsig),
									.BlockY(BB4Ysig),
									.BlockS(BB4sizesig),
									.BRICK2_FLAGLEFT(brick2leftsig),
									.BRICK2_FLAGRIGHT(brick2rightsig),
									.BRICK2_FLAGTOP(brick2topsig),
									//.BRICK_FLAGBOTTOM(brick1bottomsig)
									);
									
Mario2BricksCollision BRICK3(.MarioX(ballxsig),
									.MarioY(ballysig),
									.MarioS(ballsizesig),
									.BlockX(BB9Xsig),
									.BlockY(BB9Ysig),
									.BlockS(BB9sizesig),
									.BRICK2_FLAGLEFT(brick3leftsig),
									.BRICK2_FLAGRIGHT(brick3rightsig),
									.BRICK2_FLAGTOP(brick3topsig),
									//.BRICK_FLAGBOTTOM(brick1bottomsig)
									);
									
Mario1BricksCollision BRICKBottomTest(.MarioX(ballxsig),
									.MarioY(ballysig),
									.MarioS(ballsizesig),
									.BlockX(BB6Xsig),
									.BlockY(BB6Ysig),
									.BlockS(BB6sizesig),
									.BRICK_1_FLAGLEFT(brick4leftsig),
									.BRICK_1_FLAGRIGHT(brick4rightsig),
									.BRICK_1_FLAGTOP(brick4topsig));
									
Mario1BricksCollision FLAGPOST(.MarioX(ballxsig),
									.MarioY(ballysig),
									.MarioS(ballsizesig),
									.BlockX(SB1Xsig),
									.BlockY(SB1Ysig),
									.BlockS(SB1sizesig),
									.BRICK_1_FLAGLEFT(stairleftsig),
									.BRICK_1_FLAGRIGHT(stairrightsig),
									.BRICK_1_FLAGTOP(stairtopsig));
									
									
//====================================================================
//COIN LOGIC COLLISIONS
//====================================================================

logic [11:0] CB1Xsig, CB1Ysig, CB1sizesig;

logic [11:0] CB1_X_Start;
logic [11:0] CB1_Y_Start;
always_comb begin
	CB1_X_Start = 388;
   CB1_Y_Start = 388;
	if(coingonesig) begin
		CB1_X_Start = 0;
		CB1_Y_Start = 0;
	end
end
//======================================================================
logic [11:0] CB2Xsig, CB2Ysig, CB2sizesig;

logic [11:0] CB2_X_Start;
logic [11:0] CB2_Y_Start;
always_comb begin
	CB2_X_Start = 580;
   CB2_Y_Start = 260;
	if(coin2gonesig) begin
		CB2_X_Start = 0;
		CB2_Y_Start = 0;
	end
end
//==========================================================================
logic [11:0] CB3Xsig, CB3Ysig, CB3sizesig;

logic [11:0] CB3_X_Start;
logic [11:0] CB3_Y_Start;
always_comb begin
	CB3_X_Start = 788;
   CB3_Y_Start = 324;
	if(coin3gonesig) begin
		CB3_X_Start = 0;
		CB3_Y_Start = 0;
	end
end
//=============================================================================
logic [11:0] CB4Xsig, CB4Ysig, CB4sizesig;

logic [11:0] CB4_X_Start;
logic [11:0] CB4_Y_Start;
always_comb begin
	CB4_X_Start = 1190;
   CB4_Y_Start = 388;
	if(coin4gonesig) begin
		CB4_X_Start = 0;
		CB4_Y_Start = 0;
	end
end
//============================================================================
logic [11:0] CB5Xsig, CB5Ysig, CB5sizesig;

logic [11:0] CB5_X_Start;
logic [11:0] CB5_Y_Start;
always_comb begin
	CB5_X_Start = 1286;
   CB5_Y_Start = 388;
	if(coin5gonesig) begin
		CB5_X_Start = 0;
		CB5_Y_Start = 0;
	end
end

logic [11:0] CB6Xsig, CB6Ysig, CB6sizesig;

logic [11:0] CB6_X_Start;
logic [11:0] CB6_Y_Start;
always_comb begin
	CB6_X_Start = 1382;
   CB6_Y_Start = 388;
	if(coin6gonesig) begin
		CB6_X_Start = 0;
		CB6_Y_Start = 0;
	end
end

logic [11:0] CB7Xsig, CB7Ysig, CB7sizesig;

logic [11:0] CB7_X_Start;
logic [11:0] CB7_Y_Start;
always_comb begin
	CB7_X_Start = 1564;
   CB7_Y_Start = 324;
	if(coin7gonesig) begin
		CB7_X_Start = 0;
		CB7_Y_Start = 0;
	end
end
//=============================================================================
							 
coinBlock coin1(.ScrollX(scrollxsig),
					 .CB_X_Start(CB1_X_Start),
					 .CB_Y_Start(CB1_Y_Start),
					 .CB_X(CB1Xsig),
					 .CB_Y(CB1Ysig),
					 .CB_S(CB1sizesig));
					 
coinBlock coin2(.ScrollX(scrollxsig),
					 .CB_X_Start(CB2_X_Start),
					 .CB_Y_Start(CB2_Y_Start),
					 .CB_X(CB2Xsig),
					 .CB_Y(CB2Ysig),
					 .CB_S(CB2sizesig));
					 
coinBlock coin3(.ScrollX(scrollxsig),
					 .CB_X_Start(CB3_X_Start),
					 .CB_Y_Start(CB3_Y_Start),
					 .CB_X(CB3Xsig),
					 .CB_Y(CB3Ysig),
					 .CB_S(CB3sizesig));

coinBlock coin4(.ScrollX(scrollxsig),
					 .CB_X_Start(CB4_X_Start),
					 .CB_Y_Start(CB4_Y_Start),
					 .CB_X(CB4Xsig),
					 .CB_Y(CB4Ysig),
					 .CB_S(CB4sizesig));
					 
coinBlock coin5(.ScrollX(scrollxsig),
					 .CB_X_Start(CB5_X_Start),
					 .CB_Y_Start(CB5_Y_Start),
					 .CB_X(CB5Xsig),
					 .CB_Y(CB5Ysig),
					 .CB_S(CB5sizesig));
					 
coinBlock coin6(.ScrollX(scrollxsig),
					 .CB_X_Start(CB6_X_Start),
					 .CB_Y_Start(CB6_Y_Start),
					 .CB_X(CB6Xsig),
					 .CB_Y(CB6Ysig),
					 .CB_S(CB6sizesig));
					 
coinBlock coin7(.ScrollX(scrollxsig),
					 .CB_X_Start(CB7_X_Start),
					 .CB_Y_Start(CB7_Y_Start),
					 .CB_X(CB7Xsig),
					 .CB_Y(CB7Ysig),
					 .CB_S(CB7sizesig));

											  

	


logic [1:0] healthsignal;
logic GAMEOVERSIG;

//
//health_fsm HEALTHFSM(.Clk(VGA_VS),
//							.Reset(Reset_h),
//							.collisionFlag(mFlag),
//							.health(healthsignal),
//							.grameOver(GAMEOVERSIG));
							
							
											  
											  
endmodule








//module health_fsm(input logic Clk,
//						input logic Reset,
//						input logic collisionFlag,
//						output logic [1:0] health,
//						output logic gameOver);
//
//enum logic [3:0] {Halted,
//						Health3,
//						Health2,
//						Health1,
//						Health0,
//						WaitState3,
//						WaitState2,
//						WaitState1}State,Next_state;
//always_ff @(posedge Clk or posedge Reset) begin
//	if(Reset)
//		State <= Halted;
//	else begin
//		State <= Next_state;
//	end
//	
//end
//
//always comb begin
//	Next_state = state;
//	health = 2'b11;
//	gameOver = 1'b0;
//	
//	unique case (State)
//		Halted:Next_state = Health3;
//		Health3: begin
//			if(collisionFlag)
//				Next_state = WaitState3;
//			else
//				Next_state = Health3;
//		end
//		
//		WaitState3:begin
//			if(collisionFlag)
//				Next_state = WaitState3;
//			else
//				Next_state = Health2;
//		end
//		
//		Health2:begin
//			if(collisionFlag)
//				Next_state = WaitState2;
//			else
//				Next_state = Health2;
//		end
//		
//		WaitState2:begin
//			if(collisionFlag)
//				Next_state = WaitState2;
//			else
//				Next_state = Health1;
//		end
//		
//		Health1:begin
//			if(collisionFlag)
//				Next_state = WaitState1;
//			else
//				Next_state = Health1;
//		end
//		
//		WaitState1:begin
//			if(collisionFlag)
//				Next_state = WaitState1;
//			else
//				Next_state = Health0;
//		end
//		
//		Health0 :
//		
//		default :
//	endcase
//	
//	case(State)
//		Halted 		:
//		Health3		: health = 2'b11;
//		WaitState3	: health = 2'b10;
//		Health2		: health = 2'b10;
//		WaitState2	: health = 2'b01;
//		Health1		: health = 2'b01;
//		WaitState1	: health = 2'b00;
//		Health0		: begin
//			health = 2'b00;
//			gameOver = 1'b1;
//		end
//	endcase
//	
//	
//end
//
//endmodule 


module life3 (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] ScrollX,
	input logic [11:0] LIFEX, LIFEY,
	input logic vga_clk, blank,
	output logic [3:0] heart_red, heart_green, heart_blue
);

logic [11:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - LIFEX) + ((DrawY - LIFEY)  * 93);


life3_rom life3_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

life3_palette life3_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign heart_red = palette_red;
assign heart_green = palette_green;
assign heart_blue = palette_blue;

endmodule

module life2 (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] ScrollX,
	input logic [11:0] LIFEX, LIFEY,
	input logic vga_clk, blank,
	output logic [3:0] heart2_life, heart2_green, heart2_blue
);

logic [11:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - LIFEX) + ((DrawY - LIFEY)  * 93);


life2_rom life2_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

life2_palette life2_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign heart2_red = palette_red;
assign heart2_green = palette_green;
assign heart2_blue = palette_blue;

endmodule


module life1 (
	input logic [9:0] DrawX, DrawY,
	input logic [11:0] ScrollX,
	input logic [11:0] LIFEX, LIFEY,
	input logic vga_clk, blank,
	output logic [3:0] heart1_life, heart1_green, heart1_blue
);

logic [11:0] rom_address;
logic [1:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

assign rom_address = (DrawX - LIFEX) + ((DrawY - LIFEY)  * 93);

life1_rom life1_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

life1_palette life1_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

assign heart1_red = palette_red;
assign heart1_green = palette_green;
assign heart1_blue = palette_blue;

endmodule


//============================================================================================================
//============================================================================================================
//============================================================================================================
//============================================================================================================
//============================================================================================================
//============================================================================================================
//RECYCLE BIN
//===================================================================
//STAIR COLLISION CALLS
//===================================================================

//MarioBrickCollision STAIR1(.VelocityIn(velocitysig),
//									.MarioX(ballxsig),
//									.MarioY(ballysig),
//									.MarioS(ballsizesig),
//									.BlockX(SB1Xsig),
//									.BlockY(SB1Ysig),
//									.BlockS(SB1sizesig),
//									.BRICK_FLAGLEFT(stair1leftsig),
//									.BRICK_FLAGRIGHT(stair1rightsig),
//									.BRICK_FLAGTOP(stair1topsig),
//									.BRICK_FLAGBOTTOM(stair1bottomsig));
//
//MarioBrickCollision STAIR2(.VelocityIn(velocitysig),
//									.MarioX(ballxsig),
//									.MarioY(ballysig),
//									.MarioS(ballsizesig),
//									.BlockX(SB2Xsig),
//									.BlockY(SB2Ysig),
//									.BlockS(SB2sizesig),
//									.BRICK_FLAGLEFT(stair2leftsig),
//									.BRICK_FLAGRIGHT(stair2rightsig),
//									.BRICK_FLAGTOP(stair2topsig),
//									.BRICK_FLAGBOTTOM(stair2bottomsig));
//									
//MarioBrickCollision STAIR3(.VelocityIn(velocitysig),
//									.MarioX(ballxsig),
//									.MarioY(ballysig),
//									.MarioS(ballsizesig),
//									.BlockX(SB3Xsig),
//									.BlockY(SB3Ysig),
//									.BlockS(SB3sizesig),
//									.BRICK_FLAGLEFT(stair3leftsig),
//									.BRICK_FLAGRIGHT(stair3rightsig),
//									.BRICK_FLAGTOP(stair3topsig),
//									.BRICK_FLAGBOTTOM(stair3bottomsig));
//									
//MarioBrickCollision STAIR4(.VelocityIn(velocitysig),
//									.MarioX(ballxsig),
//									.MarioY(ballysig),
//									.MarioS(ballsizesig),
//									.BlockX(SB4Xsig),
//									.BlockY(SB4Ysig),
//									.BlockS(SB4sizesig),
//									.BRICK_FLAGLEFT(stair4leftsig),
//									.BRICK_FLAGRIGHT(stair4rightsig),
//									.BRICK_FLAGTOP(stair4topsig),
//									.BRICK_FLAGBOTTOM(stair4bottomsig));
//									
//MarioBrickCollision STAIR5(.VelocityIn(velocitysig),
//									.MarioX(ballxsig),
//									.MarioY(ballysig),
//									.MarioS(ballsizesig),
//									.BlockX(SB5Xsig),
//									.BlockY(SB5Ysig),
//									.BlockS(SB5sizesig),
//									.BRICK_FLAGLEFT(stair5leftsig),
//									.BRICK_FLAGRIGHT(stair5rightsig),
//									.BRICK_FLAGTOP(stair5topsig),
//									.BRICK_FLAGBOTTOM(stair5bottomsig));
//									
//MarioBrickCollision STAIR6(.VelocityIn(velocitysig),
//									.MarioX(ballxsig),
//									.MarioY(ballysig),
//									.MarioS(ballsizesig),
//									.BlockX(SB6Xsig),
//									.BlockY(SB6Ysig),
//									.BlockS(SB6sizesig),
//									.BRICK_FLAGLEFT(stair6leftsig),
//									.BRICK_FLAGRIGHT(stair6rightsig),
//									.BRICK_FLAGTOP(stair6topsig),
//									.BRICK_FLAGBOTTOM(stair6bottomsig));
//									
//MarioBrickCollision STAIR7(.VelocityIn(velocitysig),
//									.MarioX(ballxsig),
//									.MarioY(ballysig),
//									.MarioS(ballsizesig),
//									.BlockX(SB7Xsig),
//									.BlockY(SB7Ysig),
//									.BlockS(SB7sizesig),
//									.BRICK_FLAGLEFT(stair7leftsig),
//									.BRICK_FLAGRIGHT(stair7rightsig),
//									.BRICK_FLAGTOP(stair7topsig),
//									.BRICK_FLAGBOTTOM(stair7bottomsig));
//=============================================================
//STAIR BLOCK CALLS
//=============================================================

//stairBlock STAIRBLOCK1(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB1_X_Start),
//										.SB_Y_Start(SB1_Y_Start),
//										.SB_X(SB1Xsig),
//										.SB_Y(SB1Ysig),
//										.SB_S(SB1sizesig));
////=============================================================
//
//
//stairBlock STAIRBLOCK2(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB2_X_Start),
//										.SB_Y_Start(SB2_Y_Start),
//										.SB_X(SB2Xsig),
//										.SB_Y(SB2Ysig),
//										.SB_S(SB2sizesig));
////=============================================================
//
//stairBlock STAIRBLOCK3(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB3_X_Start),
//										.SB_Y_Start(SB3_Y_Start),
//										.SB_X(SB3Xsig),
//										.SB_Y(SB3Ysig),
//										.SB_S(SB3sizesig));
////=============================================================
//
//
//stairBlock STAIRBLOCK4(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB4_X_Start),
//										.SB_Y_Start(SB4_Y_Start),
//										.SB_X(SB4Xsig),
//										.SB_Y(SB4Ysig),
//										.SB_S(SB4sizesig));
////=============================================================
//
//
//stairBlock STAIRBLOCK5(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB5_X_Start),
//										.SB_Y_Start(SB5_Y_Start),
//										.SB_X(SB5Xsig),
//										.SB_Y(SB5Ysig),
//										.SB_S(SB5sizesig));
////=============================================================
//
//
//stairBlock STAIRBLOCK6(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB6_X_Start),
//										.SB_Y_Start(SB6_Y_Start),
//										.SB_X(SB6Xsig),
//										.SB_Y(SB6Ysig),
//										.SB_S(SB6sizesig));
////=============================================================
//
//stairBlock STAIRBLOCK7(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB7_X_Start),
//										.SB_Y_Start(SB7_Y_Start),
//										.SB_X(SB7Xsig),
//										.SB_Y(SB7Ysig),
//										.SB_S(SB7sizesig));
////=============================================================
//
//stairBlock STAIRBLOCK8(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB8_X_Start),
//										.SB_Y_Start(SB8_Y_Start),
//										.SB_X(SB8Xsig),
//										.SB_Y(SB8Ysig),
//										.SB_S(SB8sizesig));
////=============================================================
//stairBlock STAIRBLOCK9(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB9_X_Start),
//										.SB_Y_Start(SB9_Y_Start),
//										.SB_X(SB9Xsig),
//										.SB_Y(SB9Ysig),
//										.SB_S(SB9sizesig));
////=============================================================
//
//stairBlock STAIRBLOCK10(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB10_X_Start),
//										.SB_Y_Start(SB10_Y_Start),
//										.SB_X(SB10Xsig),
//										.SB_Y(SB10Ysig),
//										.SB_S(SB10sizesig));
////=============================================================
//
//stairBlock STAIRBLOCK11(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB11_X_Start),
//										.SB_Y_Start(SB11_Y_Start),
//										.SB_X(SB11Xsig),
//										.SB_Y(SB11Ysig),
//										.SB_S(SB11sizesig));
////=============================================================
//
//
//stairBlock STAIRBLOCK12(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB12_X_Start),
//										.SB_Y_Start(SB12_Y_Start),
//										.SB_X(SB12Xsig),
//										.SB_Y(SB12Ysig),
//										.SB_S(SB12sizesig));
////=============================================================
//
//stairBlock STAIRBLOCK13(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB13_X_Start),
//										.SB_Y_Start(SB13_Y_Start),
//										.SB_X(SB13Xsig),
//										.SB_Y(SB13Ysig),
//										.SB_S(SB13sizesig));
////=============================================================
//
//
//stairBlock STAIRBLOCK14(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB14_X_Start),
//										.SB_Y_Start(SB14_Y_Start),
//										.SB_X(SB14Xsig),
//										.SB_Y(SB14Ysig),
//										.SB_S(SB14sizesig));
////=============================================================
//
//stairBlock STAIRBLOCK15(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.SB_X_Start(SB15_X_Start),
//										.SB_Y_Start(SB15_Y_Start),
//										.SB_X(SB15Xsig),
//										.SB_Y(SB15Ysig),
//										.SB_S(SB15sizesig));

							 
//questionBlock QUESTIONBLOCK2(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.QB_X_Start(QB2_X_Start),
//										.QB_Y_Start(QB2_Y_Start),
//										.QB_X(QB2Xsig),
//										.QB_Y(QB2Ysig),
//										.QB_S(QB2sizesig));

//===========================================================										
						 
//questionBlock QUESTIONBLOCK3(.Reset(Reset_h),
//										.frame_clk(VGA_VS),
//										.ScrollX(scrollxsig),
//										.QB_X_Start(QB3_X_Start),
//										.QB_Y_Start(QB3_Y_Start),
//										.QB_X(QB3Xsig),
//										.QB_Y(QB3Ysig),
//										.QB_S(QB3sizesig));
//===========================================================	

//					 .SB1X(SB1Xsig),
//					 .SB1Y(SB1Ysig),
//					 .SB1_size(SB1sizesig),
//					 .SB2X(SB2Xsig),
//					 .SB2Y(SB2Ysig),
//					 .SB2_size(SB2sizesig),
//					 .SB3X(SB3Xsig),
//					 .SB3Y(SB3Ysig),
//					 .SB3_size(SB3sizesig),
//					 .SB4X(SB4Xsig),
//					 .SB4Y(SB4Ysig),
//					 .SB4_size(SB4sizesig),
//					 .SB5X(SB5Xsig),
//					 .SB5Y(SB5Ysig),
//					 .SB5_size(SB5sizesig),
//					 .SB6X(SB6Xsig),
//					 .SB6Y(SB6Ysig),
//					 .SB6_size(SB6sizesig),
//					 .SB7X(SB7Xsig),
//					 .SB7Y(SB7Ysig),
//					 .SB7_size(SB7sizesig),
//					 .SB8X(SB8Xsig),
//					 .SB8Y(SB8Ysig),
//					 .SB8_size(SB8sizesig),
//					 .SB9X(SB9Xsig),
//					 .SB9Y(SB9Ysig),
//					 .SB9_size(SB9sizesig),
//					 .SB10X(SB10Xsig),
//					 .SB10Y(SB10Ysig),
//					 .SB10_size(SB10sizesig),
//					 .SB11X(SB11Xsig),
//					 .SB11Y(SB11Ysig),
//					 .SB11_size(SB11sizesig),
//					 .SB12X(SB12Xsig),
//					 .SB12Y(SB12Ysig),
//					 .SB12_size(SB12sizesig),
//					 .SB13X(SB13Xsig),
//					 .SB13Y(SB13Ysig),
//					 .SB13_size(SB13sizesig),
//					 .SB14X(SB14Xsig),
//					 .SB14Y(SB14Ysig),
//					 .SB14_size(SB14sizesig),
//					 .SB15X(SB15Xsig),
//					 .SB15Y(SB15Ysig),
//					 .SB15_size(SB15sizesig),

//					 .QB2X(QB2Xsig),
//					 .QB2Y(QB2Ysig),
//					 .QB2_size(QB2sizesig),
//					 .QB3X(QB3Xsig),
//					 .QB3Y(QB3Ysig),
//					 .QB3_size(QB3sizesig),

//==============================================================
//STAIR BLOCKS
//==============================================================
//
//	logic[11:0] SB1DistX, SB1DistY, SB1Size;
//	assign SB1DistX = DrawX - SB1X;
//	assign SB1DistY = DrawY - SB1Y;
//	assign SB1Size = SB1_size;
//	
//	always_comb
//	begin:SB1_on_proc
//		
//		if((SB1DistX <= SB1Size) && (SB1DistY <= SB1Size))
//			SB1_on <= 1'b1;
//		else
//			SB1_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB2DistX, SB2DistY, SB2Size;
//	assign SB2DistX = DrawX - SB2X;
//	assign SB2DistY = DrawY - SB2Y;
//	assign SB2Size = SB2_size;
//	
//	always_comb
//	begin:SB2_on_proc
//		
//		if((SB2DistX <= SB2Size) && (SB2DistY <= SB2Size))
//			SB2_on <= 1'b1;
//		else
//			SB2_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB3DistX, SB3DistY, SB3Size;
//	assign SB3DistX = DrawX - SB3X;
//	assign SB3DistY = DrawY - SB3Y;
//	assign SB3Size = SB3_size;
//	
//	always_comb
//	begin:SB3_on_proc
//		
//		if((SB3DistX <= SB3Size) && (SB3DistY <= SB3Size))
//			SB3_on <= 1'b1;
//		else
//			SB3_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB4DistX, SB4DistY, SB4Size;
//	assign SB4DistX = DrawX - SB4X;
//	assign SB4DistY = DrawY - SB4Y;
//	assign SB4Size = SB4_size;
//	
//	always_comb
//	begin:SB4_on_proc
//		
//		if((SB4DistX <= SB4Size) && (SB4DistY <= SB4Size))
//			SB4_on <= 1'b1;
//		else
//			SB4_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB5DistX, SB5DistY, SB5Size;
//	assign SB5DistX = DrawX - SB5X;
//	assign SB5DistY = DrawY - SB5Y;
//	assign SB5Size = SB5_size;
//	
//	always_comb
//	begin:SB5_on_proc
//		
//		if((SB5DistX <= SB5Size) && (SB5DistY <= SB5Size))
//			SB5_on <= 1'b1;
//		else
//			SB5_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB6DistX, SB6DistY, SB6Size;
//	assign SB6DistX = DrawX - SB6X;
//	assign SB6DistY = DrawY - SB6Y;
//	assign SB6Size = SB6_size;
//	
//	always_comb
//	begin:SB6_on_proc
//		
//		if((SB6DistX <= SB6Size) && (SB6DistY <= SB6Size))
//			SB6_on <= 1'b1;
//		else
//			SB6_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB7DistX, SB7DistY, SB7Size;
//	assign SB7DistX = DrawX - SB7X;
//	assign SB7DistY = DrawY - SB7Y;
//	assign SB7Size = SB7_size;
//	
//	always_comb
//	begin:SB7_on_proc
//		
//		if((SB7DistX <= SB7Size) && (SB7DistY <= SB7Size))
//			SB7_on <= 1'b1;
//		else
//			SB7_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB8DistX, SB8DistY, SB8Size;
//	assign SB8DistX = DrawX - SB8X;
//	assign SB8DistY = DrawY - SB8Y;
//	assign SB8Size = SB8_size;
//	
//	always_comb
//	begin:SB8_on_proc
//		
//		if((SB8DistX <= SB8Size) && (SB8DistY <= SB8Size))
//			SB8_on <= 1'b1;
//		else
//			SB8_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB9DistX, SB9DistY, SB9Size;
//	assign SB9DistX = DrawX - SB9X;
//	assign SB9DistY = DrawY - SB9Y;
//	assign SB9Size = SB9_size;
//	
//	always_comb
//	begin:SB9_on_proc
//		
//		if((SB9DistX <= SB9Size) && (SB9DistY <= SB9Size))
//			SB9_on <= 1'b1;
//		else
//			SB9_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB10DistX, SB10DistY, SB10Size;
//	assign SB10DistX = DrawX - SB10X;
//	assign SB10DistY = DrawY - SB10Y;
//	assign SB10Size = SB10_size;
//	
//	always_comb
//	begin:SB10_on_proc
//		
//		if((SB10DistX <= SB10Size) && (SB10DistY <= SB10Size))
//			SB10_on <= 1'b1;
//		else
//			SB10_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB11DistX, SB11DistY, SB11Size;
//	assign SB11DistX = DrawX - SB11X;
//	assign SB11DistY = DrawY - SB11Y;
//	assign SB11Size = SB11_size;
//	
//	always_comb
//	begin:SB11_on_proc
//		
//		if((SB11DistX <= SB11Size) && (SB11DistY <= SB11Size))
//			SB11_on <= 1'b1;
//		else
//			SB11_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB12DistX, SB12DistY, SB12Size;
//	assign SB12DistX = DrawX - SB12X;
//	assign SB12DistY = DrawY - SB12Y;
//	assign SB12Size = SB12_size;
//	
//	always_comb
//	begin:SB12_on_proc
//		
//		if((SB12DistX <= SB12Size) && (SB12DistY <= SB12Size))
//			SB12_on <= 1'b1;
//		else
//			SB12_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB13DistX, SB13DistY, SB13Size;
//	assign SB13DistX = DrawX - SB13X;
//	assign SB13DistY = DrawY - SB13Y;
//	assign SB13Size = SB13_size;
//	
//	always_comb
//	begin:SB13_on_proc
//		
//		if((SB13DistX <= SB13Size) && (SB13DistY <= SB13Size))
//			SB13_on <= 1'b1;
//		else
//			SB13_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB14DistX, SB14DistY, SB14Size;
//	assign SB14DistX = DrawX - SB14X;
//	assign SB14DistY = DrawY - SB14Y;
//	assign SB14Size = SB14_size;
//	
//	always_comb
//	begin:SB14_on_proc
//		
//		if((SB14DistX <= SB14Size) && (SB14DistY <= SB14Size))
//			SB14_on <= 1'b1;
//		else
//			SB14_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] SB15DistX, SB15DistY, SB15Size;
//	assign SB15DistX = DrawX - SB15X;
//	assign SB15DistY = DrawY - SB15Y;
//	assign SB15Size = SB15_size;
//	
//	always_comb
//	begin:SB15_on_proc
//		
//		if((SB15DistX <= SB15Size) && (SB15DistY <= SB15Size))
//			SB15_on <= 1'b1;
//		else
//			SB15_on <= 1'b0;
//	end
//=========================================


//logic [11:0] SB1Xsig, SB1Ysig, SB1sizesig;
//parameter [11:0] SB1_X_Start = 1702;
//parameter [11:0] SB1_Y_Start = 388;
//
//logic [11:0] SB2Xsig, SB2Ysig, SB2sizesig;
//parameter [11:0] SB2_X_Start = 1734;
//parameter [11:0] SB2_Y_Start = 356;
//
//logic [11:0] SB3Xsig, SB3Ysig, SB3sizesig;
//parameter [11:0] SB3_X_Start = 1766;
//parameter [11:0] SB3_Y_Start = 324;
//
//logic [11:0] SB4Xsig, SB4Ysig, SB4sizesig;
//parameter [11:0] SB4_X_Start = 1798;
//parameter [11:0] SB4_Y_Start = 292;
//
//logic [11:0] SB5Xsig, SB5Ysig, SB5sizesig;
//parameter [11:0] SB5_X_Start = 1830;
//parameter [11:0] SB5_Y_Start = 260;
//
//logic [11:0] SB6Xsig, SB6Ysig, SB6sizesig;
//parameter [11:0] SB6_X_Start = 1862;
//parameter [11:0] SB6_Y_Start = 228;
//
//logic [11:0] SB7Xsig, SB7Ysig, SB7sizesig;
//parameter [11:0] SB7_X_Start = 1894;
//parameter [11:0] SB7_Y_Start = 196;
//
//logic [11:0] SB8Xsig, SB8Ysig, SB8sizesig;
//parameter [11:0] SB8_X_Start = 1926;
//parameter [11:0] SB8_Y_Start = 196;
//
//logic [11:0] SB9Xsig, SB9Ysig, SB9sizesig;
//parameter [11:0] SB9_X_Start = 1926;
//parameter [11:0] SB9_Y_Start = 228;
//
//logic [11:0] SB10Xsig, SB10Ysig, SB10sizesig;
//parameter [11:0] SB10_X_Start = 1926;
//parameter [11:0] SB10_Y_Start = 260;
//
//logic [11:0] SB11Xsig, SB11Ysig, SB11sizesig;
//parameter [11:0] SB11_X_Start = 1926;
//parameter [11:0] SB11_Y_Start = 292;
//
//logic [11:0] SB12Xsig, SB12Ysig, SB12sizesig;
//parameter [11:0] SB12_X_Start = 1926;
//parameter [11:0] SB12_Y_Start = 324;
//
//logic [11:0] SB13Xsig, SB13Ysig, SB13sizesig;
//parameter [11:0] SB13_X_Start = 1926;
//parameter [11:0] SB13_Y_Start = 356;
//
//logic [11:0] SB14Xsig, SB14Ysig, SB14sizesig;
//parameter [11:0] SB14_X_Start = 1926;
//parameter [11:0] SB14_Y_Start = 388;
//
//logic [11:0] SB15Xsig, SB15Ysig, SB15sizesig;
//parameter [11:0] SB15_X_Start = 2166;
//parameter [11:0] SB15_Y_Start = 388;

//
//			else if(SB1_on == 1'b1) begin
//				Red <= sb1_red;
//				Green <= sb1_green;
//				Blue <= sb1_blue;
//			end
//			
//			else if(SB2_on == 1'b1) begin
//				Red <= sb2_red;
//				Green <= sb2_green;
//				Blue <= sb2_blue;
//			end
//			else if(SB3_on == 1'b1) begin
//				Red <= sb3_red;
//				Green <= sb3_green;
//				Blue <= sb3_blue;
//			end
//			else if(SB4_on == 1'b1) begin
//				Red <= sb4_red;
//				Green <= sb4_green;
//				Blue <= sb4_blue;
//			end
//			else if(SB5_on == 1'b1) begin
//				Red <= sb5_red;
//				Green <= sb5_green;
//				Blue <= sb5_blue;
//			end
//			else if(SB6_on == 1'b1) begin
//				Red <= sb6_red;
//				Green <= sb6_green;
//				Blue <= sb6_blue;
//			end
//			else if(SB7_on == 1'b1) begin
//				Red <= sb7_red;
//				Green <= sb7_green;
//				Blue <= sb7_blue;
//			end
//			else if(SB8_on == 1'b1) begin
//				Red <= sb8_red;
//				Green <= sb8_green;
//				Blue <= sb8_blue;
//			end
//			else if(SB9_on == 1'b1) begin
//				Red <= sb9_red;
//				Green <= sb9_green;
//				Blue <= sb9_blue;
//			end
//			else if(SB10_on == 1'b1) begin
//				Red <= sb10_red;
//				Green <= sb10_green;
//				Blue <= sb10_blue;
//			end
//			else if(SB11_on == 1'b1) begin
//				Red <= sb11_red;
//				Green <= sb11_green;
//				Blue <= sb11_blue;
//			end
//			else if(SB12_on == 1'b1) begin
//				Red <= sb12_red;
//				Green <= sb12_green;
//				Blue <= sb12_blue;
//			end
//			else if(SB13_on == 1'b1) begin
//				Red <= sb13_red;
//				Green <= sb13_green;
//				Blue <= sb13_blue;
//			end	
//			else if(SB14_on == 1'b1) begin
//				Red <= sb14_red;
//				Green <= sb14_green;
//				Blue <= sb14_blue;
//			end
//			
//			else if(SB15_on == 1'b1) begin
//				Red <= sb15_red;
//				Green <= sb15_green;
//				Blue <= sb15_blue;
//			end
//		
//logic [3:0] qb2_red, qb2_green, qb2_blue;
//questionBlockSprite QB2(.*, .qb_red(qb2_red), .qb_green(qb2_green), .qb_blue(qb2_blue), .QBX(QB2X), .QBY(QB2Y));
//
//logic [3:0] qb3_red, qb3_green, qb3_blue;
//questionBlockSprite QB3(.*, .qb_red(qb3_red), .qb_green(qb3_green), .qb_blue(qb3_blue), .QBX(QB3X), .QBY(QB3Y));

//							  input			[11:0] QB2X, QB2Y, QB2_size,
//							  input			[11:0] QB3X, QB3Y, QB3_size,

//							  input			[11:0] SB1X, SB1Y, SB1_size,
//							  input			[11:0] SB2X, SB2Y, SB2_size,
//							  input			[11:0] SB3X, SB3Y, SB3_size,
//							  input			[11:0] SB4X, SB4Y, SB4_size,
//							  input			[11:0] SB5X, SB5Y, SB5_size,
//							  input			[11:0] SB6X, SB6Y, SB6_size,
//							  input			[11:0] SB7X, SB7Y, SB7_size,
//							  input			[11:0] SB8X, SB8Y, SB8_size,
//							  input			[11:0] SB9X, SB9Y, SB9_size,
//							  input			[11:0] SB10X, SB10Y, SB10_size,
//							  input			[11:0] SB11X, SB11Y, SB11_size,
//							  input			[11:0] SB12X, SB12Y, SB12_size,
//							  input			[11:0] SB13X, SB13Y, SB13_size,
//							  input			[11:0] SB14X, SB14Y, SB14_size,
//							  input			[11:0] SB15X, SB15Y, SB15_size,
//	 logic SB1_on;
//	 logic SB2_on;
//	 logic SB3_on;
//	 logic SB4_on;
//	 logic SB5_on;
//	 logic SB6_on;
//	 logic SB7_on;
//	 logic SB8_on;
//	 logic SB9_on;
//	 logic SB10_on;
//	 logic SB11_on;
//	 logic SB12_on;
//	 logic SB13_on;
//	 logic SB14_on;
//	 logic SB15_on;
	 
//	 assign SB1_on = 1'b0;
//	 assign SB2_on = 1'b0;
//	 assign SB3_on = 1'b0;
//	 assign SB4_on = 1'b0;
//	 assign SB5_on = 1'b0;
//	 assign SB6_on = 1'b0;
//	 assign SB7_on = 1'b0;
//	 assign SB8_on = 1'b0;
//	 assign SB9_on = 1'b0;
//	 assign SB10_on = 1'b0;
//	 assign SB11_on = 1'b0;
//	 assign SB12_on = 1'b0;
//	 assign SB13_on = 1'b0;
//	 assign SB14_on = 1'b0;
//	 assign SB15_on = 1'b0;	 

//-------------------------------------------------------------
//	logic[11:0] BB7DistX, BB7DistY, BB7Size;
//	assign BB7DistX = DrawX - BB7X;
//	assign BB7DistY = DrawY - BB7Y;
//	assign BB7Size = BB7_size;
//	
//	always_comb
//	begin:BB7_on_proc
//		
//		if((BB7DistX <= BB7Size) && (BB7DistY <= BB7Size))
//			BB7_on <= 1'b1;
//		else
//			BB7_on <= 1'b0;
//	end
////-------------------------------------------------------------
//	logic[11:0] BB3DistX, BB8DistY, BB8Size;
//	assign BB8DistX = DrawX - BB8X;
//	assign BB8DistY = DrawY - BB8Y;
//	assign BB8Size = BB8_size;
//	
//	always_comb
//	begin:BB8_on_proc
//		
//		if((BB8DistX <= BB8Size) && (BB8DistY <= BB8Size))
//			BB8_on <= 1'b1;
//		else
//			BB8_on <= 1'b0;
//	end
//-------------------------------------------------------------
//============================================================
//logic hit_block;
//	
//always_comb begin
// hit_block = 0;
// if(QB1_on && ball_on) begin
//	if(DistY == 0 && (DistX >= 0 && DistX <= Size)) begin
//		hit_block = 1'b1;
//	end
//  end
//end
//
//assign HITTEST = hit_block;
//logic [3:0] sb2_red, sb2_green, sb2_blue;
//stairBlockSprite SB2(.*, .sb_red(sb2_red), .sb_green(sb2_green), .sb_blue(sb2_blue), .SBX(SB2X), .SBY(SB2Y));
//
//logic [3:0] sb3_red, sb3_green, sb3_blue;
//stairBlockSprite SB3(.*, .sb_red(sb3_red), .sb_green(sb3_green), .sb_blue(sb3_blue), .SBX(SB3X), .SBY(SB3Y));
//
//logic [3:0] sb4_red, sb4_green, sb4_blue;
//stairBlockSprite SB4(.*, .sb_red(sb4_red), .sb_green(sb4_green), .sb_blue(sb4_blue), .SBX(SB4X), .SBY(SB4Y));
//
//logic [3:0] sb5_red, sb5_green, sb5_blue;
//stairBlockSprite SB5(.*, .sb_red(sb5_red), .sb_green(sb5_green), .sb_blue(sb5_blue), .SBX(SB5X), .SBY(SB5Y));
//
//logic [3:0] sb6_red, sb6_green, sb6_blue;
//stairBlockSprite SB6(.*, .sb_red(sb6_red), .sb_green(sb6_green), .sb_blue(sb6_blue), .SBX(SB6X), .SBY(SB6Y));
//
//logic [3:0] sb7_red, sb7_green, sb7_blue;
//stairBlockSprite SB7(.*, .sb_red(sb7_red), .sb_green(sb7_green), .sb_blue(sb7_blue), .SBX(SB7X), .SBY(SB7Y));
//
//logic [3:0] sb8_red, sb8_green, sb8_blue;
//stairBlockSprite SB8(.*, .sb_red(sb8_red), .sb_green(sb8_green), .sb_blue(sb8_blue), .SBX(SB8X), .SBY(SB8Y));
//
//logic [3:0] sb9_red, sb9_green, sb9_blue;
//stairBlockSprite SB9(.*, .sb_red(sb9_red), .sb_green(sb9_green), .sb_blue(sb9_blue), .SBX(SB9X), .SBY(SB9Y));
//
//logic [3:0] sb10_red, sb10_green, sb10_blue;
//stairBlockSprite SB10(.*, .sb_red(sb10_red), .sb_green(sb10_green), .sb_blue(sb10_blue), .SBX(SB10X), .SBY(SB10Y));
//
//logic [3:0] sb11_red, sb11_green, sb11_blue;
//stairBlockSprite SB11(.*, .sb_red(sb11_red), .sb_green(sb11_green), .sb_blue(sb11_blue), .SBX(SB11X), .SBY(SB11Y));
//
//logic [3:0] sb12_red, sb12_green, sb12_blue;
//stairBlockSprite SB12(.*, .sb_red(sb12_red), .sb_green(sb12_green), .sb_blue(sb12_blue), .SBX(SB12X), .SBY(SB12Y));
//
//logic [3:0] sb13_red, sb13_green, sb13_blue;
//stairBlockSprite SB13(.*, .sb_red(sb13_red), .sb_green(sb13_green), .sb_blue(sb13_blue), .SBX(SB13X), .SBY(SB13Y));
//
//logic [3:0] sb14_red, sb14_green, sb14_blue;
//stairBlockSprite SB14(.*, .sb_red(sb14_red), .sb_green(sb14_green), .sb_blue(sb14_blue), .SBX(SB14X), .SBY(SB14Y));
//
//logic [3:0] sb15_red, sb15_green, sb15_blue;
//stairBlockSprite SB15(.*, .sb_red(sb15_red), .sb_green(sb15_green), .sb_blue(sb15_blue), .SBX(SB15X), .SBY(SB15Y));

//logic [11:0] QB2Xsig, QB2Ysig, QB2sizesig;
//parameter [11:0] QB2_X_Start = 548;
//parameter [11:0] QB2_Y_Start = 292;
//
//logic [11:0] QB3Xsig, QB3Ysig, QB3sizesig;
//parameter [11:0] QB3_X_Start = 612;
//parameter [11:0] QB3_Y_Start = 292;	

//=======================================================================================
//	 logic [18:0] marioC1address, marioC2address, marioC3address, marioC4address, marioC1Scroll, marioC2Scroll, marioC3Scroll, marioC4Scroll, address1, address2;
//	 logic mariocollision1;
//	 logic mariocollision2;
//	 
//	 logic mariocollides;
//	 
//	 
//	 assign marioC1address = (((Ball_X_Pos + ScrollX) * 320) / 640) + (((Ball_Y_Pos * 240) / 480) * 1280);
//	 assign marioC2address = (((Ball_X_Pos + ScrollX + Ball_Size) * 320) / 640) + (((Ball_Y_Pos * 240) / 480) * 1280);
//	 assign marioC3address = (((Ball_X_Pos + ScrollX) * 320) / 640) + ((((Ball_Y_Pos + Ball_Size) * 240) / 480) * 1280);
//	 assign marioC4address = (((Ball_X_Pos + ScrollX + Ball_Size) * 320) / 640) + ((((Ball_Y_Pos + Ball_Size) * 240) / 480) * 1280);
//	 
//	 assign marioC1Scroll = (((Ball_X_Pos + 1919 + ScrollX) * 320) / 640) + (((Ball_Y_Pos * 240) / 480) * 1280);
//	 assign marioC2Scroll = (((Ball_X_Pos + 1919 + ScrollX + Ball_Size) * 320) / 640) + (((Ball_Y_Pos * 240) / 480) * 1280);
//	 assign marioC3Scroll = (((Ball_X_Pos + 1919 + ScrollX) * 320) / 640) + ((((Ball_Y_Pos + Ball_Size) * 240) / 480) * 1280);
//	 assign marioC4Scroll = (((Ball_X_Pos + 1919 + ScrollX + Ball_Size) * 320) / 640) + ((((Ball_Y_Pos + Ball_Size) * 240) / 480) * 1280);
//	 
//	 
//	 
//	always_comb begin
//	 if(MARIO_DIRECTION == 0) begin
//		if(ScrollX > 1919) begin
//			address1 = marioC1Scroll;
//			address2 = marioC3Scroll;
//		end
//		else begin
//			address1 = marioC1address;
//			address2 = marioC2address;
//		end
//	 end
//	 else begin
//		address1 = marioC2address;
//		address2 = marioC4address;
//	end
// end
//	 
//	 always_comb begin
//		mariocollides = 1'b0;
//		if(mariocollision1 || mariocollision2)
//			mariocollides = 1'b1;
//	end
//	 
//	 bitMap_rom BITCALL1(.clock(VGA_Clk), .address(address1), .q(mariocollision1));
//	 bitMap_rom BITCALL2(.clock(VGA_Clk), .address(address2), .q(mariocollision2));
 //======================================================================================
	
//	brickFlagBottom = 1'b0;
//
//	//===========================================================================
//	//MARIO COLLISION BOTTOM
//	if  (((MarioY <= BlockY + BlockS) && (MarioY >= BlockY)) &&
//		 
//		 (((MarioX <= BlockX + BlockS) && (MarioX >= BlockX)) ||
//		 
//		 ((MarioX + MarioS >= BlockX) && (MarioX + MarioS <= BlockX + BlockY)))) begin
//		 
//		 brickFlagBottom = 1'b1;
//	
//	end
//	//===========================================================================
	//MARIO COLLISION TOP
	
//		  .Stair1CollisionTop(stair1topsig),
//		  .Stair1CollisionLeft(stair1leftsig),
//		  .Stair1CollisionRight(stair1rightsig),
//		  .Stair1CollisionBottom(stair1bottomsig),
//		  .Stair2CollisionTop(stair2topsig),
//		  .Stair2CollisionLeft(stair2leftsig),
//		  .Stair2CollisionRight(stair2rightsig),
//		  .Stair2CollisionBottom(stair2bottomsig), 
//		  .Stair3CollisionTop(stair3topsig),
//		  .Stair3CollisionLeft(stair3leftsig),
//		  .Stair3CollisionRight(stair3rightsig),
//		  .Stair3CollisionBottom(stair3bottomsig),
//		  .Stair4CollisionTop(stair4topsig),
//		  .Stair4CollisionLeft(stair4leftsig),
//		  .Stair4CollisionRight(stair4rightsig),
//		  .Stair4CollisionBottom(stair4bottomsig),
//		  .Stair5CollisionTop(stair5topsig),
//		  .Stair5CollisionLeft(stair5leftsig),
//		  .Stair5CollisionRight(stair5rightsig),
//		  .Stair5CollisionBottom(stair5bottomsig),
//		  .Stair6CollisionTop(stair6topsig),
//		  .Stair6CollisionLeft(stair6leftsig),
//		  .Stair6CollisionRight(stair6rightsig),
//		  .Stair6CollisionBottom(stair6bottomsig),		  
//		  .Stair7CollisionTop(stair7topsig),
//		  .Stair7CollisionLeft(stair7leftsig),
//		  .Stair7CollisionRight(stair7rightsig),
//		  .Stair7CollisionBottom(stair7bottomsig)