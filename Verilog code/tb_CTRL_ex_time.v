`timescale 1us/1ns			//Simulation time (how often update values and sets value of delay time units)
							//and precision time (how to round the values)
module tb_CTRL_ex_time;
	parameter s_IDLE 		= 2'b00;
	parameter s_EXPOSURE	= 2'b01;
	parameter s_READOUT 	= 2'b10;
	
	reg r_Exp_increase = 1'b0;
	reg r_Exp_decrease = 1'b0;
	reg r_Clock = 1'b0;
	reg r_Reset = 1'b0;
	reg [1:0] r_Main_FSM = s_IDLE;
	
  	wire [4:0] w_count_time;
	
	//Instantiation of CTRL_ex_time, called UUT (Unit Under Test)
	CTRL_ex_time UUT (
		.i_Exp_increase(r_Exp_increase),
		.i_Exp_decrease(r_Exp_decrease),
		.i_Clock(r_Clock),
		.i_Reset(r_Reset),
		.i_Main_FSM(r_Main_FSM),
      	.o_count_time(w_count_time)
	);
  
  	always #2 r_Clock <= !r_Clock;
	
  	initial begin				//Function calls to create a *.vcd file
  		$dumpfile("dump.vcd");	//NECESSARY JUST TO SIMULATE IN edaplayground.com
  		$dumpvars(1);			//WITH EITHER VERILOG OR SYSTEMVERILOG
	end
  
	initial begin	//Initial block
		r_Reset <= 1'b1; #10	//10us seconds
		r_Reset <= 1'b0;
		r_Main_FSM <= s_IDLE;
		
		r_Exp_increase <= 1'b1; #10
		r_Exp_increase <= 1'b0; #10
		r_Exp_increase <= 1'b1; #10
		r_Exp_increase <= 1'b0; #10
		r_Exp_increase <= 1'b1; #10
		r_Exp_increase <= 1'b0; #10
		r_Exp_increase <= 1'b1; #10
		r_Exp_increase <= 1'b0; #10
		
		r_Exp_decrease <= 1'b1; #10
		r_Exp_decrease <= 1'b0; #10
		r_Exp_decrease <= 1'b1; #10
		r_Exp_decrease <= 1'b0; #10
		
		r_Main_FSM <= s_EXPOSURE;
		
		$display("Test Complete");
	end

endmodule	//tb_CTRL_ex_time