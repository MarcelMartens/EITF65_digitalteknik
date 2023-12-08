@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xelab  -wto b6bd21ecd4264224abc219e09d7d35c3 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot stop_watch_tb_behav xil_defaultlib.stop_watch_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
