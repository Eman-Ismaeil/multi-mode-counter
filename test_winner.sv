// Code your testbench here
// or browse Examples
//Scenario 1 for testing GAMEOVER due to WINNER got 15 times first 
module test_counter();
  parameter cycle=2;
  logic INIT,CLK,RST,LOSER,WINNER,GAMEOVER;
  logic [3:0] load, count;
  logic [1:0] CONTROL;
  logic [3:0] count_winner, count_loser; 
  logic[1:0] WHO; 
  
  initial begin
    CLK=0;
    forever #(cycle/2) CLK=~CLK;
  end
  
  initial begin
    #1 INIT=1;
    RST=1;
    load=13;
    CONTROL=1; //count+=2
    #1 INIT=0; //@2, @3 count will be =15
    #2 CONTROL=0; //@4, @5 count=16 10000 therefore count_loser will be =1
    #2 CONTROL=1; //@6 count+=2, @7 count=2
    
    //loop 14 times so that 15 times winner is achieved and Game is Over
    for (int i=0;i<=13;i++) begin
     
    #14 CONTROL=0; //first time: @20 therefore @21 count+1 => 14+1=F 2'b1111
    #4 CONTROL=1; //first time: @ 24 therefore @25 count+1 => F+1=0
    
    end
    #1 INIT=1;
    load=3;
    CONTROL=1;
    #1 INIT=0;
   
  end
  
  counter   c1(INIT,CLK,RST,CONTROL,WHO,LOSER,WINNER,GAMEOVER,load,count,count_loser,
              count_winner);
  
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
    #270 $finish;
  end
  
endmodule
