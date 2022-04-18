// Code your design here
module counter(INIT,CLK,RST,CONTROL,WHO,LOSER,WINNER,GAMEOVER,load,count,count_loser,
              count_winner);
  input wire INIT, CLK,RST;
  input wire [3:0] load; //initial value to be loaded in the counter
  input wire [1:0] CONTROL; //00 up 1, 01 up 2, 10 down 1, 11 down 2
  output reg [3:0] count;
  output reg LOSER,WINNER,GAMEOVER;
  output reg [3:0] count_winner, count_loser;
  output reg [1:0] WHO;
  int flag;
  
  initial begin
    count_winner=0;
    count_loser=0;
    WHO=2'b00;
  end
  
  
  always @ (posedge CLK or negedge RST) begin  //asynchronous reset
    flag=0;
    
    if (LOSER==1 || WINNER==1) begin
    	LOSER=0;
    	WINNER=0;	 	
    end
        
    if (~RST) begin //RST=0
      count=0;
      count_loser=0;
      count_winner=0; 
      LOSER=0;
      WINNER=0;
      GAMEOVER=0;
      WHO=2'b00;
      flag=1; //this flag is used to prevent entering to check if count==0 down in the code if RST=0 as count will be zero, but this case will not be considered so LOSER signal will not be raised high unless count=0 is achieved by the counter while counting up or counting down
    end
    
    
    else if (GAMEOVER) begin //GAMEOVER==1
      count=0;
      count_winner=0;
      count_loser=0;
      GAMEOVER=0;
      WHO=2'b00;
      flag=1; //this flag is used to prevent entering to check if count==0 down in the code if GAMEOVER=1 as count will be zero, but this case will not be considered so LOSER signal will not be raised high unless count=0 is achieved by the counter while counting up or counting down
    end
    
    else if (INIT==1) 
      count=load;
    
    else if (CONTROL== 2'b00)
       count+=4'b01; 
    else if (CONTROL== 2'b01)
      count+=4'b10;
    else if (CONTROL== 2'b10)
      count-=4'b01;
    else if (CONTROL== 2'b11)
      count-=4'b10;
   

    if (count==4'b0 && flag==0) begin
      LOSER=1; //for 1 CLK cycle
      count_loser+=1;
    end

    else if (count==4'b1111 && flag==0) begin
      WINNER=1; //for 1 CLK cycle
      count_winner+=1;
    end

    if (count_winner==15) begin
      WHO=2'b10;
      GAMEOVER=1; //Synchronously @ next positive edge CLK cycle, GAMEOVER will be = 0, WHO=2'b00 ,count,count_winner and count_loser will be =0
    end

    else if(count_loser==15) begin
      WHO=2'b01;
      GAMEOVER=1; //Synchronously @ next positive edge CLK cycle, GAMEOVER will be = 0, WHO=2'b00 ,count,count_winner and count_loser will be =0
      
    end

    
  end
endmodule
