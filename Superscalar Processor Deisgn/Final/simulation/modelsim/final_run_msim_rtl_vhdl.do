transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/registers.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/mux2.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/instruction_memory.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/inc.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/components.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/branch_predictor.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/registers1.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/update_unit.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/rs_execute.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/ROB.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/reservation_station_complete.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/reservation_station.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/register_file.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/para_final.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/nand_unit.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/multiplexer.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/lst_unit.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/fetch_decode_rf.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/fetch_decode.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/fetch.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/execute_complete.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/dispatch_unit_bch.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/dispatch_unit.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/decode.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/complete.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/comparator.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/bch_unit.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/ARF.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/alu_unit.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/allocating_unit.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/adds.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/add_unit.vhd}
vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/ALL Code Files/final.vhd}

vcom -2008 -work work {C:/Users/dell/Desktop/GIT/Superscalar Processor Deisgn/Final/../testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
