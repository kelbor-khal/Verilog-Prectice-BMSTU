`timescale  1ns/1ns

module  third_task ( input wire [7:0] membr_1,
                     output reg [17:0] Y_ALL );
    /* счетчики */
    reg [5:0] count=1;
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
    reg [15:0] operand_mult1, operand_mult2, operand_mult3;
    reg [17:0] result; 

    initial
        forever #1 CLK =~CLK;
    initial begin
        forever begin
            #8 WRITE_NEW_DATA = ~ WRITE_NEW_DATA; 
            #12 WRITE_NEW_DATA = ~ WRITE_NEW_DATA;
        end
    end
    /* вход в арифметический вычислитель */
    always @(posedge CLK) begin
        if (WRITE_NEW_DATA) IN_OPER <= 1;
    end
    /* запись данных в регистры */
    always @(posedge CLK) begin
        if (WRITE_NEW_DATA) begin
            if (count == 1) begin
                buff_membr_1 <= membr_1;
            end
            else if (count == 2) begin
                buff_membr_2 <= membr_1;
            end 
            else if (count == 3) begin
                buff_membr_3 <= membr_1;
            end
        end
    end
    /* инкремент счетчика */
    always @(posedge CLK) begin
        if (count==10) count<=1;
        else count <= count+1;
    end
    /* перекладывание значений */
    always @(posedge CLK) begin
        if(count%2==1 && !WRITE_NEW_DATA) begin
            membr_1_d <= membr_2_d;
            membr_2_d <= membr_3_d;
            membr_3_d <= buff_membr_1;
            buff_membr_1 <= buff_membr_2;
            buff_membr_2 <= buff_membr_3;
        end
    end
    /* умножение на коэффициенты */
    always @(posedge CLK) begin
        if (count%2==0 && !WRITE_NEW_DATA && count!=10) begin
            operand_mult1 <= coeff_3 * membr_1_d;
            operand_mult2 <= coeff_2 * membr_2_d;
            operand_mult3 <= coeff_1 * membr_3_d;
        end
    end
    /* сложение */
    always @(posedge CLK) begin 
        if(count%2==1 && !WRITE_NEW_DATA) begin
            result <= operand_mult1 + 
                      operand_mult2 +
                      operand_mult3;
            READY_RESULT <=1;
        end
    end
    /* выдача результата */
    always @(posedge CLK) begin
        if (READY_RESULT) begin
            Y_ALL <= result;
            READY_RESULT <=0;
        end
    end
endmodule