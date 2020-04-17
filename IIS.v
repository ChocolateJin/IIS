module IIS(
	pclk,
	presetn,
	datain,
	wrreq,
	VolL,
	VolR
);
	input pclk;
	input presetn;
	input [15:0]datain;
	input wrreq;
	output [15:0]VolL;
	output [15:0]VolR;
	wire lrck_middle;		//发送端到接收端的连线
	wire bclk_middle;		//发送端到接收端的连线
	wire data_middle;		//发送端到接收端的连线
IISsender	IISsender(
	.pclk(pclk),
	.presetn(presetn),
	.datain(datain),
	.wrreq(wrreq),
	.lrck(lrck_middle),					//WS
	.data(data_middle),				//SD
	.bclk(bclk_middle)
	);
IISreceiver	L(
	.presetn(presetn),
	.bclk(bclk_middle),
	.LRCK(~lrck_middle),
	.datain(data_middle),
	.Vol(VolL)
);
IISreceiver	R(
	.presetn(presetn),
	.bclk(bclk_middle),
	.LRCK(lrck_middle),
	.datain(data_middle),
	.Vol(VolR)
);
endmodule