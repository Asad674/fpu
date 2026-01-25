
if {![info exists MODE]} { set MODE "RNE" }
if {![info exists IN]} { set IN "adder/vectors" }
if {![info exists OUT]} { set OUT "adder/vectors" }



quit -sim

# Load the compiled design (only if not already loaded)
if {[catch {vsim work_add.add_tb}]} {
    echo "Design already loaded"
} else {
     vsim work_add.add_tb +MODE=$MODE +IN=$IN +OUT=$OUT
}



add wave -r sim:/add_tb/*

radix signal in1 float32
radix signal in2 float32
radix signal out float32
radix signal exp_res float32

# Ensure the wave window is visible
view wave

# Run the simulation
run -all
