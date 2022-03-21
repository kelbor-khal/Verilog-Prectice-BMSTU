`timescale 1ns/1ns

module Task1 ( input wire [7:0] op_1, op_2, op_3, op_4,
               output reg [15:0] REAL_PART_NUM, IMAG_PART_NUM );

    reg [7:0]  a1, b1, a2, b2, num1, num2;
    reg [15:0] MULT_RESULT, BUFF;

    reg CLK =1, WRITE_NEW_DATA = 1, IN_MULT = 0;
    reg [1:0] CALK_COUNT = 0;

    initial
    forever #1 CLK = ~CLK;

    initial
    forever begin
            #2 WRITE_NEW_DATA = ~ WRITE_NEW_DATA; 
            #6 WRITE_NEW_DATA = ~ WRITE_NEW_DATA;
    end

    always @(*)
    begin
            if ( CALK_COUNT == 0 ) begin
                num1 = a1 ; num2 = a2 ;
            end

            else if ( CALK_COUNT == 1 ) begin
                num1 = b1 ; num2 = b2 ;
            end

            else if ( CALK_COUNT == 2 ) begin
                num1 = a1 ; num2 = b2 ;
            end

            else begin
                num1 = b1 ; num2 = a2 ;
            end
    end

    reg VAL_OUT;    

    always @(*)
        MULT_RESULT = num1 * num2;

    always @(posedge CLK) begin

        if (WRITE_NEW_DATA)
        begin
            CALK_COUNT <= 0;
            a1 <= op_1 ; 
            b1 <= op_2 ; 
            a2 <= op_3 ; 
            b2 <= op_4 ;
        end
        
        if ( CALK_COUNT == 0 ) begin
            BUFF <= MULT_RESULT;
        end

        else if ( CALK_COUNT == 1 ) begin
            REAL_PART_NUM <= BUFF - MULT_RESULT;
        end

        else if ( CALK_COUNT == 2 ) begin
            BUFF <= MULT_RESULT;
        end
        else begin
            IMAG_PART_NUM <= BUFF + MULT_RESULT;
        end
        
    end

    always @(posedge CLK) begin
        if (WRITE_NEW_DATA)
            CALK_COUNT <= 0;
        else if (IN_MULT)
            CALK_COUNT <=CALK_COUNT +1;
    end

    always @(posedge CLK) begin
        if (WRITE_NEW_DATA)
            IN_MULT <= 1;
        else if (CALK_COUNT == 3)
            IN_MULT <= 0;
    end

    always @(posedge CLK)
        VAL_OUT <= IN_MULT &  (CALK_COUNT == 3);

endmodule