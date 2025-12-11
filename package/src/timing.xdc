create_clock -period 10.000 -name sys_clk [get_ports clk]
create_clock -period 10.000 -name adc_clkout [get_ports CLKOUT]

set_input_delay -clock [get_clocks adc_clkout] -max 2.0 [get_ports {SDO*}]
set_input_delay -clock [get_clocks adc_clkout] -min 0.0 [get_ports {SDO*}]