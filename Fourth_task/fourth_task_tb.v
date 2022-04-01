`timescale 1ns/1ns
`include "fourth_task.v"

module fourth_task_tb;

    reg [7:0] input_value;
    wire [15:0] output_value;

    /* uut - unit under test */
    fourth_task dut ( input_value, output_value);

    initial begin
        $dumpfile("fourth_task_tb.vcd");
        $dumpvars(0, fourth_task_tb);
            
            input_value = 8'b00000010; 
            #2;
            input_value = 8'b00000011; 
            #2;
            input_value = 8'b00000100; 
            #2;
            input_value = 8'b00000101; 
            #4;
        
            $display("************** Test complete! **************");  
            $finish;
    end
endmodule