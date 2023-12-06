# Alarm-Clock
**Verilog project. In this project, I built a 6-digit clock with an alarm mode. It contains 2 alarms, a 'reset' button, and a 'turn alarm off' button.**
It works like a regular clock with an alarm mode. **Note - I used Synopsys VCS Simulator which can provide the actual time (using $system("date")) for initializing, but not all simulators support this function**
Using $monitor we can detect the time output (which will be shown by 7-segment-display in real life).

**TestBench:**
Check if Alarm1 works as expected after the "stop alarm" is ON, and if alarm 2 works well afterward. 
In addition, it checks if the alarm is always OFF while "alarm enable" is OFF. 
EPWave is provided in the following file. ![image](https://github.com/Yoavyu/Alarm-Clock/assets/140505276/ad1f37ca-02ee-4fd9-be7b-7e9d275789b6) ![image](https://github.com/Yoavyu/Alarm-Clock/assets/140505276/e77428b6-2bb3-427a-be65-1385bbb8669a)

