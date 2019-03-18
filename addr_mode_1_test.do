##########################################
#  Clear simulator
##########################################

restart -f -nowave

##########################################
#  Add waves
##########################################

add wave -divider "Inputs"

add wave -position end -hex         sim:/AddrMode1/IR
add wave -position end -unsigned    sim:/AddrMode1/Rs_LSB
add wave -position end -hex         sim:/AddrMode1/Rm_data
add wave -position end -binary      sim:/AddrMode1/is_DPI
add wave -position end -binary      sim:/AddrMode1/is_DPIS
add wave -position end -binary      sim:/AddrMode1/is_DPRS
add wave -position end -binary      sim:/AddrMode1/is_LSIO
add wave -position end -binary      sim:/AddrMode1/is_LSHSBCO
add wave -position end -binary      sim:/AddrMode1/is_LSHSBSO
add wave -position end -binary      sim:/AddrMode1/C

add wave -divider "Rotator Internal Signals"

add wave -position end -hex         sim:/AddrMode1/imm
add wave -position end -hex         sim:/AddrMode1/imm_double
add wave -position end -unsigned    sim:/AddrMode1/rot_amt
add wave -position end -hex         sim:/AddrMode1/rot_intermediate
add wave -position end -hex         sim:/AddrMode1/rot_res

add wave -divider "Shifter Internal Signals"

add wave -position end -unsigned    sim:/AddrMode1/shift_amt
add wave -position end -binary      sim:/AddrMode1/shift_code
add wave -position end -hex         sim:/AddrMode1/shift_res_00
add wave -position end -hex         sim:/AddrMode1/shift_res_01
add wave -position end -hex         sim:/AddrMode1/shift_res_10
add wave -position end -hex         sim:/AddrMode1/shift_res_11
add wave -position end -hex         sim:/AddrMode1/shift_res

add wave -divider "Outputs"

add wave -position end -hex         sim:/AddrMode1/shifter_operand
add wave -position end -binary      sim:/AddrMode1/shifter_carry
add wave -position end -unsigned    sim:/AddrMode1/test_number

##########################################
#  Test Cases
##########################################

force C             1
force is_LSIO       0
force is_LSHSBCO    0
force is_LSHSBSO    0

# Case 1

force IR        32'h0ab
force Rm_data   32'd0
force Rs_LSB    32'd0
force is_DPI    1
force is_DPIS   0
force is_DPRS   0

force test_number 5'd1

run 150

# Case 2

force IR        32'h2ab
force Rm_data   32'd0
force Rs_LSB    32'd0
force is_DPI    1
force is_DPIS   0
force is_DPRS   0

force test_number 5'd2

run 150

# Case 3

force IR        0
force Rm_data   32'hb1c
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   1
force is_DPRS   0

force test_number 5'd3

run 150

# Case 4

force IR        32'h280
force Rm_data   32'hb1c
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   1
force is_DPRS   0

force test_number 5'd4

run 150

# Case 5

force IR        32'h010
force Rm_data   32'h51ccd1cc
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd5

run 150

# Case 6

force IR        32'h010
force Rm_data   32'h51ccd1cc
force Rs_LSB    32'd16
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd6

run 150

# Case 7

force IR        32'h010
force Rm_data   32'hffffffff
force Rs_LSB    32'd32
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd7

run 150

# Case 8

force IR        32'h010
force Rm_data   32'hffffffff
force Rs_LSB    32'd33
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd8

run 150

# Case 9

force IR        32'h020
force Rm_data   32'ha5500000
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   1
force is_DPRS   0

force test_number 5'd9

run 150

# Case 10

force IR        32'h220
force Rm_data   32'ha5500000
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   1
force is_DPRS   0

force test_number 5'd10

run 150

# Case 11

force IR        32'h030
force Rm_data   32'hdeadbeef
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd11

run 150

# Case 12

force IR        32'h030
force Rm_data   32'hdeadbeef
force Rs_LSB    32'd4
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd12

run 150

# Case 13

force IR        32'h030
force Rm_data   32'hdeadbeef
force Rs_LSB    32'd32
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd13

run 150

# Case 14

force IR        32'h030
force Rm_data   32'hdeadbeef
force Rs_LSB    32'd33
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd14

run 150

# Case 15

force IR        32'h040
force Rm_data   32'h00000b01
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   1
force is_DPRS   0

force test_number 5'd15

run 150

# Case 16

force IR        32'h040
force Rm_data   32'h80000b01
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   1
force is_DPRS   0

force test_number 5'd16

run 150

# Case 17

force IR        32'h1c0
force Rm_data   32'h80000b01
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   1
force is_DPRS   0

force test_number 5'd17

run 150

# Case 18

force IR        32'h050
force Rm_data   32'h00002319
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd18

run 150

# Case 19

force IR        32'h050
force Rm_data   32'h80002319
force Rs_LSB    32'd4
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd19

run 150

# Case 20

force IR        32'h050
force Rm_data   32'h00002319
force Rs_LSB    32'd32
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd20

run 150

# Case 21

force IR        32'h050
force Rm_data   32'h80002319
force Rs_LSB    32'd32
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd21

run 150

# Case 22

force IR        32'h060
force Rm_data   32'h22222222
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   1
force is_DPRS   0

force test_number 5'd22

run 150

# Case 23

force IR        32'h260
force Rm_data   32'hdabadee0
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   1
force is_DPRS   0

force test_number 5'd23

run 150

# Case 24

force IR        32'h070
force Rm_data   32'h1234abcd
force Rs_LSB    32'd0
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd24

run 150

# Case 25

force IR        32'h070
force Rm_data   32'h1234abcd
force Rs_LSB    32'd64
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd25

run 150

# Case 26

force IR        32'h070
force Rm_data   32'h1234abcd
force Rs_LSB    32'd16
force is_DPI    0
force is_DPIS   0
force is_DPRS   1

force test_number 5'd26

run 150
