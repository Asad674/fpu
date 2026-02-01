OP ?= add                  
TEST ?= fp32_$(OP)

MODELSIM = modelsim.exe
VLIB = vlib.exe 
FLIST = sim/filelists/$(TEST).f
VERILOG_SRC = $(OP)/rtl/$(OP).v  # Source files
TB_SRC = $(OP)/$(OP)_tb.v  # Testbench file
SIM_NAME = fp_$(OP)
TOP_MODULE = $(OP)_tb
WORK_DIR ?= work_$(OP)
MODE ?= RNE
VECTORS = $(OP)/vectors
GUI ?= 0
VSIM_FLAGS := -c
QUIT_CMD := quit -f

ifeq ($(GUI),1)
VSIM_FLAGS =
QUIT_CMD   =
else
VSIM_FLAGS = -c
QUIT_CMD   = quit -f
endif

# Initialize ModelSim work library
modelsim_init:
	@echo "Initializing ModelSim work library..."
	@if [ ! -d $(WORK_DIR) ]; then $(VLIB) $(WORK_DIR); fi

model_sim_compile: modelsim_init
	@echo "Compiling source files..."
	vlog.exe -work $(WORK_DIR) -f $(FLIST)

# Run simulation
modelsim: model_sim_compile
	vsim.exe -c -do "set OP $(OP); set MODE $(MODE); set IN $(VECTORS)/test_$(shell echo $(MODE) | tr A-Z a-z).txt; set OUT $(VECTORS)/test_$(shell echo $(MODE) | tr A-Z a-z)_result.txt; do sim/wave.do; $(QUIT_CMD)"

modelsim_all: model_sim_compile
	$(MAKE) modelsim MODE=RTZ | grep "TOTAL ERRORS"
	$(MAKE) modelsim MODE=RUP | grep "TOTAL ERRORS"
	$(MAKE) modelsim MODE=RDN | grep "TOTAL ERRORS"
	$(MAKE) modelsim MODE=RNE | grep "TOTAL ERRORS"
	$(MAKE) modelsim MODE=RMM | grep "TOTAL ERRORS"
