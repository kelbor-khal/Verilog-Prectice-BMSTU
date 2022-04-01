task: task_code test_brench start_test show_graphic

task_code:
	iverilog -o fourth_task fourth_task.v 
test_brench:
	iverilog -o fourth_task_tb fourth_task_tb.v
start_test:
	./fourth_task_tb
show_graphic: 
#	code fourth_task_tb.vcd
	gtkwave fourth_task_tb.vcd