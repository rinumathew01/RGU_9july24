RTL       ?= ../../rtl
INTERFACE ?= ../../interface
AGENTS    ?= ../agents
TESTS     ?= ../tests
TOP       ?= ../tb_top

TESTNAME  ?= base_test

all: work build run

work:
	vlib work

build:
	vlog -incr +incdir+$(RTL) -sv $(RTL)/*.sv
	vlog -incr $(INTERFACE)/rgu_intf.sv
	vlog -incr +incdir+$(TOP) $(TOP)/tb_top.sv
	vlog -incr +incdir+$(AGENTS) $(AGENTS)/apb_agent_pkg.sv
	vlog -incr $(AGENTS)/apb_agent/apb_if.sv
	vlog -incr $(AGENTS)/apb_agent/apb_monitor_bfm.sv
	vlog -incr $(AGENTS)/apb_agent/apb_driver_bfm.sv

run:
	vsim -c -do "run -all" tb_top +UVM_TESTNAME="$(TESTNAME)"

clean:
	rm -rf work vsim.wlf
