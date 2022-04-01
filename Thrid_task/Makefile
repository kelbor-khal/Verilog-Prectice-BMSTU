task: task_code test_brench start_test show_graphic

task_code:
	iverilog -o third_task third_task.v 
test_brench:
	iverilog -o third_task_tb third_task_tb.v
start_test:
	./third_task_tb
show_graphic: 
#	code third_task_tb.vcd
	gtkwave third_task_tb.vcd