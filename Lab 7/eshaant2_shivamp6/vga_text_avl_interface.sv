/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

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
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

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
	input  logic [9:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);


logic [31:0] LOCAL_REG   [`NUM_REGS]; // Registers


//put other local variables here

logic vga_clk;
logic blank, sync;
logic [9:0] drawxsig, drawysig;
logic [0:7] fontdata;
//logic [4:0] charX;
//logic [5:0] charY;
logic [31:0] regValue;


logic [9:0] charX;
logic [9:0] charY;
logic [16:0] regidx;
logic [16:0] charidx;
logic [16:0] rmo;


logic [7:0] drawVal;
logic [10:0] addrsig;
logic [9:0] index;


always_comb begin



	charX = drawxsig[9:3];
	charY = drawysig[9:4];
	rmo = 80 * charY + charX;
		
	regidx = rmo[16:2]; //RMO/4
	charidx = rmo[1:0]; //RMO%4
	
	regValue = LOCAL_REG[regidx]; 

	
	case(charidx[1:0])
		2'b11 : drawVal[7:0] = regValue[31:24];
		2'b10 : drawVal[7:0] = regValue[23:16];
		2'b01 : drawVal[7:0] = regValue[15:8];
		2'b00 : drawVal[7:0] = regValue[7:0];
	endcase
	addrsig = {drawVal[6:0], drawysig[3:0]};


	
end

logic pixel;
assign pixel = fontdata[drawxsig[2:0]];
 
//Declare submodules..e.g. VGA controller, ROMS, etc
	
vga_controller VGA(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(vga_clk), 
							.blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));
							
font_rom FONT(.addr(addrsig), .data(fontdata));
   
// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) begin
	
	if(AVL_CS & !RESET) begin
	
		if(AVL_READ) begin
			AVL_READDATA[31:0] <= LOCAL_REG[AVL_ADDR][31:0];
		end
		
		else if(AVL_WRITE) begin
			case(AVL_BYTE_EN)
				4'b1111 : LOCAL_REG[AVL_ADDR][31:0] <= AVL_WRITEDATA[31:0];
				4'b1100 : LOCAL_REG[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
				4'b0011 : LOCAL_REG[AVL_ADDR][15:0] <= AVL_WRITEDATA[15:0];
				4'b1000 : LOCAL_REG[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
				4'b0100 : LOCAL_REG[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
				4'b0010 : LOCAL_REG[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
				4'b0001 : LOCAL_REG[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
			endcase
		end
	end
end


//handle drawing (may either be combinational or sequential - or both).


always_ff @ (posedge vga_clk) begin
	red <= '0;
	blue <= '0;
	green <= '0;
	
	if(blank) begin
		if(pixel ^ drawVal[7]) begin
			red <= LOCAL_REG[600][24:21];
			green <= LOCAL_REG[600][20:17];
			blue <= LOCAL_REG[600][16:13];
		end else begin
			red <= LOCAL_REG[600][12:9];
			green <= LOCAL_REG[600][8:5];
			blue <= LOCAL_REG[600][4:1];
		end
	end

end

	
endmodule
