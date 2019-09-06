`include "FSM_ex_control.v"
`include "Timer_Counter.v"
`include "CTRL_ex_time.v"

module RE_Control (IN_Init, IN_Clock, IN_Reset, IN_Exp_increase, IN_Exp_decrease, OUT_NRE_1, OUT_NRE_2, OUT_ADC, OUT_Expose, OUT_Erase,
OUT_count_time, OUT_Main_FSM, OUT_RD_FSM, OUT_RD_timer);

  	input IN_Init, IN_Clock, IN_Reset, IN_Exp_increase, IN_Exp_decrease;
	output OUT_NRE_1, OUT_NRE_2, OUT_ADC, OUT_Expose, OUT_Erase;
	
	output [4:0] OUT_count_time;
	output [1:0] OUT_Main_FSM;
	output [2:0] OUT_RD_FSM;
	output [1:0] OUT_RD_timer;
	
	wire [1:0] w_Main_FSM;	//Additional outputs just for checking
	wire [2:0] w_RD_FSM;
	wire [4:0] w_count_time;
	wire [1:0] w_RD_timer;
	
	FSM_ex_control block1 (		//Intermediate connections can only be done with WIREs!!
		.i_Init(IN_Init),
		.i_Clock(IN_Clock),
		.i_Reset(IN_Reset),
		.i_count_time(w_count_time),
		.i_RD_FSM(w_RD_FSM),
		.o_NRE_1(OUT_NRE_1),
		.o_NRE_2(OUT_NRE_2),
		.o_ADC(OUT_ADC),
		.o_Expose(OUT_Expose),
		.o_Erase(OUT_Erase),
		.o_Main_FSM(w_Main_FSM)
	);
	
	CTRL_ex_time block2 (
		.i_Exp_increase(IN_Exp_increase),
		.i_Exp_decrease(IN_Exp_decrease),
		.i_Clock(IN_Clock),
		.i_Reset(IN_Reset),
		.i_Main_FSM(w_Main_FSM),
		.o_count_time(w_count_time)
	);
	
	Timer_Counter block3 (
		.i_Clock(IN_Clock),
		.i_Reset(IN_Reset),
		.i_Main_FSM(w_Main_FSM),
		.o_RD_FSM(w_RD_FSM),
		.o_RD_timer(w_RD_timer)
	);
	
	assign OUT_count_time = w_count_time;
	assign OUT_Main_FSM = w_Main_FSM;
	assign OUT_RD_FSM = w_RD_FSM;
	assign OUT_RD_timer = w_RD_timer;

endmodule //RE_Control