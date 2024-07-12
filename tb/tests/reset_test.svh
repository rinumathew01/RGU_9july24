
class reset_test extends rgu_test_base;

  // UVM Factory Registration Macro
  //
  `uvm_component_utils(reset_test)

  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name = "reset_test", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  // extern function void report_phase(uvm_phase phase);

endclass: reset_test

function reset_test::new(string name = "reset_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Build the env, create the env configuration
// including any sub configurations and assigning virtural interfaces
function void reset_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction: build_phase

task reset_test::run_phase(uvm_phase phase);

  // register_test_vseq t_seq =  register_test_vseq::type_id::create("t_seq");
  register_test_one_reg_vseq t_seq =  register_test_one_reg_vseq::type_id::create("t_seq");
  set_seqs(t_seq);
  phase.raise_objection(this, "RGU RESET Test Started");
  t_seq.start(null);
  #100;
  phase.drop_objection(this, "RGU RESET Test Finished");
endtask: run_phase
