`timescale 100ps/100ps
`define pclk_period 2500
module IISsender_tb();
reg pclk;
wire bclk;
reg presetn;
reg [15:0]datain;
reg wrreq;
wire lrck;
wire data;
//wire [3:0]wrusedw_1;
//wire [4:0]wrusedw_2;
//wire rd_empty_1;
//wire rd_empty_2;
IISsender	test(
	.pclk(pclk),
	.bclk(bclk),
	.presetn(presetn),
	.datain(datain),
	.wrreq(wrreq),
	.lrck(lrck),					//WS
	.data(data)			//SD
//	.wrusedw_1(wrusedw_1),				//CPU发出的
//	.wrusedw_2(wrusedw_2),
//	.rd_empty_1(rd_empty_1),
//	.rd_empty_2(rd_empty_2)
	
	);
reg [255:0]mydata = 256'b1001_1000_1100_0011_1010_0011_1000_0000_1101_1111_0100_1000_1000_1011_1010_0100_0111_1011_0011_1010_0100_1001_0000_0000_0111_1011_0110_1001_0001_0001_0110_1101_0010_0101_0010_1101_0110_0111_0001_1000_0101_1110_0110_0110_1101_1110_0111_0001_1000_1111_0011_0101_1001_0110_1011_1101_1100_1101_0110_1100_1001_0110_1010_0001;
always#(`pclk_period/2) pclk = ~pclk;
always@(posedge pclk or negedge presetn)
begin
if(!presetn)
	datain <= 16'b0;
else if(wrreq == 1'b1)
begin
	datain <= mydata[15:0];
	mydata <= {mydata[15:0],mydata[255:16]};
end
else
	datain <= 16'b0;
end
initial
begin
	pclk = 1'b0;
	presetn = 1'b0;
	#(`pclk_period + 1000);
	presetn = 1'b1;
	wrreq = 1'b1;
	#(`pclk_period *1500);
	$stop;
end
endmodule