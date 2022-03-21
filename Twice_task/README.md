[![Typing SVG](https://readme-typing-svg.herokuapp.com?size=30&color=22F723&vCenter=true&lines=SPI+receiver)](https://git.io/typing-svg)

# Оглавление
<div class = "intro">  

1. [Условие](#Условие) 
2. [Временные диаграммы](#Диаграммы)  
3. [Отладочная информация](#Отладка)  

</div><br>


# Условие  
<p>
Реализовать физический уровень приемника SPI Peripheral с поддержкой операции записи.
SPI интерфейс содержит 4 провода – SCK, CS, COPI, CIPO.

>CIPO - Pheripheral In Controller Out

> COPI - Controller Out Prepheral In

Формат команды:
  
Команда  | Адрес   | Данные
  :----- | :----:  | -----:
1...0    | 5...0   | 7...0  


Команда записи может быть любая фиксированная. Все остальные значения этого поля
необходимо игнорировать.

На выход ожидается примерно следующий интерфейс: <br>
... <br>
output wire wr_en_out  <br>
output wire [5:0] wr_address_out <br>
output wire [7:0] wr_data_out  <br>
...

</p>

Командой для записи была взять последовательсть "10".  
<br>  

# Диаграммы
<p>
При получении нужного сообщения для записи данных модуль производит запись адреса и данных сообщения. По окончании записи параметров сообщения выставляется флаг о готовности данных и сами данные в виде "проводов" поступают на выход модуля. Выходной интерфейс требуемый по заданию представлен на временной диаграмме ниже:
</p>  
<br>  

![Сообщение принято](./twice_task/image/receive_complete.png)

<p>
Сигналы COMM_W, ADD_W и DATA_W выставляются в уровень лог.1, когда этап записи параметров сообщения осуществлен успешно. Благодаря этим флагам осуществляется переход к записи других частей сообщения. <br>

Полный состав сигналов (их временных диаграмм) модуля представлен ниже:
</p>  
<br>  

![Развернутые временные диаграммы](./twice_task/image/all_diagramm.png)

<p>
Если принятая команда не соответсвует требуему значению на требуемом значении счетчика, то запись адреса и данных сообщения не производится.
</p>  
<br>  

![Сообщение не принято](./twice_task/image/receive_not_complete.png)



# Отладка
<p>

В случае, если команда на запись совпадает с первыми двумя битами принимаего сообщения, то сообщение записывается. Для проверки реакции модуля на "верную" команду сформирован test bench. Часть кода формирующего команду представлена ниже:

```verilog
    initial begin 
        $dumpfile("twice_task_tb.vcd");
        $dumpvars(0, twice_task_tb);
            
            /* команда  */
            in_flow = 1; #3
            in_flow = 1; #2
            /* Проверка сценария с "неверной" командой*/
            /* in_flow = 1; #3 */ 
            in_flow = 0; #2
```
<br>

Вывод отладочной информации в терминал представлен ниже:
<br>

```shell
ivan@ivan-filin:~/VerilogPractic/Twice_task$ make task
iverilog -o twice_task twice_task.v 
iverilog -o twice_task_tb twice_task_tb.v
./twice_task_tb
VCD info: dumpfile twice_task_tb.vcd opened for output.
********** Command write received! *********
************* Address received! ************
************** Data received! **************
************* Message received! ************
************** Test complete! **************
gtkwave twice_task_tb.vcd

GTKWave Analyzer v3.3.103 (w)1999-2019 BSI

[0] start time.
[37] end time.
```
<br>

Если принятые первые два бита не совпадают с командой для записи, то выводится сообщение "Message not received!" и запись адреса и данных не производится. Для проверки сценария с поступлением сообщения с "неверной" командой был изменен test bench. Часть кода формирующего команду представлена ниже:

<br>

```verilog
    initial begin 
        $dumpfile("twice_task_tb.vcd");
        $dumpvars(0, twice_task_tb);
            
            /* команда  */
            in_flow = 1; #3
            /* in_flow = 1; #2 */
            /* Проверка сценария с "неверной" командой*/
            in_flow = 1; #3 
            in_flow = 0; #2
```
<br>

Вывод отладочной информации в терминал представлен ниже:

<br>

```shell
ivan@ivan-filin:~/VerilogPractic/Twice_task$ make task
iverilog -o twice_task twice_task.v 
iverilog -o twice_task_tb twice_task_tb.v
./twice_task_tb
VCD info: dumpfile twice_task_tb.vcd opened for output.
********** Message not received! ***********
************** Test complete! **************
gtkwave twice_task_tb.vcd

GTKWave Analyzer v3.3.103 (w)1999-2019 BSI

[0] start time.
[38] end time.
```

</p>

<p>
Результат работы модуля соответсвует заданным требованиям в задании.
</p>  

<br>  
 
