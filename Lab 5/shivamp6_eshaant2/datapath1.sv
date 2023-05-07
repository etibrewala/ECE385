module datapath1(input logic Clk, Reset,
					 input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
					 input logic GatePC, GateMDR, GateALU, GateMARMUX,
					 input logic MIO_EN,
					 input logic SR1MUX, SR2MUX, ADDR1MUX, MARMUX, DRMUX,
					 output logic [9:0] LED,
					 input logic [15:0] MDR_In,
					 input logic [1:0] PCMUX, ALUK, ADDR2MUX,
					 output logic BEN_Out,
					 output logic [15:0] MDR_Out, MAR_Out, IR_Out, PC_Out
					 );

					 
logic ben_logic, ben_wire;
logic [2:0] nzp_wire, drmux_wire, sr1mux_wire;
logic [3:0] BUS_MUX;
logic [15:0] BUS, pc_mux_wire, ALU_Out, ADDR_Out, MIO_Out, PC_In;
logic [15:0] pc_wire, mdr_wire, alu_wire, addr_wire, ir_wire, mar_wire, 
				 sr1_wire, sr2_wire, sr2mux_out, addr2mux_wire, addr1mux_wire;

assign BUS_MUX = {GatePC,GateMDR,GateALU,GateMARMUX};
//LED-----------------------------

ten_reg LED_REG(.Clk(Clk), .Reset(Reset), .Load(LD_LED), .Data_In(ir_wire[9:0]), .Data_Out(LED));

//--------------------------------

//BUS I/O MUX--------------------------------------------------------------

driver_mux DRIVER(.BUS_MUX(BUS_MUX), .PC_Out(pc_wire), .MDR_Out(mdr_wire), 
						.ALU_Out(alu_wire), .ADDR_Out(addr_wire), .BUS(BUS));
//-------------------------------------------------------------------------
			  

sixteen_reg MDR(.Clk(Clk), .Reset(Reset), .Load(LD_MDR),
						  .Data_In(MIO_Out), .Data_Out(mdr_wire));
						  
two_one_16 MIO(.sel(MIO_EN), .data0(BUS), .data1(MDR_In), .muxOut(MIO_Out));

sixteen_reg MAR(.Clk(Clk), .Reset(Reset), .Load(LD_MAR), .Data_In(BUS), .Data_Out(mar_wire));


pc_mux PC(.PC_select(PCMUX), .BUS(BUS), .PC(pc_wire), .ADDR(addr_wire), .mux_out(pc_mux_wire));

sixteen_reg PCREG(.Clk(Clk), .Reset(Reset), .Load(LD_PC), .Data_In(pc_mux_wire), .Data_Out(pc_wire));
						  
sixteen_reg IR(.Clk(Clk), .Reset(Reset), .Load(LD_IR), .Data_In(BUS), .Data_Out(ir_wire));



//-------NZP LOGIC-------------------------------------------------------------------------

nzp NZP(.Clk(Clk), .Reset(Reset), .LD_CC(LD_CC), .BUS(BUS), .Data_Out(nzp_wire));

assign ben_logic = ((ir_wire[11]&nzp_wire[2]) | (ir_wire[10]&nzp_wire[1]) | (ir_wire[9]&nzp_wire[0]));

ben BEN(.Clk(Clk), .Reset(Reset), .LD_BEN(LD_BEN), .Data_In(ben_logic), .Data_Out(ben_wire));
//------------------------------------------------------------------------------------------


//--------REGISTER FILE------------------------------------------------------------------------------
two_one_3 DRMUX_inst(.sel(DRMUX), .data0(ir_wire[11:9]), .data1(3'b111), .muxOut(drmux_wire));
two_one_3 SR1MUX_inst(.sel(SR1MUX), .data0(ir_wire[11:9]), .data1(ir_wire[8:6]), .muxOut(sr1mux_wire));

register_file  REG_FILE(.Clk(Clk), .Reset(Reset), .LD_REG(LD_REG),.BUS(BUS), .DRMUX_out(drmux_wire),
								.SR1MUX_out(sr1mux_wire), .SR2(ir_wire[2:0]), .SR1_Out(sr1_wire), .SR2_Out(sr2_wire));
//---------------------------------------------------------------------------------------------------



//---------------ALU---------------------------------------------------------------------------------
two_one_16 SR2MUX_inst(.sel(SR2MUX), .data1({{12{ir_wire[4]}},ir_wire[3:0]}), .data0(sr2_wire), .muxOut(sr2mux_out));
always_comb
	begin
	unique case(ALUK)
		2'b00 : alu_wire = sr1_wire + sr2mux_out; //when 0 ADD
		2'b01 : alu_wire = sr1_wire & sr2mux_out; //when 1 AND
		2'b10 : alu_wire = ~sr1_wire; //when 2 NOT
		2'b11 : alu_wire = sr1_wire; //when 3 PASSA
		default: alu_wire = 'x;
	endcase
end

//---------------------------------------------------------------------------------------------------



//----------------ADDR2MUX---------------------------------------------------------------------------
always_comb
	begin
	unique case(ADDR2MUX)
		2'b00 : addr2mux_wire = {16{1'b0}};  //when 0 output = 0
		2'b01 : addr2mux_wire = {{11{ir_wire[5]}},ir_wire[4:0]}; // when 1 SEXT [5:0]
		2'b10 : addr2mux_wire = {{8{ir_wire[8]}},ir_wire[7:0]}; //when 2 SEXT [8:0]
		2'b11 : addr2mux_wire = {{6{ir_wire[10]}},ir_wire[9:0]}; //when 3 SEXT [10:0]
		default : addr2mux_wire = {16{1'bx}};
	endcase
end
	
//---------------------------------------------------------------------------------------------------


//--------------ADDR1MUX-----------------------------------------------------------------------------
always_comb
	begin
	unique case(ADDR1MUX)
		1'b0 : addr1mux_wire = pc_wire;
		1'b1 : addr1mux_wire = sr1_wire;
		default : addr1mux_wire = {16{1'bx}};
	endcase
end
//---------------------------------------------------------------------------------------------------


//-------------------ADDR----------------------------------------------------------------------------
assign addr_wire = addr2mux_wire + addr1mux_wire;
//---------------------------------------------------------------------------------------------------

assign MDR_Out = mdr_wire;
assign MAR_Out = mar_wire;
assign IR_Out =  ir_wire;
assign PC_Out = pc_wire;
assign BEN_Out = ben_wire;
					
endmodule
