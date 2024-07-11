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
	vlog -incr +incdir+$(TOP) $(TOP)/tb_top.sv

run:
	vsim -c -do "run -all" tb_top +UVM_TESTNAME="$(TESTNAME)"

clean:
	rm -rf work vsim.wlf
