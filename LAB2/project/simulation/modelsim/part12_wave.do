onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/nrst
add wave -noupdate /testbench/col
add wave -noupdate /testbench/row
add wave -noupdate -label curr_st /testbench/part1_i/curr_st
add wave -noupdate -label keycode -radix unsigned /testbench/part2_i/keycode
add wave -noupdate -label key /testbench/part1_i/key
add wave -noupdate /testbench/part2_i/seqdet
add wave -noupdate /testbench/pressed
add wave -noupdate /testbench/part2_i/bcd_ok
add wave -noupdate /testbench/part2_i/bcdind
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3853503 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1199167 ps} {2829495 ps}
