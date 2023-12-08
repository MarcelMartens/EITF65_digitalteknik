cd {C:\Users\lu1582je-s\Project\project_1\project_1.runs\impl_1}
exec data2MEM -bd {rom.mem} -bm {mcu.bmm} -bt {mcu.bit} -o b {download.bit}
open_hw
connect_hw_server
open_hw_target
set_property PROGRAM.FILE {download.bit} [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]
close_hw_target
disconnect_hw_server
close_hw
