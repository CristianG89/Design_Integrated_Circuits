`timescale 1us/1ns			//Simulation time (how often update values and sets value of delay time units)
							//and precision time (how to round the values)
module tb_RE_Control;
	parameter s_IDLE	 = 2'b00;	//States for the main FSM
	parameter s_EXPOSURE = 2'b01;
	parameter s_READOUT	 = 2'b10;
	
	parameter s_INIT	= 3'b000;	//States for the sub-FSM
	parameter s_NRE_1	= 3'b001;
	parameter s_ADC_1	= 3'b010;
	parameter s_NOTHING	= 3'b011;
	parameter s_NRE_2	= 3'b100;
	parameter s_ADC_2	= 3'b101;
  	parameter s_END		= 3'b110;
	
	reg r_Init = 1'b0;
	reg r_Clock = 1'b0;
	reg r_Reset = 1'b0;
	reg r_Exp_increase = 1'b0;
	reg r_Exp_decrease = 1'b0;
	
	wire w_NRE_1;
	wire w_NRE_2;
	wire w_ADC;
	wire w_Expose;
	wire w_Erase;
	
	wire [4:0] w_count_time;
	wire [1:0] w_Main_FSM;
	wire [2:0] w_RD_FSM;
	wire [1:0] w_RD_timer;
	
	//Instantiation of RE_Control, called UUT (Unit Under Test)
	RE_Control UUT (
		.IN_Init(r_Init),
		.IN_Clock(r_Clock),
		.IN_Reset(r_Reset),
		.IN_Exp_increase(r_Exp_increase),
		.IN_Exp_decrease(r_Exp_decrease),
		.OUT_NRE_1(w_NRE_1),
		.OUT_NRE_2(w_NRE_2),
		.OUT_ADC(w_ADC),
		.OUT_Expose(w_Expose),
		.OUT_Erase(w_Erase),
		.OUT_count_time(w_count_time),
		.OUT_Main_FSM(w_Main_FSM),
		.OUT_RD_FSM(w_RD_FSM),
		.OUT_RD_timer(w_RD_timer)
	);
  	always #2 r_Clock <= !r_Clock;
	
  	initial begin				//Function calls to create a *.vcd file
  		$dumpfile("dump.vcd");	//NECESSARY JUST TO SIMULATE IN edaplayground.com
  		$dumpvars(1);			//WITH EITHER VERILOG OR SYSTEMVERILOG
	end
  
	initial begin	//Initial block
		r_Reset <= 1'b1; #10		//20us seconds
		r_Reset <= 1'b0; #8
      	
		r_Exp_increase <= 1'b1; #8
		r_Exp_increase <= 1'b0; #5
		r_Exp_increase <= 1'b1; #8
		r_Exp_increase <= 1'b0; #5
		r_Exp_increase <= 1'b1; #8
		r_Exp_increase <= 1'b0; #5
		r_Exp_increase <= 1'b1; #8
		r_Exp_increase <= 1'b0; #5
		
		r_Exp_decrease <= 1'b1; #8
		r_Exp_decrease <= 1'b0; #5
		r_Exp_decrease <= 1'b1; #8
		r_Exp_decrease <= 1'b0; #5
		
		r_Init <= 1'b1; #5
		r_Init <= 1'b0; #60
		
		$display("Test Complete");
	end

endmodule	//tb_RE_Control