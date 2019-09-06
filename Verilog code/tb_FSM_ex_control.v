`timescale 1us/1ns			//Simulation time (how often update values and sets value of delay time units)
							//and precision time (how to round the values)
module tb_FSM_ex_control;
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

	reg r_Init		= 1'b0;
	reg r_Clock		= 1'b0;
	reg r_Reset		= 1'b0;
	reg [4:0] r_count_time = 5'd30;
	reg [2:0] r_RD_FSM = s_INIT;
	
	wire w_NRE_1;
	wire w_NRE_2;
	wire w_ADC;
	wire w_Expose;
	wire w_Erase;
	wire [1:0] w_Main_FSM;
	
	//Instantiation of FSM_ex_control, called UUT (Unit Under Test)
	FSM_ex_control UUT (
		.i_Init(r_Init),
		.i_Clock(r_Clock),
		.i_Reset(r_Reset),
		.i_count_time(r_count_time),
		.i_RD_FSM(r_RD_FSM),
		.o_NRE_1(w_NRE_1),
		.o_NRE_2(w_NRE_2),
		.o_ADC(w_ADC),
		.o_Expose(w_Expose),
		.o_Erase(w_Erase),
		.o_Main_FSM(w_Main_FSM)
	);
  	always #2.5 r_Clock <= !r_Clock;
	
  	initial begin				//Function calls to create a *.vcd file
  		$dumpfile("dump.vcd");	//NECESSARY JUST TO SIMULATE IN edaplayground.com
  		$dumpvars(1);			//WITH EITHER VERILOG OR SYSTEMVERILOG
	end
  
	initial begin	//Initial block
		r_Reset <= 1'b1; #10	//20us seconds
		r_Reset <= 1'b0; #10
		
      	r_Init <= 1'b1; #5
      	r_Init <= 1'b0; #40
		r_count_time <= 5'd0;
		
		r_RD_FSM <= s_INIT;		#10
		r_RD_FSM <= s_NRE_1;	#10
		r_RD_FSM <= s_ADC_1;	#10
		r_RD_FSM <= s_NRE_1;	#10
		r_RD_FSM <= s_NOTHING;	#10
		r_RD_FSM <= s_NRE_2;	#10
		r_RD_FSM <= s_ADC_2;	#10
		r_RD_FSM <= s_NRE_2;	#10
		r_RD_FSM <= s_END;		#10
		
		$display("Test Complete");
	end

endmodule	//tb_FSM_ex_control