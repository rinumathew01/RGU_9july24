class apb_coverage_monitor extends uvm_subscriber #(apb_seq_item);

// UVM Factory Registration Macro
//
`uvm_component_utils(apb_coverage_monitor);


//------------------------------------------
// Cover Group(s)
//------------------------------------------
covergroup apb_cov;
OPCODE: coverpoint analysis_txn.we {
  bins write = {1};
  bins read = {0};
}
// To do:
// Monitor is not returning delay info
endgroup

//------------------------------------------
// Component Members
//------------------------------------------
apb_seq_item analysis_txn;

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:

extern function new(string name = "apb_coverage_monitor", uvm_component parent = null);
extern function void write(T t);
extern function void report_phase(uvm_phase phase);

endclass: apb_coverage_monitor

function apb_coverage_monitor::new(string name = "apb_coverage_monitor", uvm_component parent = null);
  super.new(name, parent);
  apb_cov = new();
endfunction

function void apb_coverage_monitor::write(T t);
  analysis_txn = t;
  apb_cov.sample();
endfunction:write

function void apb_coverage_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc

endfunction: report_phase
