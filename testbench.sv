`timescale 1ms/1ns  // 1000 Time delays = 1 sec

module clock_tb ;
  reg reset, clk; // reset , 1Hz clock
  reg [15:0] alarm1,alarm2; // 4-bit for every one of HH:MM 
  reg [3:0] hour1, hour0, min1, min0, sec1, sec0 ; // 4-bit for 0-9 numbers
  reg [6:0] d1,d2,d3,d4,d5,d6; // 7-segment-display
  reg alarm_out, stop_alarm, alarm_en; // Alarm is turned ON/OFF , stop alarm from being on , alarm is enabled/unenabled
  
  
  //my digital clock
  clock clock_test(hour1, hour0, min1, min0, sec1,sec0,reset,clk); 
  
  
  // taking care of alarm
  alarm alarm_test(alarm_out,alarm1,alarm2,clk,hour1, hour0, min1, min0, sec1, sec0,stop_alarm,alarm_en,reset); 
  
  
  //decoding the numbers to 7-segment-display
  dec dec1(d1,hour1);
  dec dec2(d2,hour0);
  dec dec3(d3,min1);
  dec dec4(d4,min01);
  dec dec5(d5,sec1);
  dec dec6(d6,sec0);
  
   always #500 clk = ~clk; // clock of 1Hz
  
  initial
      begin
        $monitor(hour1,hour0," :",min1,min0," :" ,sec1,sec0, "    : alarmON/OFF :", alarm_out); // show  clock output, and alarm ON/OFF
      end 
  initial 
    begin
      clk = 0;
      reset = 0;
      alarm1 = 16'd0001; // set up of 'alarm1' to 00:01:00
      alarm2 = 16'd0004; // set up of 'alarm2' to 00:04:00
      stop_alarm = 0;
      alarm_en = 1;
      repeat(2) begin
        #10000 reset = 1; // reset after 10 sec
        #1000 reset = 0;
        #75000 stop_alarm = 1; // alarm1 is on after 60 sec, so it stops it after 15 sec
      #1000  stop_alarm = 0; // pressed for 1 sec
      #500000  alarm_en = ~alarm_en;
      end
      #1000 $finish ; 
    end 
      
  initial
            begin
              $dumpfile("clock_tb.vcd");
              $dumpvars(0,clock_tb); 
            end 
       
endmodule 
