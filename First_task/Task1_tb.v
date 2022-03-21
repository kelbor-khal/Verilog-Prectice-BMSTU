`timescale 1ns/1ns
`include "Task1.v"

module Task1_tb;

    reg [7:0] op_1, op_2, op_3, op_4;
    wire [15:0] REAL_PART_NUM, IMAG_PART_NUM;

    /* uut - unit under test */
    Task1 dut (op_1, op_2, op_3, op_4, REAL_PART_NUM, IMAG_PART_NUM);

    initial begin /*выполнение операторов при начале симуляции*/
        $dumpfile("Task1_tb.vcd");
        $dumpvars(0, Task1_tb);
            
            #8 /* a1 = 1, a2 = 1, b1 = 2, b2 = 2*/
            op_1 = 8'b00000001; 
            op_2 = 8'b00001001; 
            op_3 = 8'b00100010; 
            op_4 = 8'b00000110; 
            #8;
            
            op_1 = 8'b00000010; 
            op_2 = 8'b00001010; 
            op_3 = 8'b00000011; 
            op_4 = 8'b00010001; 
            #8;
            
            op_1 = 8'b01000011; 
            op_2 = 8'b00100011; 
            op_3 = 8'b01000011; 
            op_4 = 8'b00010011; 
            #20;
        
            $display("************** Test complete! **************");  
            $finish;
    end
endmodule