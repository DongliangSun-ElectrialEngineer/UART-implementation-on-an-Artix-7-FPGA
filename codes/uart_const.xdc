# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk_100MHz]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_100MHz]
	
# LEDs
set_property PACKAGE_PIN U16 	 [get_ports {LED[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 	 [get_ports {LED[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 	 [get_ports {LED[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 	 [get_ports {LED[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN W18 	 [get_ports {LED[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 	 [get_ports {LED[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 	 [get_ports {LED[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 	 [get_ports {LED[7]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]

## btnR
set_property PACKAGE_PIN T17 	 [get_ports reset]						
set_property IOSTANDARD LVCMOS33 [get_ports reset]

##USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports rx]						
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN A18 [get_ports tx]						
set_property IOSTANDARD LVCMOS33 [get_ports tx]