module IISreceiver(
	presetn,
	bclk,
	LRCK,
	datain,
	Vol
);
	input presetn;
	input bclk;
	input LRCK;
	input datain;
	output [15:0]Vol;
reg LRCK_d;
always@(posedge bclk) LRCK_d <= LRCK; // WS打一拍

reg [16:0] data; // 缓存数据，最高位表示是否完成
always@(posedge bclk or negedge presetn) // 移位寄存进程
begin
    if(!presetn) // 复位或不计数
        data <= 17'b1; // 最低位置1，当其被移动到第17位时，说明移动了16次
    else if(LRCK_d) 
	 begin// WS使能时才移位
        if(data[16]==1)
            data <= data; // 停止
        else
            data <= {data[15:0], datain};
    end
	 else
		data <= 17'b1;
end
//assign finish_flag=data[16];

reg [15:0]Vol_reg;
// 电压输出进程
always@(posedge bclk or negedge presetn)
    if(!presetn)
        Vol_reg <= 0;
    else if(data[16]==1)
        Vol_reg <= data[15:0];
    else
        Vol_reg <= Vol_reg;
assign Vol = Vol_reg;
//assign data_out = data;
//assign LRCK_d_out =LRCK_d;
endmodule
