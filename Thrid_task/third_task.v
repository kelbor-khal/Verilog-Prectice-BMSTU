`timescale  1ns/1ns

module  third_task ( input wire [7:0] membr_1, membr_2, membr_3,

                     output reg [17:0] Y_ALL );

    /* счетчики */
    reg [5:0] count_cicle, count_cicle_sum = 0;

    /* служебные сигналы */
    reg CLK = 1, WRITE_NEW_DATA = 1,
    IN_OPER = 0, READY_RESULT = 0;

    /* коэффициент фильтра */    
    reg [7:0] coeff_1 = 8'b00000001, 
              coeff_2 = 8'b00000010, 
              coeff_3 = 8'b00000011;

    /* регистры, в которых происходит сдвиг данных*/
    reg [7:0] membr_1_d, membr_2_d, membr_3_d;

    /* регистры хранящие входные значения */
    reg [7:0] buff_membr_1, buff_membr_2, buff_membr_3;

    /* результаты арифметических операций */
    reg [15:0] result_mult;
    reg [17:0] result_add; 

    /* буферные регситры для арифметических операций */
    /* умножение */
    reg [7:0] operand_mult_1;
    reg [7:0] operand_mult_2;
    /* сложение */
    reg [16:0] operand_add_1;
    reg [16:0] operand_add_2;

    /* X регистр для проверки провода на повисание в воздухе */
    reg X;

    initial
        forever #1 CLK =~CLK;
    initial begin
        forever begin
            #2 WRITE_NEW_DATA = ~ WRITE_NEW_DATA; 
            #18 WRITE_NEW_DATA = ~ WRITE_NEW_DATA;
        end
    end

    /* прием данных в буфферные регистры */
    always @( posedge CLK) begin
        if (WRITE_NEW_DATA) begin
            buff_membr_3 <= membr_1;
            buff_membr_2 <= membr_2;
            buff_membr_1 <= membr_3;
        end    
    end

    /* вход в арифметический вычислитель */
    always @(posedge CLK) begin
        if (WRITE_NEW_DATA)
            IN_OPER <= 1;
    end

    /* счетчик сдвига элементов */
    always @( posedge CLK ) begin
        if ( ( count_cicle == 3 | count_cicle == 0 ) && !WRITE_NEW_DATA) begin
            /* сдвиг отсчетов по регистрам задержки */
            membr_3_d <= membr_2_d;
            membr_2_d <= membr_1_d;
            membr_1_d <= buff_membr_3;
            /* сдвиг отсчетов по буферным регистрам */
            buff_membr_3 <= buff_membr_2;
            buff_membr_2 <= buff_membr_1;

            count_cicle <= 1;
        end

        else if (IN_OPER ) begin
            count_cicle <= count_cicle + 1;
        end
    end

    always @(posedge CLK) begin
        if ( WRITE_NEW_DATA ) begin
            count_cicle <= 0;
        end
    end

    /* счетчик вывода суммы */
    always @( posedge CLK ) begin
        if ( count_cicle_sum == 3 ) begin
            count_cicle_sum <= 1;
        end

        else if (IN_OPER )
            count_cicle_sum <= count_cicle_sum + 1;
    end

    /* присваивание значений перед умножением*/
    always @( posedge CLK ) begin
        if ( membr_1_d != X && membr_2_d != X) begin
            if ( count_cicle == 1 )begin
                operand_mult_1 <= membr_3_d;
                operand_mult_2 <= coeff_3;

                READY_RESULT <= 0;
            end

            else if ( count_cicle == 2 )begin
                operand_mult_1 <= membr_2_d;
                operand_mult_2 <= coeff_2;
            end

            else if ( count_cicle == 3)begin
                operand_mult_1 <= membr_1_d;
                operand_mult_2 <= coeff_1;

                READY_RESULT <= 1;
            end
        end
    end

    /* умножение */
    always @( posedge CLK )
        result_mult <= operand_mult_1 * operand_mult_2;
    
    /* сложение */
    always @( posedge CLK) begin
        if ( count_cicle_sum == 1 )
            operand_add_1 <= result_mult;
        
        else if ( count_cicle_sum == 2 )
            operand_add_2 <= result_mult + operand_add_1;

        else if ( count_cicle_sum == 3)
            result_add <= result_mult + operand_add_2;
    end

    /* вывод конечного результата */
    always @(*)
        if ( READY_RESULT )
            Y_ALL <= result_add;
            
endmodule