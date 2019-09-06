`timescale 1us/1ns			//Simulation time (how often update values and sets value of delay time units)
							//and precision time (how to round the values)
module tb_Timer_Counter;
	parameter s_IDLE 		= 2'b00;
	parameter s_EXPOSURE	= 2'b01;
	parameter s_READOUT 	= 2'b10;

	parameter s_INIT	= 3'b000;
	parameter s_NRE_1	= 3'b001;
	parameter s_ADC_1	= 3'b010;
	parameter s_NOTHING	= 3'b011;
	parameter s_NRE_2	= 3'b100;
	parameter s_ADC_2	= 3'b101;
  	parameter s_END		= 3'b110;
	
	reg r_Clock = 1'b0;
	reg r_Reset = 1'b0;
  	reg [1:0] r_Main_FSM = s_IDLE;
	
  	wire [2:0] w_RD_FSM;
  	wire [1:0] w_RD_timer;
	
	//Instantiation of Timer_Counter, called UUT (Unit Under Test)
	Timer_Counter UUT (
		.i_Clock(r_Clock),
		.i_Reset(r_Reset),
		.i_Main_FSM(r_Main_FSM),
      	.o_RD_FSM(w_RD_FSM),
		.o_RD_timer(w_RD_timer)
	);
  	always #2 r_Clock <= !r_Clock;
	
  	initial begin				//Function calls to create a *.vcd file
  		$dumpfile("dump.vcd");	//NECESSARY JUST TO SIMULATE IN edaplayground.com
  		$dumpvars(1);			//WITH EITHER VERILOG OR SYSTEMVERILOG
	end
  
	initial begin	//Initial block
		r_Reset <= 1'b1; #6	//6us seconds
		r_Reset <= 1'b0; #6
      	r_Main_FSM <= s_READOUT;
		
		$display("Test Complete");
	end

endmodule	//tb_Timer_Counter