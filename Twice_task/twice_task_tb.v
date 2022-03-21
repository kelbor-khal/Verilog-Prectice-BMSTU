`timescale 1ns/1ns
`include "twice_task.v"

module twice_task_tb;

    reg in_flow;
    wire [5:0] out_address;
    wire [7:0]out_data;
    wire zzREADY_R;

    twice_task dut (in_flow, out_address, out_data, READY_R);
    initial begin 
        $dumpfile("twice_task_tb.vcd");
        $dumpvars(0, twice_task_tb);
            
            /* команда  */
            in_flow = 1; #3
            in_flow = 1; #2
            /* Проверка сценария с "неверной" командой*/
            /* in_flow = 1; #2 */ 
            in_flow = 0; #2

            /* адрес */
            in_flow = 0; #2 
            in_flow = 1; #6
            in_flow = 0; #2 
            in_flow = 1; #2

            /* данные */
            in_flow = 0; #4 
            in_flow = 1; #6
            in_flow = 0; #4 
            in_flow = 1; #2

            in_flow = 0; #2

            $display("************** Test complete! **************");  
            $finish;
    end
endmodule