`timescale 1ns/1ns

module twice_task ( input wire in_flow, 

                    output reg [5:0] add_buff,
                    output reg [7:0] data_buff,
                    output reg READY_R);

    reg [23:0] count = 0;
    reg [7:0] count_write_flow = 0;
    reg [1:0] COMMAND_WRITE = 2'b10;
    
    reg [1:0] cmd_buff;

    reg CLK = 1, CP = 1, COMM_W = 0, 
    ADD_W = 0, DATA_W = 0;

    initial
        forever
            #1 CLK = ~CLK;
    
    initial
        forever begin

            #3 CP = 0;
            #32 CP = 1;

        end

    always@( posedge CLK) begin
       
        if ( COMM_W ) begin
            
            count_write_flow <= count_write_flow - 1;

        end

    end

    always @(CLK) begin

        if ( !CP ) begin
            count = count +1;

            if ( !COMM_W ) begin

                cmd_buff <= {cmd_buff[0], in_flow};

                    if ( ( cmd_buff == COMMAND_WRITE ) && ( count == 4) ) begin

                            COMM_W <= 1;
                            count_write_flow = 5;
                            $display("********** Command write received! *********");

                    end

                    else if ( cmd_buff != COMMAND_WRITE && ( count == 4) ) begin
                        
                            $display("********** Message not received! ***********");  
                    end
            end


            if ( COMM_W && !ADD_W ) begin

                if ( count == 17 ) begin

                    ADD_W <= 1;
                    count_write_flow = 7;
                    $display("************* Address received! ************");

                end

                else if ( count < 17 ) begin

                    add_buff[count_write_flow] = in_flow;
                
                end

            end

            if ( COMM_W && ADD_W ) begin

                if ( count == 32 ) begin

                    DATA_W <= 1;
                    count_write_flow = 0;
                    READY_R = 1;
                    $display("************** Data received! **************");
                    $display("************* Message received! ************");

                end

                else if ( count < 32 ) begin

                    data_buff [count_write_flow] = in_flow;
                    
                end

            end

        end

    end

endmodule