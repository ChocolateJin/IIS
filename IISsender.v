module IISsender(
	pclk,
	bclk,
	presetn,
	datain,
	wrreq,
	lrck,					//WS
	data				//SD
//	wrusedw_1,				//测试用，可删除
//	wrusedw_2,
//	rd_empty_1,
//	rd_empty_2

	);
	input wrreq;				//CPU控制的FIFO1的写使能
	input pclk;
	input presetn;
	input [15:0]datain;		//CPU发出的16位数据
	output lrck;
	output data;				
	output bclk;
//	wire [15:0]data_middle_1;	//CPUtoFIFO1
	wire [7:0]data_middle_2;	//FIFO1toFIFO2
	wire data_middle_3;	//FIFO2tosenderpart
	wire [3:0]wrusedw_1;	//FIFO1
	wire [4:0]wrusedw_2;		//FUFO2
	wire rd_empty_1;		//FIFO1的读空信号
	wire rd_empty_2;	//FIFO2的读空信号
//	output rd_empty_1;		//FIFO1的读空信号
//	output rd_empty_2;	//FIFO2的读空信号
	wire rd_req_1;		//FIFO1的逻辑判断
	wire rd_req_2;
	wire wr_req_1;		//连接CPU控制FIFO1信号的写使能
	wire wr_req_2;		//连接FIFO1控制FIFO2的写使能
	wire [15:0]shifter_out;		//shifter to FIFO1
shifter shifter(						//把CPU发来的数据移位
	.datain(datain),
	.dataout(shifter_out)
);
	
	fifo16to8 fifo1(									//移植时只需替换两个fifo，括号内的连线应该不用变动
	.aclr(~presetn),									//FIFO高电平有效复位
	.data(shifter_out),
	.rdclk(pclk),
	.rdreq(rd_req_1),
	.wrclk(pclk),
	.wrreq(wr_req_1),
	.q(data_middle_2),
	.rdempty(rd_empty_1),
	.wrfull(),								//移植的时候可以去掉这个信号
	.wrusedw(wrusedw_1)					//还没接入CPU模块，暂时无用,四位（本来是在CPU模块做写使能的逻辑判断的）
);
fifo8to1 fifo2(
	.aclr(~presetn),
	.data(data_middle_2),
	.rdclk(~pclk),							//rdreq在下降沿判断，配合写使能信号也使用pclk的下降沿，这样给到senderpart的数据就是下降沿的了
	.rdreq(rd_req_2),
	.wrclk(pclk),
	.wrreq(wr_req_2),
	.q(data_middle_3),
	.rdempty(rd_empty_2),
	.wrusedw(wrusedw_2)					//和LINE85做FIFO1读使能的判断
);

senderpart	senderpart(
	.pclk(pclk),
	.presetn(presetn),
	.datain(data_middle_3),
	.is_empty(rd_empty_2),
	.lrck(lrck),
	.data(data),
	.bclk(bclk),
	.rd_en(rd_req_2)
);
reg wr_req_2_reg;
always@(posedge pclk or negedge presetn)			//FIFO1向FIFO2写入内容的时候，让使能标志和数据同时到达FIFO2做的延迟一拍处理
begin
	if(!presetn)
		wr_req_2_reg = 1'b0;
	else
		wr_req_2_reg = rd_req_1;
end


assign rd_req_1 = !rd_empty_1 &&	wrusedw_2 <26;
assign wr_req_2 = wr_req_2_reg;
assign wr_req_1 = wrreq;

endmodule