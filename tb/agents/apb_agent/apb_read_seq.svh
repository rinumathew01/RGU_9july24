class apb_read_seq extends uvm_sequence #(apb_seq_item);

// UVM Factory Registration Macro
//
`uvm_object_utils(apb_read_seq)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------
rand logic [31:0] addr;
logic [31:0] data;

//------------------------------------------
// Constraints
//------------------------------------------



//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "apb_read_seq");
extern task body;

endclass:apb_read_seq

function apb_read_seq::new(string name = "apb_read_seq");
  super.new(name);
endfunction

task apb_read_seq::body;
  apb_seq_item req = apb_seq_item::type_id::create("req");;

  begin
    start_item(req);
    req.we = 0;
    req.addr = addr;
    finish_item(req);
    data = req.data;
  end

endtask:body
