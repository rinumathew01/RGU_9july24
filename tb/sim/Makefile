RTL       ?= ../../rtl
INTERFACE ?= ../../interface
TOP       ?= ../tb_top
AGENTS    ?= ../agents
REG_MODEL ?= ../reg_model
ENV       ?= ../env
SEQUENCES ?= ../sequences
TESTS     ?= ../tests


TESTNAME  ?= rgu_test_base



all: work build run

work:
	vlib work

build:
	cls
	vlog -incr +incdir+$(RTL) -sv $(RTL)/*.sv

	vlog -incr $(INTERFACE)/rgu_intf.sv

	vlog -incr +incdir+$(TOP) $(TOP)/tb_top.sv
	
	vlog -incr +incdir+$(AGENTS)/apb_agent $(AGENTS)/apb_agent/apb_agent_pkg.sv
	vlog -incr $(AGENTS)/apb_agent/apb_if.sv
	vlog -incr $(AGENTS)/apb_agent/apb_monitor_bfm.sv
	vlog -incr $(AGENTS)/apb_agent/apb_driver_bfm.sv
	
	vlog -incr +incdir+$(AGENTS)/rgu_agent $(AGENTS)/rgu_agent/rgu_agent_pkg.sv
	vlog -incr $(AGENTS)/rgu_agent/rgu_if.sv
	vlog -incr $(AGENTS)/rgu_agent/rgu_monitor_bfm.sv
	vlog -incr $(AGENTS)/rgu_agent/rgu_driver_bfm.sv

	vlog -incr $(REG_MODEL)/reg_pkg.sv

	vlog -incr +incdir+$(ENV) $(ENV)/rgu_env_pkg.sv

	vlog -incr +incdir+$(SEQUENCES) $(SEQUENCES)/rgu_bus_sequence_lib_pkg.sv
	vlog -incr +incdir+$(SEQUENCES) $(SEQUENCES)/rgu_test_seq_lib_pkg.sv

	vlog -incr +incdir+$(TESTS) $(TESTS)/rgu_test_lib_pkg.sv

run:
	vsim -c -do "run -all" tb_top +UVM_TESTNAME="$(TESTNAME)"

clean:
	rm -rf work vsim.wlf

