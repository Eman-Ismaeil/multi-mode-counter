//Scenario 2 for testing RESET and GAMEOVER due to LOSER got 15 times first 
//Interface
interface my_intf(input bit CLK);
  //declare signals
  logic INIT,RST,LOSER,WINNER,GAMEOVER;
  logic [3:0] load, count; //initial value to be loaded in the counter
  logic [1:0] CONTROL;  //00 up 1, 01 up 2, 10 down 1, 11 down 2
  logic [3:0] count_winner, count_loser; 
  logic[1:0] WHO; 
  
  //clocking block for the testbench program
  clocking cb @(posedge CLK);
    default input #1 output #1;
    output INIT, RST,load, CONTROL;
    input count, LOSER, WINNER, GAMEOVER, count_winner, count_loser, WHO;
  endclocking
  
  modport dut(input INIT, RST,load, CONTROL,CLK,output count, LOSER, WINNER, GAMEOVER, count_winner, count_loser, WHO);
  modport tb(clocking cb);
    
  //Concurrent Assertions
    
   //check when count due to loser reaches 15, WHO signal will be set to 2'b01 
   property WHO_loser;
     @ (count_loser)
     count_loser==15 |-> WHO==2'b01;
   endproperty
    assertion1: assert property (WHO_loser);
     
   //check when count due to winner reaches 15, WHO signal will be set to 2'b10
   property WHO_winner;
      @ (count_winner)
     count_winner==15 |-> WHO==2'b10;
   endproperty
    assertion2: assert property (WHO_winner);
      
   //check that WHO signal will never be equal to 2'b11
   property GAMEOVER_WHO;
     @(GAMEOVER)
     WHO!=2'b11;
    endproperty
      assertion3: assert property (GAMEOVER_WHO);
        
    //check that when INIT is 1 , Load will be loaded in the counter    
    property INIT_load;
      @ (INIT)
      INIT==1 |-> count==load;   
   endproperty
    assertion4: assert property (INIT_load);
        
    //check that when RST is active low, count will be zeroed  
    property RST_count;
      @(RST)
     RST==0 |-> count==0; 
    endproperty
       assertion5: assert property (RST_count);         
         
endinterface


////////////////----------------testbench-----------------\\\\\\\\\\\\\\\\\\\\\\\

//Scenario 2 for testing RESET and GAMEOVER due to LOSER got 15 times first 
program test_counter(my_intf.tb xyz);
  
  initial begin
    #1 xyz.cb.INIT<=1; //@2 these signals will be affected due to cb
    xyz.cb.RST<=1;
    xyz.cb.load<=2;
    xyz.cb.CONTROL<=3; //it means to make: count-=2 @ the propriate posedge clk 
    #1 xyz.cb.INIT<=0; 
    #2 xyz.cb.CONTROL<=2; //count-=1
    #2 xyz.cb.CONTROL<=3; //count-=2
    
    //loop 14 times so that 15 times loser is achieved first and Game is Over
    for (int i=0;i<=13;i++) begin
      
    #14 xyz.cb.CONTROL<=2; 
      if(i==13) begin
        #5;
        //immediate assertion to check that when count_loser reaches 15, GAMEOVER 		  signal is raised high
        assertion6: assert(xyz.cb.GAMEOVER==1)
          $display("GAME is OVER");
        else
          $error("ERROR occurs");
      end                        
    #4 xyz.cb.CONTROL<=3;  //count-=2
      
    end
        
    //testing RESET scenario
    #2 xyz.cb.INIT<=1; //@260 but the change will occur @ 262
    xyz.cb.load<=14;
    xyz.cb.CONTROL<=0; 
    #2 xyz.cb.INIT<=0;
    #5 xyz.cb.RST<=0; //@272 , @274 RST will be equal to 0
    #10 xyz.cb.RST<=1;
    #10;
    
   
  end
endprogram



