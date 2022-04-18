// Code your testbench here
// or browse Examples
//Scenario 2 for testing RESET and GAMEOVER due to LOSER got 15 times first 
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
    load=2;
    CONTROL=3; //count-=2
    #1 INIT=0; //@2, @3 count will be =0000
    #2 CONTROL=2; //@4, @5 count-=1 =-1 => 1111 
    #2 CONTROL=3; //@6 count-=2, @7 count=-3
    
    //loop 14 times so that 15 times loser is achieved first and Game is Over
    for (int i=0;i<=13;i++) begin
     
    #14 CONTROL=2; //first time: @20 therefore @21 count-1 => -16= 0000
    #4 CONTROL=3; //first time: @ 24 therefore @25 count-2 => -3 
    end
    
    //@258
    #2 INIT=1; //@260
    load=14;
    CONTROL=0; //count will be 15 4'b1111 @261
    #1 INIT=0;
    #5 RST=0; //@266 RST all counters and signals
    
   
  end
  
  counter   c1(INIT,CLK,RST,CONTROL,WHO,LOSER,WINNER,GAMEOVER,load,count,count_loser,
              count_winner);
  
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
    #270 $finish;
  end
endmodule

