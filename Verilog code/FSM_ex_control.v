module FSM_ex_control (i_Init, i_Clock, i_Reset, i_count_time, i_RD_FSM, o_NRE_1, o_NRE_2, o_ADC, o_Expose, o_Erase, o_Main_FSM);
	input i_Init, i_Clock, i_Reset;
	input [4:0] i_count_time;
	input [2:0] i_RD_FSM;
	output o_NRE_1, o_NRE_2, o_ADC, o_Expose, o_Erase;
	output [1:0] o_Main_FSM;

	parameter s_IDLE	 = 2'b00;
	parameter s_EXPOSURE = 2'b01;
	parameter s_READOUT	 = 2'b10;
	
	parameter s_INIT	= 3'b000;
	parameter s_NRE_1	= 3'b001;
	parameter s_ADC_1	= 3'b010;
	parameter s_NOTHING	= 3'b011;
	parameter s_NRE_2	= 3'b100;
	parameter s_ADC_2	= 3'b101;
  	parameter s_END		= 3'b110;
  
	reg r_NRE_1		= 1'b1;
	reg r_NRE_2		= 1'b1;
	reg r_ADC		= 1'b0;
	reg r_Expose	= 1'b0;
	reg r_Erase 	= 1'b0;
	reg [1:0] r_Main_FSM = s_IDLE;

	always @(posedge i_Clock) begin
		case (i_RD_FSM)
			s_NRE_1 : begin
				r_NRE_1 <= 1'b0;
				r_ADC <= 1'b0;
			end
			s_ADC_1 : begin
				r_NRE_1 <= 1'b0;
				r_ADC <= 1'b1;
			end
			s_NRE_2 : begin
				r_NRE_2 <= 1'b0;
				r_ADC <= 1'b0;
			end
			s_ADC_2 : begin
				r_NRE_2 <= 1'b0;
				r_ADC <= 1'b1;
			end
			default : begin	//s_INIT, s_NOTHING, s_END
				r_NRE_1 <= 1'b1;
				r_NRE_2 <= 1'b1;
				r_ADC <= 1'b0;
			end
		endcase
	end //always@ (posedge i_Clock)
	
	always @(posedge i_Clock) begin
		if (i_Reset == 1'b1) begin
			r_Main_FSM <= s_IDLE;
		end
		else begin
			case (r_Main_FSM)
				s_IDLE : begin
					r_Expose <= 1'b0;	//I make sure no current is read from Photodiode
					r_Erase <= 1'b1;	//Capacitor must discharge for next picture
					if (i_Init == 1'b1) begin
						r_Main_FSM <= s_EXPOSURE;
					end
				end
				s_EXPOSURE : begin
					r_Expose <= 1'b1;	//Time to read the current from Photodiode
					r_Erase <= 1'b0;	//Capacitor is being charged, so no discharged allowed
					if (i_count_time == 1'b0) begin //This state must hold while the counter is not 0
						r_Main_FSM <= s_READOUT;
					end
				end
				s_READOUT : begin
					r_Expose <= 1'b0;	//The light has already been taken, so no more is taken
					r_Erase <= 1'b0;	//Capacitor must hold the data to sent it through the ADC
					if (i_RD_FSM == s_END) begin //This state must hold until the timer process finishes
						r_Main_FSM <= s_IDLE;
					end
				end
				default : begin
					r_Main_FSM <= s_IDLE;
				end
			endcase
		end
	end //always@ (posedge i_Clock)

	assign o_NRE_1	= r_NRE_1;
	assign o_NRE_2	= r_NRE_2;
	assign o_ADC 	= r_ADC;
	assign o_Expose	= r_Expose;
	assign o_Erase	= r_Erase;
	assign o_Main_FSM = r_Main_FSM;

endmodule //FSM_ex_control