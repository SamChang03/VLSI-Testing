set TOP_DIR $TOPLEVEL
set RPT_DIR report
set NET_DIR netlist

sh rm -rf ./$TOP_DIR
sh rm -rf ./$RPT_DIR
sh rm -rf ./$NET_DIR
sh mkdir ./$TOP_DIR
sh mkdir ./$RPT_DIR
sh mkdir ./$NET_DIR

# define a lib path here
define_design_lib $TOPLEVEL -path ./$TOPLEVEL

# Read Design File (add your files here)
set HDL_DIR "../source" 
analyze -library $TOPLEVEL -format verilog "../hdl/mul_BIST.v"
analyze -library $TOPLEVEL -format verilog "../hdl/FSM.v"
analyze -library $TOPLEVEL -format verilog "../hdl/LFSR_6bit.v"
analyze -library $TOPLEVEL -format verilog "../hdl/register_in.v"
analyze -library $TOPLEVEL -format verilog "../hdl/multiplier.v"
analyze -library $TOPLEVEL -format verilog "../hdl/MISR_16bit.v"
analyze -library $TOPLEVEL -format verilog "../hdl/check_test.v"

# elaborate your design
elaborate $TOPLEVEL -architecture verilog -library $TOPLEVEL

# Solve Multiple Instance
set uniquify_naming_style "%s_mydesign_%d" 
uniquify 

# link the design
current_design $TOPLEVEL 
link