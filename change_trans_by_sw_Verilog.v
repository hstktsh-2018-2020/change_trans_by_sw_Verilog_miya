`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:27:31 02/01/2018 
// Design Name: 
// Module Name:    change_trans_by_sw_Verilog 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

//array size:7*7
module check_all_transducers_Verilog(
	input			CLK,
	input			PSW0,

	 output  LED0,
	 output  LED1,
	 output  LED2
	
   output		trans1,
   output		trans2,
	output		trans3,
	output		trans4,
	output		trans5,
	output		trans6,
	output		trans7,
	output		trans8,
	output		trans9,
	output		trans10,
	output		trans11,
	output		trans12,
	output		trans13,
	output		trans14,
	output		trans15,
	output		trans16,
	output		trans17,
	output		trans18,
	output		trans19,
	output		trans20,
	output		trans21,
	output		trans22,
	output		trans23,
	output		trans24,
	output		trans25,
	output		trans26,
	output		trans27,
	output		trans28,
	output		trans29,
	output		trans30,
	output		trans31,
	output		trans32,
	output		trans33,
	output		trans34,
	output		trans35,
	output		trans36,
	output		trans37,
	output		trans38,
	output		trans39,
	output		trans40,
	output		trans41,
	output		trans42,
	output		trans43,
	output		trans44,
	output		trans45,
	output		trans46,
	output		trans47,
	output		trans48,
	output		trans49
	
	);

	//define signals
	reg [10:0]	pwm_base_reg = 11'h000;
	reg [9:0]	pwm_duty_reg = 10'h000;
	reg [6:0]	base_cycle_counter_reg = 7'h00;
	reg [15:0]	count_base_reg = 16'h0000;
	
	reg [19:0]	count_reg = 20'h00000;
	reg [1:0]	psw0_reg = 2'h0;
	reg [2:0]	psw0_smp_reg = 3'h0;
	reg 			psw0_filt_reg = 1'h0;
	reg [6:0]	select_trans_reg = 7'h00;

	
	wire 			pwmbp;
	wire 			pwm_out;
	wire 			countbp;
	wire 			count_reset;
	
	wire 			psw0_filt;
	wire 			psw0_filt_pos;


	//PWM Base Cycle Generate
	
	// Calculation
	//	base count = 50[MHz] / 40 [kHz] = 1250 -> 0 ~ 1249 -> 1250 count
	
	always @(posedge CLK) begin  //CB16RE
		if (pwmbp == 1'b1) begin  //R:pwmbp
			pwm_base_reg <= 11'h000;  //h:hexadecimal, assign 0 to all bits
		end
		else begin
			pwm_base_reg <= pwm_base_reg + 1'b1;  //increment
		end
	end
	
	assign pwmbp = (pwm_base_reg[10:0] == 11'd1249) ? 1'b1 : 1'b0;  //COMP16

	//PWM Duty Ratio Generate
	always @(posedge CLK) begin  //CB16RE
		if (pwmbp == 1'b1) begin  //R:pwmbp
			pwm_duty_reg <= 11'h000;
		end
		else if (pwm_out == 1'b1) begin  //CE:pwm_out
			pwm_duty_reg <= pwm_duty_reg + 1'b1;
		end
	end

	//duty ratio = 50% -> 1250 / 2 = 625
		assign pwm_out = (pwm_duty_reg[9:0] == 10'd624) ? 1'b0 : 1'b1;  //COMP16
		
	
	
	//メタステーブル対策用
	always @(posedge CLK) begin
		psw0_reg <={psw0_reg[0],PSW0};
	end
	
	//低速サンプリング用パルス生成部
	always @(posedge CLK) begin
		if (count_reg[19] == 1'b1) begin
			count_reg <= 20'd0;
		end
		else begin
			count_reg <= count_reg + 1'b1;
		end
	end
	
	//低速サンプリング部
	always @(posedge CLK) begin
		if (count_reg[19] == 1'b1) begin	
			psw0_smp_reg <= {psw0_smp_reg[1:0], psw0_reg[1]};
		end
	end
	
	assign psw0_filt = (~psw0_smp_reg[0] &  psw0_smp_reg[1] &  psw0_smp_reg[2]) |
							( psw0_smp_reg[0] & ~psw0_smp_reg[1] &  psw0_smp_reg[2]) |
							( psw0_smp_reg[0] &  psw0_smp_reg[1] & ~psw0_smp_reg[2]) |
							( psw0_smp_reg[0] &  psw0_smp_reg[1] &  psw0_smp_reg[2]) ;
					
	//微分回路
	always @(posedge CLK) begin
		psw0_filt_reg <= psw0_filt;
	end
	
	assign psw0_filt_pos = psw0_filt & (~psw0_filt_reg);
	
	always @(posedge CLK) begin
		if (psw0_filt_pos == 1'b1) begin
			select_trans_reg <= select_trans_reg + 1'b1;
		end
	end
	
	
	
	//To transducers
	assign trans1 = (select_trans_reg[6:0] == 7'd0) ? pwm_out : 1'b0;
	assign trans2 = (select_trans_reg[6:0] == 7'd2) ? pwm_out : 1'b0;
	assign trans3 = (select_trans_reg[6:0] == 7'd4) ? pwm_out : 1'b0;
	assign trans4 = (select_trans_reg[6:0] == 7'd6) ? pwm_out : 1'b0;
	assign trans5 = (select_trans_reg[6:0] == 7'd8) ? pwm_out : 1'b0;
	assign trans6 = (select_trans_reg[6:0] == 7'd10) ? pwm_out : 1'b0;
	assign trans7 = (select_trans_reg[6:0] == 7'd12) ? pwm_out : 1'b0;
	assign trans8 = (select_trans_reg[6:0] == 7'd14) ? pwm_out : 1'b0;
	assign trans9 = (select_trans_reg[6:0] == 7'd16) ? pwm_out : 1'b0;
	assign trans10 = (select_trans_reg[6:0] == 7'd18) ? pwm_out : 1'b0;
	assign trans11 = (select_trans_reg[6:0] == 7'd20) ? pwm_out : 1'b0;
	assign trans12 = (select_trans_reg[6:0] == 7'd22) ? pwm_out : 1'b0;
	assign trans13 = (select_trans_reg[6:0] == 7'd24) ? pwm_out : 1'b0;
	assign trans14 = (select_trans_reg[6:0] == 7'd26) ? pwm_out : 1'b0;
	assign trans15 = (select_trans_reg[6:0] == 7'd28) ? pwm_out : 1'b0;
	assign trans16 = (select_trans_reg[6:0] == 7'd30) ? pwm_out : 1'b0;
	assign trans17 = (select_trans_reg[6:0] == 7'd32) ? pwm_out : 1'b0;
	assign trans18 = (select_trans_reg[6:0] == 7'd34) ? pwm_out : 1'b0;
	assign trans19 = (select_trans_reg[6:0] == 7'd36) ? pwm_out : 1'b0;
	assign trans20 = (select_trans_reg[6:0] == 7'd38) ? pwm_out : 1'b0;
	assign trans21 = (select_trans_reg[6:0] == 7'd40) ? pwm_out : 1'b0;
	assign trans22 = (select_trans_reg[6:0] == 7'd42) ? pwm_out : 1'b0;
	assign trans23 = (select_trans_reg[6:0] == 7'd44) ? pwm_out : 1'b0;
	assign trans24 = (select_trans_reg[6:0] == 7'd46) ? pwm_out : 1'b0;
	assign trans25 = (select_trans_reg[6:0] == 7'd48) ? pwm_out : 1'b0;
	assign trans26 = (select_trans_reg[6:0] == 7'd50) ? pwm_out : 1'b0;
	assign trans27 = (select_trans_reg[6:0] == 7'd52) ? pwm_out : 1'b0;
	assign trans28 = (select_trans_reg[6:0] == 7'd54) ? pwm_out : 1'b0;
	assign trans29 = (select_trans_reg[6:0] == 7'd56) ? pwm_out : 1'b0;
	assign trans30 = (select_trans_reg[6:0] == 7'd58) ? pwm_out : 1'b0;
	assign trans31 = (select_trans_reg[6:0] == 7'd60) ? pwm_out : 1'b0;
	assign trans32 = (select_trans_reg[6:0] == 7'd62) ? pwm_out : 1'b0;
	assign trans33 = (select_trans_reg[6:0] == 7'd64) ? pwm_out : 1'b0;
	assign trans34 = (select_trans_reg[6:0] == 7'd66) ? pwm_out : 1'b0;
	assign trans35 = (select_trans_reg[6:0] == 7'd68) ? pwm_out : 1'b0;
	assign trans36 = (select_trans_reg[6:0] == 7'd70) ? pwm_out : 1'b0;
	assign trans37 = (select_trans_reg[6:0] == 7'd72) ? pwm_out : 1'b0;
	assign trans38 = (select_trans_reg[6:0] == 7'd74) ? pwm_out : 1'b0;
	assign trans39 = (select_trans_reg[6:0] == 7'd76) ? pwm_out : 1'b0;
	assign trans40 = (select_trans_reg[6:0] == 7'd78) ? pwm_out : 1'b0;
	assign trans41 = (select_trans_reg[6:0] == 7'd80) ? pwm_out : 1'b0;
	assign trans42 = (select_trans_reg[6:0] == 7'd82) ? pwm_out : 1'b0;
	assign trans43 = (select_trans_reg[6:0] == 7'd84) ? pwm_out : 1'b0;
	assign trans44 = (select_trans_reg[6:0] == 7'd86) ? pwm_out : 1'b0;
	assign trans45 = (select_trans_reg[6:0] == 7'd88) ? pwm_out : 1'b0;
	assign trans46 = (select_trans_reg[6:0] == 7'd90) ? pwm_out : 1'b0;
	assign trans47 = (select_trans_reg[6:0] == 7'd92) ? pwm_out : 1'b0;
	assign trans48 = (select_trans_reg[6:0] == 7'd94) ? pwm_out : 1'b0;
	assign trans49 = (select_trans_reg[6:0] == 7'd96) ? pwm_out : 1'b0;
	
	assign LED0 = (select_trans_reg[6:0] == 7'd0)? 1'b1 :  (select_trans_reg[6:0] == 7'd1)? 1'b0 : 1'b0 ;
	assign LED1 = (select_trans_reg[6:0] == 7'd1)? 1'b1 : (select_trans_reg[6:0] == 7'd3)? 1'b1:1'b0 ;
	assign LED2 = (select_trans_reg[6:0] == 7'd2)? 1'b1 : 1'b0 ;

endmodule
