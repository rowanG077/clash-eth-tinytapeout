# Shared constants, copied from  base.sdc
set input_delay_value [ expr $::env(CLOCK_PERIOD) * $::env(IO_PCT) ]
set output_delay_value [ expr $::env(CLOCK_PERIOD) * $::env(IO_PCT) ]
set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [ current_design ]
set cap_load [ expr $::env(OUTPUT_CAP_LOAD) / 1000.0 ] ;# fF -> pF

# Remove clock net from inputs
set idx [ lsearch [ all_inputs ] "clk" ]
set all_inputs_wo_clk [ lreplace [ all_inputs ] $idx $idx ]
set idx [ lsearch $all_inputs_wo_clk "ui_in\[0\]" ]
set all_inputs_wo_clk [ lreplace $all_inputs_wo_clk $idx $idx ]
set idx [ lsearch $all_inputs_wo_clk "ui_in\[1\]" ]
set all_inputs_wo_clk [ lreplace $all_inputs_wo_clk $idx $idx ]

#  clk   clock is generated by the RP2040 chip
create_clock [ get_ports "clk" ]  -name rp2040Clk -period $::env(CLOCK_PERIOD)
set_input_delay $input_delay_value -clock [ get_clocks rp2040Clk ] $all_inputs_wo_clk
set_output_delay $output_delay_value -clock [ get_clocks rp2040Clk ] [ all_outputs ]
set_clock_uncertainty $::env(SYNTH_CLOCK_UNCERTAINTY) [ get_clocks rp2040Clk ]
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [ get_clocks rp2040Clk ]

#  ui_in[0]   clock is generated by MII phy
create_clock [ get_ports "ui_in\[0\]" ]  -name ethRxClk -period $::env(CLOCK_PERIOD)
set_input_delay $input_delay_value -clock [ get_clocks ethRxClk ] $all_inputs_wo_clk
set_output_delay $output_delay_value -clock [ get_clocks ethRxClk ] [ all_outputs ]
set_clock_uncertainty $::env(SYNTH_CLOCK_UNCERTAINTY) [ get_clocks ethRxClk ]
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [ get_clocks ethRxClk ]

#  ui_in[1]   clock is generated by MII phy
create_clock [ get_ports "ui_in\[0\]" ]  -name ethTxClk -period $::env(CLOCK_PERIOD)
set_input_delay $input_delay_value -clock [ get_clocks ethTxClk ] $all_inputs_wo_clk
set_output_delay $output_delay_value -clock [ get_clocks ethTxClk ] [ all_outputs ]
set_clock_uncertainty $::env(SYNTH_CLOCK_UNCERTAINTY) [ get_clocks ethTxClk ]
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [ get_clocks ethTxClk ]

# rp2040Clk and ethRxClk, ethTxClk  are mesochronous, and they never interact
set_clock_groups -asynchronous -group { rp2040Clk } -group { ethRxClk }
set_clock_groups -asynchronous -group { rp2040Clk } -group { ethTxClk }

# This is wrong for now whatever
set_clock_groups -asynchronous -group { ethRxClk } -group { ethTxClk }

# Miscellanea
set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) $all_inputs_wo_clk
set_load  $cap_load [ all_outputs ]
set_timing_derate -early [ expr {1-$::env(SYNTH_TIMING_DERATE)} ]
set_timing_derate -late [ expr {1+$::env(SYNTH_TIMING_DERATE)} ]