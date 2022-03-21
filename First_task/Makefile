task: Task_code Test_brench Start_test Show_graphic

Task_code:
	iverilog -o Task1 Task1.v 
Test_brench:
	iverilog -o Task1_tb Task1_tb.v
Start_test:
	./Task1_tb
Show_graphic: 
	gtkwave Task1_tb.vcd