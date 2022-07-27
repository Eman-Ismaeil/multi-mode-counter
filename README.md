# multi-mode-counter
A Multi-mode counter is implemented to count up, down, by ones and by twos.
There is a two-bit control bus input indicating which one of the four modes is active.
An initial value input and a control signal called INIT. When INIT is logic 1, the initial value will be loaded into the multi-mode counter.
Whenever the count is equal to all zeros, LOSER signal is set high. 
When the count is all ones, WINNER signal is set high.
In either case, the signals remain high for only one cycle.

A pair of binary counters is used to count the number of times WINNER and LOSER goes high.
When one of them reaches 15, an output called GAMEOVER is set high.
If the game is over because LOSER got to 15 first, a two-bit output called WHO is set to 2’b01.
If the game is over because WINNER got to 15 first, WHO signal is set to 2’b10. 
WHO should start at 2’b00 and return to it after each game over.
Then synchronously all the counters are cleared to start over again. 

A simple test bench is implemented that generates inputs to test the different scenarios to make sure the design is correct by investigating the generated wave diagrams.

Then the design module and testbench are updated so that:
1. An interface with the appropriate set of modports, and clocking blocks are present
2. A testbench (implemented as a program not a module)
3. A top module
4. Assertions to ensure that some illegal scenarios can’t be generated
