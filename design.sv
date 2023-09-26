`timescale 1ms/1ms  
module clock (hour1, hour0, min1, min0, sec1, sec0,reset,clk);
  input reset, clk; // reset , 1Hz clock
  output [3:0] hour1, hour0, min1, min0, sec1, sec0 ;// 4-bit for 0-9 numbers
  reg [3:0] hour1temp, hour0temp, min1temp, min0temp, sec1temp, sec0temp ; //temporary registers for saving data
  string Time;
  
  function string get_time(); // gets the real time and saves it
    int    file_pointer;
    
    //Stores time and date to file sys_time
    void'($system("date +%X--%x > sys_time"));
    //Open the file sys_time with read access
    file_pointer = $fopen("sys_time","r");
    //assin the value from file to variable
    void'($fscanf(file_pointer,"%s",get_time));
    //close the file
    $fclose(file_pointer);
    void'($system("rm sys_time"));
  endfunction
  
  initial
    begin
      Time = get_time(); // getting the time
      // initialize the clock to current time
       hour1temp <= Time[0];
       hour0temp <= Time[1];
       min1temp <= Time[3];
      min0temp <= Time[4];
      sec1temp <= Time[6];
      sec0temp <= Time[7];
    end  
   
  always@(posedge clk) // every 1 sec
    begin
      if(!reset) // reset? time=00:00:00, else: time = time +1 sec
      begin 
        if (sec0<9) // updating the digits of time+1sec
          sec0temp <= sec0+1;
        else
          begin
            sec0temp <= 0;
            if (sec1<5)
              sec1temp <= sec1+1;
             else
               begin 
                 sec1temp <=0;
                 if (min0<9)
                   min0temp <= min0+1;
                 else
                   begin
                      min0temp <= 0;
                     if(min1 <5)
                       min1temp <= min1+1;
                       else
                         begin 
                           min1temp <= 0;
                           if  (hour0<9)
                             hour0temp <= hour0+1;
                           else
                             begin
                               hour0temp <=0;
                               if(~(hour1==2 && hour0 ==3 && min1==5 && min0==9 &&sec1==5 && sec0==9)) // if time=23:59:59 then time+1sec = 00:00:00
                                 hour1temp <= hour1+1;
                               else
                                 begin
                                   sec0temp <= 0;
                                   sec1temp <= 0;
                                   min0temp <= 0;
                                   min1temp <= 0;
                                   hour0temp <= 0;
                                   hour1temp <= 0;
                                 end
                             end
                         end
                   end
               end
          end 
      end
  else
    begin // if reset is ON
      sec0temp <= 0;
       sec1temp <= 0;
       min0temp <= 0;
      min1temp <= 0;
      hour0temp <= 0;
      hour1temp <= 0;
    end
    end
  
    // assigning the new values
  assign hour1 = hour1temp;
  assign hour0 = hour0temp;
  assign min1 = min1temp;
  assign min0 = min0temp;
  assign sec1 = sec1temp;
  assign sec0 = sec0temp;
  
  
        
endmodule

              
     
              
module alarm(alarm_out,alarm1,alarm2,clk,hour1, hour0, min1, min0, sec1, sec0,stop_alarm, alarm_en,reset) ;
  input [15:0]alarm1,alarm2;// 4-bit for every one of HH:MM 
   input clk,stop_alarm,alarm_en,reset;
   input [3:0] hour1, hour0, min1, min0, sec1, sec0 ;// 4-bit for 0-9 numbers
    output  alarm_out;// alarm turned ON/OFF
  reg temp_alarm, stopped; // stopped is ON (only for current minute) when alarm turned ON but has had stopped by 'stop alarm'
  initial begin
   stopped <= 0;
   temp_alarm <= 0;
  end
  always@(negedge clk) // every 1 sec
    begin
      if(stop_alarm || !alarm_en) // if stop alarm is pressed, or if alarm is disables, then alarm is OFF
        begin
        temp_alarm <= 0;
        stopped <= 1;
        end
      else
        begin
          if ({hour1,hour0,min1,min0}==alarm1 || {hour1,hour0,min1,min0}==alarm2 )
            if(!stopped)
             temp_alarm <= 1; // if alarm time is the current time then alarm is ON, but only if not stopped before
            else 
               temp_alarm <= 0;
          else // alarm turned OFF, and 'stopped' is being reset
            begin
            stopped <= 0;
            temp_alarm <= 0;
            end
            	 
        end
    end 
  always@(posedge reset) // reset also turning alarm OFF
    temp_alarm <= 0;

    assign alarm_out = temp_alarm; // alarm state output
 endmodule
                

module dec(digit, number);
  input [3:0] number;
  output reg[6:0] digit; 
  
  always @(number)
    begin
      case (number) //case statement
            0 : digit = 7'b0000001;
            1 : digit = 7'b1001111;
            2 : digit = 7'b0010010;
            3 : digit = 7'b0000110;
            4 : digit = 7'b1001100;
            5 : digit = 7'b0100100;
            6 : digit = 7'b0100000;
            7 : digit = 7'b0001111;
            8 : digit = 7'b0000000;
            9 : digit = 7'b0000100;
            //switch off 7 segment character when the bcd digit is not a decimal number.
            default : digit = 7'b1111111; 
        endcase
    end
    
endmodule
