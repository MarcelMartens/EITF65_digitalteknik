@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xelab  -wto c4dae10b590342dda96c53e6aa540bee -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot cpu_tb_behav xil_defaultlib.cpu_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
