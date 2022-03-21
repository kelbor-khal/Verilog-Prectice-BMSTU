task: task_code test_brench start_test show_graphic

task_code:
	iverilog -o twice_task twice_task.v 
test_brench:
	iverilog -o twice_task_tb twice_task_tb.v
start_test:
	./twice_task_tb
show_graphic: 
	gtkwave twice_task_tb.vcd