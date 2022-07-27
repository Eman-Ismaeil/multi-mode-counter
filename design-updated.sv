// Code your design here
module counter(my_intf.dut abc);

  int flag;

  initial begin
    abc.count_winner=0;
    abc.count_loser=0;
    abc.WHO=2'b00;
  end
  
  always @ (posedge abc.CLK or negedge abc.RST) begin  //asynchronous reset
    flag=0;
    
    if (abc.LOSER==1 || abc.WINNER==1) begin
    	abc.LOSER=0;
    	abc.WINNER=0;	 	
    end
        
    if (~abc.RST) begin //RST=0
      abc.count=0;
      abc.count_loser=0;
      abc.count_winner=0; 
      abc.LOSER=0;
      abc.WINNER=0;
      abc.GAMEOVER=0;
      abc.WHO=2'b00;
      flag=1; //this flag is used to prevent entering to check if count==0 down in the code if RST=0 as count will be zero, but this case will not be considered so LOSER signal will not be raised high unless count=0 is achieved by the counter while counting up or counting down
    end
    
    
    else if (abc.GAMEOVER) begin //GAMEOVER==1
      abc.count=0;
      abc.count_winner=0;
      abc.count_loser=0;
      abc.GAMEOVER=0;
      abc.WHO=2'b00;
      flag=1; //this flag is used to prevent entering to check if count==0 down in the code if GAMEOVER=1 as count will be zero, but this case will not be considered so LOSER signal will not be raised high unless count=0 is achieved by the counter while counting up or counting down
    end
    
    else if (abc.INIT==1) 
      abc.count=abc.load;   
    else if (abc.CONTROL== 2'b00)
       abc.count+=4'b01; 
    else if (abc.CONTROL== 2'b01)
      abc.count+=4'b10;
    else if (abc.CONTROL== 2'b10)
      abc.count-=4'b01;
    else if (abc.CONTROL== 2'b11)
      abc.count-=4'b10;
   
    if (abc.count==4'b0 && flag==0) begin
      abc.LOSER=1; //for 1 CLK cycle
      abc.count_loser+=1;
    end

    else if (abc.count==4'b1111 && flag==0) begin
      abc.WINNER=1; //for 1 CLK cycle
      abc.count_winner+=1;
    end

    if (abc.count_winner==15) begin
      abc.WHO=2'b10;
      abc.GAMEOVER=1; //Synchronously @ next positive edge CLK cycle, GAMEOVER will be = 0, WHO=2'b00 ,count,count_winner and count_loser will be =0
    end

    else if(abc.count_loser==15) begin
      abc.WHO=2'b01;
      abc.GAMEOVER=1; //Synchronously @ next positive edge CLK cycle, GAMEOVER will be = 0, WHO=2'b00 ,count,count_winner and count_loser will be =0     
    end
    
  end
endmodule

///////////////////--------------TOP-module---------------\\\\\\\\\\\\\\\\\\\\\\

module top;
  parameter cycle=2;
  bit CLK=0;
  always #(cycle/2) CLK=~CLK;
  
  my_intf if_in(CLK);
  counter c1(if_in.dut);
  test_counter t1(if_in.tb);
  
  initial begin
    $dumpfile("uvm.vcd");
    $dumpvars;
   // #300 $finish;
  end  
endmodule

  
            
             

