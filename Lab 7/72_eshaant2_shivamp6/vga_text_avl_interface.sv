/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

0x000-0x4AF : VRAM


VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [11:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

//COLOR PALETTE local registers
logic [31:0] COLOR_PALETTE[8];

//local variables for VGA_Controller instantiation
logic vga_clk;
logic blank, sync;
logic [9:0] drawxsig, drawysig;

//local variables for font rom instantiation
logic [0:7] fontdata;
logic [10:0] addrsig;

//local variables for OCM instantiation
logic [31:0] memoryOut;
logic [16:0] word_address;


//local variables for color and characters
logic [9:0] charX, charY;

logic[3:0] foreground, background, temp;

logic [31:0] regValue;
logic [16:0] regidx;
logic [16:0] charidx;
logic [16:0] rmo;

logic[31:0] tempRead;


logic [7:0] drawVal;
logic [9:0] index;
logic [31:0] colorVal;

logic pixel;
assign pixel = fontdata[drawxsig[2:0]];

	
vga_controller VGA(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(vga_clk), 
							.blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));
							
font_rom FONT(.addr(addrsig), .data(fontdata));

ram OCM(.address_a(AVL_ADDR), .address_b(word_address), .byteena_a(AVL_BYTE_EN),
		  .clock(CLK), .data_a(AVL_WRITEDATA), .data_b(), .rden_a(AVL_READ & AVL_CS), .rden_b(1'b1), 
		  .wren_a(AVL_WRITE & AVL_CS & ~AVL_ADDR[11]),
		  .wren_b(1'b0), .q_a(tempRead), .q_b(memoryOut));
		  

always_comb begin
	charX = drawxsig[9:3]; //divide by 8
	charY = drawysig[9:4]; //divide by 16
	
	rmo = (80*charY+charX); //row major order for byte address
	
	word_address = rmo[16:1]; //row major order/2
	
	if (!rmo[0]) begin
		drawVal = memoryOut[14:8];
		foreground = memoryOut[7:4];
		background = memoryOut[3:0];
	end
	
	else begin
		drawVal = memoryOut[30:24];
		foreground = memoryOut[23:20];
		background = memoryOut[19:16];
	end
	
	addrsig = {drawVal[6:0],drawysig[3:0]};
	
end
		  

always_ff @(posedge CLK) begin
	if(AVL_ADDR[11] & AVL_CS) begin
	
		if(AVL_WRITE) begin
			COLOR_PALETTE[AVL_ADDR[2:0]] = AVL_WRITEDATA;
		end
		
		if(AVL_READ) begin
			AVL_READDATA = COLOR_PALETTE[AVL_ADDR[2:0]];
		end
	end
	else if(AVL_CS & AVL_READ) begin
	AVL_READDATA = tempRead;
	end
end
		  

always_ff @ (posedge vga_clk) begin
	red <= '0;
	blue <= '0;
	green <= '0;
	
	if(blank) begin
		if(pixel) begin
			temp <= foreground;

				
		end else begin
			temp <= background;			
		end
		
		colorVal <= COLOR_PALETTE[temp/2];
		
		if(temp%2)begin
			red <= colorVal[24:21];
			green <= colorVal[20:17];
			blue <= colorVal[16:13];
			 
		end else begin
			red <= colorVal[12:9];
			green <= colorVal[8:5];
			blue <= colorVal[4:1];
		
		end
	end
end

	
endmodule

