`timescale 1ns/1ns
`include "third_task.v"

module third_task_tb;

    reg [7:0] membr_1;
    wire [16:0] Y_ALL;

    third_task dut ( membr_1, Y_ALL);
    initial begin 
        $dumpfile("third_task_tb.vcd");
        $dumpvars(0, third_task_tb);

            #22 membr_1 = 8'b00000001;
            #2  membr_1 = 8'b00000010;
            #2  membr_1 = 8'b00000011;

            #16 membr_1 = 8'b00000100;
            #2  membr_1 = 8'b00000101;
            #2  membr_1 = 8'b00000110;
            #35

            $display("************** Test complete! **************");  
            $finish;
    end
endmodule