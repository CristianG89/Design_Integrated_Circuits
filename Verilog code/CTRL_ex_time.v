module CTRL_ex_time (i_Exp_increase, i_Exp_decrease, i_Clock, i_Reset, i_Main_FSM, o_count_time);
	input i_Exp_increase;
  	input i_Exp_decrease;
  	input i_Clock;
  	input i_Reset;
	input [1:0] i_Main_FSM;
  	output [4:0] o_count_time;
	
	parameter s_IDLE 		= 2'b00;
	parameter s_EXPOSURE	= 2'b01;
	parameter s_READOUT 	= 2'b10;
	
  	reg pre_increase = 1'b0;
  	reg pre_decrease = 1'b0;
	
	reg [4:0] r_count_time = 5'd2;

	always @(posedge i_Clock) begin
		if (i_Reset == 1'b1) begin
			pre_increase = 1'b0;
			pre_decrease = 1'b0;
	
			r_count_time = 5'd2;
		end
		else begin
			case (i_Main_FSM)
				s_IDLE : begin	//Only when FSM is in IDLE state
					if (i_Exp_increase==1'b1 && pre_increase==1'b0)	begin	//Exp_increase goes first because it has priority
						if (r_count_time < 5'd30) begin
							r_count_time <= r_count_time + 1'd1;
						end
						else begin
							r_count_time <= 5'd30;
						end
					end
					else if (i_Exp_decrease==1'b1 && pre_decrease==1'b0) begin
						if (r_count_time > 5'd2) begin
							r_count_time <= r_count_time - 1'd1;
						end
						else begin
							r_count_time <= 5'd2;
						end
					end
					pre_increase <= i_Exp_increase;
					pre_decrease <= i_Exp_decrease;
				end
				s_EXPOSURE : begin	//Only when FSM is in EXPOSURE state
					if (r_count_time > 1'b0) begin
						r_count_time <= r_count_time - 1'd1;
					end
					else begin
						r_count_time <= 5'b0;
					end
				end
				default : begin		//Any other possible case (s_READOUT)
					r_count_time <= 5'b0;
				end
			endcase
		end
	end //always@ (posedge i_Clock)
	
  	assign o_count_time = r_count_time;

endmodule //CTRL_ex_time