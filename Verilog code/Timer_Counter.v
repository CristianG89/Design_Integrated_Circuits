module Timer_Counter (i_Clock, i_Reset, i_Main_FSM, o_RD_FSM, o_RD_timer);
  	input i_Clock;
  	input i_Reset;
	input [1:0] i_Main_FSM;
	output [2:0] o_RD_FSM;
	output [1:0] o_RD_timer;

	parameter s_READOUT = 2'b10;
	
	parameter s_INIT	= 3'b000;
	parameter s_NRE_1	= 3'b001;
	parameter s_ADC_1	= 3'b010;
	parameter s_NOTHING	= 3'b011;
	parameter s_NRE_2	= 3'b100;
	parameter s_ADC_2	= 3'b101;
  	parameter s_END		= 3'b110;
	
  	reg [2:0] r_RD_FSM = s_INIT;
	reg [1:0] r_RD_timer = 2'b00;

	always @(posedge i_Clock) begin
		if (i_Reset == 1'b1) begin
			r_RD_timer <= 2'b00;
			r_RD_FSM <= s_INIT;
		end
		if (i_Main_FSM == s_READOUT) begin		//Only when FSM is in s_READOUT state
			r_RD_timer <= r_RD_timer + 2'b01;
			case (r_RD_FSM)
				s_INIT : begin
					r_RD_FSM <= s_NRE_1;
				end
				s_NRE_1 : begin
          			if (r_RD_timer == 2'b01) begin
						r_RD_FSM <= s_ADC_1;
					end
					else if (r_RD_timer == 2'b11) begin
						r_RD_timer <= 2'b00;
						r_RD_FSM <= s_NOTHING;
					end
				end
				s_ADC_1 : begin
					r_RD_FSM <= s_NRE_1;
				end
				s_NOTHING : begin
					r_RD_FSM <= s_NRE_2;
				end
				s_NRE_2 : begin
                  	if (r_RD_timer == 2'b01) begin
						r_RD_FSM <= s_ADC_2;
					end if (r_RD_timer == 2'b11) begin
						r_RD_timer <= 2'b00;
						r_RD_FSM <= s_END;
					end
				end
				s_ADC_2 : begin
					r_RD_FSM <= s_NRE_2;
				end
              	s_END : begin
					r_RD_timer <= 2'b00;
					r_RD_FSM <= s_INIT;
				end
				default : begin
					r_RD_timer <= 2'b00;
					r_RD_FSM <= s_INIT;
				end
			endcase
		end
		else begin	//In any other possible case
			r_RD_timer <= 2'b00;
		end
	end //always@ (posedge i_Clock)
	
	assign o_RD_FSM = r_RD_FSM;
	assign o_RD_timer = r_RD_timer;

endmodule //Timer_Counter