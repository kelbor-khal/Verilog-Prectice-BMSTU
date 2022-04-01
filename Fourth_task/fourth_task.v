`timescale 1ns/1ns

module fourth_task ( input wire [7:0] input_value,
               output reg [15:0] output_value );
    reg X;
    reg CLK = 1; 
    reg [1:0] count_cicle = 0;

    reg [7:0] buff_inp_value1,
              buff_inp_value2, 
              buff_out_value = 0,
              coeff_A = 8'b00000010,
              coeff_B = 8'b00000011;

    reg [15:0] res_mult1, 
               res_mult2,
               res_mult3;

    initial
    forever #1 CLK = ~CLK;

    /* запись новых данных */
    always @(*) begin
            buff_inp_value1 <= input_value;
    end

    /* условия для счетчика */
    always @( posedge CLK ) begin
        buff_inp_value2 <= buff_inp_value1;
        if ( count_cicle == 1 )
            count_cicle <= 0;
        else
            count_cicle <= count_cicle + 1;
    end

    always @(*)
        res_mult1 <= input_value * coeff_B;

    always @(posedge CLK) begin
        res_mult3 <= res_mult1;
        res_mult2 <= buff_out_value * coeff_A;
    end

    always @(*) begin
        output_value <= res_mult3 + res_mult2;
        if ( output_value != X )
            buff_out_value <= output_value;
        else
            buff_out_value <= 0;     
    end

endmodule
