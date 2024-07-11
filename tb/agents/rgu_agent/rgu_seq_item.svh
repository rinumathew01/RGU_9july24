
class rgu_seq_item extends uvm_sequence_item;

// UVM Factory Registration Macro
//
`uvm_object_utils(rgu_seq_item)

//------------------------------------------
// Data Members (Outputs rand, inputs non-rand)
//------------------------------------------
rand logic[127:0] rgu_data;
rand bit[6:0] no_bits;
rand bit RX_NEG;

// Analysis members:
logic[127:0] nedge_mosi;
logic[127:0] pedge_mosi;
logic[127:0] nedge_miso;
logic[127:0] pedge_miso;
logic[7:0] cs;

//------------------------------------------
// Constraints
//------------------------------------------



//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "rgu_seq_item");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function string convert2string();
extern function void do_print(uvm_printer printer);
extern function void do_record(uvm_recorder recorder);

endclass:rgu_seq_item

function rgu_seq_item::new(string name = "rgu_seq_item");
  super.new(name);
endfunction

function void rgu_seq_item::do_copy(uvm_object rhs);
  rgu_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_fatal("do_copy", "cast of rhs object failed")
  end
  super.do_copy(rhs);
  // Copy over data members:
  rgu_data = rhs_.rgu_data;
  no_bits = rhs_.no_bits;
  RX_NEG = rhs_.RX_NEG;
  nedge_mosi = rhs_.nedge_mosi;
  pedge_mosi = rhs_.pedge_mosi;
  nedge_miso = rhs_.nedge_miso;
  pedge_miso = rhs_.pedge_miso;
  cs = rhs_.cs;

endfunction:do_copy

function bit rgu_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  rgu_seq_item rhs_;

  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "cast of rhs object failed")
    return 0;
  end
  return super.do_compare(rhs, comparer) &&
         rgu_data == rhs_.rgu_data &&
         no_bits == rhs_.no_bits &&
         RX_NEG == rhs_.RX_NEG;
endfunction:do_compare

function string rgu_seq_item::convert2string();
  string s;

  $sformat(s, "%s\n", super.convert2string());
  // Convert to string function reusing s:
  $sformat(s, "%s rgu_data\t%0h\n no_bits\t%0b\n RX_NEG\t%0b\n",
           s, rgu_data, no_bits, RX_NEG);
  return s;

endfunction:convert2string

function void rgu_seq_item::do_print(uvm_printer printer);
  printer.m_string = convert2string();
endfunction:do_print

function void rgu_seq_item:: do_record(uvm_recorder recorder);
  super.do_record(recorder);

  // Use the record macros to record the item fields:
  `uvm_record_field("rgu_data", rgu_data)
  `uvm_record_field("no_bits", no_bits)
  `uvm_record_field("RX_NEG", RX_NEG)
endfunction:do_record
