TEST=fp32_add
DESIGN_NAME = add
SRC_DIR = adder
MODELSIM = modelsim.exe
VLIB = vlib.exe 
FLIST = sim/filelists/$(TEST).f
VERILOG_SRC = $(SRC_DIR)/rtl/$(DESIGN_NAME).v  # Source files
TB_SRC = $(SRC_DIR)/$(DESIGN_NAME)_tb.v  # Testbench file
SIM_NAME = fp_$(DESIGN_NAME)
TOP_MODULE = $(DESIGN_NAME)_tb
WORK_DIR = work_add
MODE ?= RNE
VECTORS = $(SRC_DIR)/vectors

# Initialize ModelSim work library
modelsim_init:
	@echo "Initializing ModelSim work library..."
	@if [ ! -d $(WORK_DIR) ]; then $(VLIB) $(WORK_DIR); fi

model_sim_compile: modelsim_init
	@echo "Compiling source files..."
	vlog.exe -work $(WORK_DIR) -f $(FLIST)

# Run simulation
modelsim: model_sim_compile
	vsim.exe -c -do "set MODE $(MODE); set IN $(BASE)/test_$(shell echo $(MODE) | tr A-Z a-z).txt; set OUT $(BASE)/test_$(shell echo $(MODE) | tr A-Z a-z)_result.txt; do sim/wave.do; quit -f"

modelsim_all: model_sim_compile
	$(MAKE) modelsim MODE=RTZ | grep "TOTAL ERRORS"
	$(MAKE) modelsim MODE=RUP | grep "TOTAL ERRORS"
	$(MAKE) modelsim MODE=RDN | grep "TOTAL ERRORS"
	$(MAKE) modelsim MODE=RNE | grep "TOTAL ERRORS"
	$(MAKE) modelsim MODE=RMM | grep "TOTAL ERRORS"
