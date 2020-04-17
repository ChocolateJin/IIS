module senderpart(
	pclk,
	presetn,
	datain,
	is_empty,
	lrck,
	data,
	bclk,
	rd_en
);
input pclk;
input presetn;
input datain;
input is_empty;					//FIFO2给的读空信号
output lrck;
output data;
output rd_en;	
output bclk;
reg bclk_en;
reg[5:0]bclk_cnt;
reg rd_en_reg;
reg[6:0]lrckcnt;
reg lrck_reg;
//always@(negedge pclk or negedge presetn)			//WS产生器
//	begin
//		if(!presetn)
//		begin
//			lrckcnt <= 7'd0;
//			lrck_reg	<= 1'b0;
//		end
//		else
//				if(lrckcnt ==7'd44)							//一次计数持续一整个WS周期，在数到第45次和90次时反转WS信号
//				begin
//					lrck_reg <= ~lrck_reg;
//					lrckcnt <= lrckcnt +1'b1;
//				end
//				else if (lrckcnt ==7'd89)
//				begin
//					lrck_reg <= ~lrck_reg;
//					lrckcnt <= 7'd0;
//				end
//				else
//					lrckcnt <=lrckcnt +1'b1;
//		end
//	end
//	
always@(posedge pclk or negedge presetn)			//WS产生器
	begin
		if(!presetn)
		begin
			lrckcnt <= 7'd0;
			lrck_reg	<= 1'b0;
		end
		else
		begin
			if(!is_empty)
				begin
					if(lrckcnt ==7'd44)							//一次计数持续一整个WS周期，在数到第45次和90次时反转WS信号
					begin
						lrck_reg <= ~lrck_reg;
						lrckcnt <= lrckcnt +1'b1;
					end
					else if (lrckcnt ==7'd89)
					begin
						lrck_reg <= ~lrck_reg;
						lrckcnt <= 7'd0;
					end
					else
						lrckcnt <=lrckcnt +1'b1;
				end
			else
				lrckcnt <= 7'd0;
		end
	end
reg lrck_reg_delay1;
reg lrck_reg_delay2;
always@(posedge pclk or negedge presetn)			//WS打两排
begin
	if(!presetn)
	begin
		lrck_reg_delay1 <= 1'b0;
		lrck_reg_delay2 <= 1'b0;
	end
	else
	begin
		lrck_reg_delay1 <= lrck_reg;
		lrck_reg_delay2 <= lrck_reg_delay1;
	end
end
reg lrck_reg_delay3;
always@(negedge pclk or negedge presetn)			//WS再打半拍
begin
	if(!presetn)
		lrck_reg_delay3 <= 1'b0;
	else
		lrck_reg_delay3 <= lrck_reg_delay2;
end
	

always@(posedge pclk or negedge presetn)		//bclk产生模块
begin
	if(!presetn)
		bclk_cnt <= 6'd63;
	else if(!is_empty)
	begin
		if(bclk_cnt ==6'd44)
			bclk_cnt <= 6'd0;
		else
			bclk_cnt <= bclk_cnt +1'b1;
	end
	else
		bclk_cnt <= 6'd63;
end														//bclk使能标志
always@(negedge pclk or negedge presetn)
begin
	if(!presetn)
		bclk_en = 1'b0;
	else if(!is_empty)
	begin
	if(bclk_cnt <18)
		bclk_en <=1'b1;
	else
		bclk_en <=1'b0;
	end
	else
		bclk_en <=1'b0;
end

//reg datain_delay1;			//datain打半拍（可删除）
//always@(negedge  pclk or negedge presetn)
//begin
//	if(!presetn)
//		datain_delay1 <= 1'b0;
//	else
//		datain_delay1 <= datain;
//end
always@(negedge pclk or negedge presetn)			//读使能发出模块
begin
	if(!presetn)
		rd_en_reg <= 1'b0;
	else if(!is_empty)
		case(bclk_cnt)
		1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16:rd_en_reg <=1'b1;
		default: rd_en_reg <= 1'b0;
		endcase
end
assign lrck = lrck_reg_delay3;
//assign rd_en = bclk_cnt < 16 && !is_empty;
assign rd_en = rd_en_reg;
assign data =datain;
assign bclk = pclk &&bclk_en;

endmodule 