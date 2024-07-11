registers = []

with open("Reg_list.csv") as file:
    for line in file:
        registers.append(list(i.strip() for i in line.split(",")))

def reg_or_field(line_lis):
    if line_lis[0] != "":
        return "REG"
    else:
        return "FIELD"

def reg_details(index):
    if reg_or_field(registers[index]) == "REG":
        return registers[index][0:4]
    if index == 0:
        return
    return reg_details(index-1)

def field_details(index):
    return registers[index][4:]

def get_reg_names():
    lis = []
    for i in range(1, len(registers)):
        if reg_or_field(registers[i]) == "REG":
            lis.append(reg_details(i)[0])
    return lis

def ret_section1(regname):
    code = """
  //--------------------------------------------------------------------
  // Class: {}_reg
  // Description: {}
  // 
  //--------------------------------------------------------------------

  class {}_reg extends uvm_reg;
    `uvm_object_utils({}_reg)
"""
    descr = ""
    for i in range(1, len(registers)):
        if reg_details(i)[0] == regname:
            descr = registers[i][-1]
            break
    return code.format(regname,descr,regname,regname)

def ret_section2(regname):
    code = ""
    for i in range(1, len(registers)):
        inner_code = "    rand uvm_reg_field {}; // {}\n"
        if reg_details(i)[0] == regname and reg_or_field(registers[i]) == "FIELD":
            # code += str(registers[i])
            code += inner_code.format(field_details(i)[0],field_details(i)[-1])
    return code

def ret_section3(regname):
    code = """
    // Function: new
    // 
    function new(string name = "{}_reg");
      super.new(name, {}, {});
    endfunction
"""
    for i in range(1,len(registers)):
        if regname == registers[i][0]:
            reg_size = registers[i][2]
            reg_cov  = registers[i][3]
            break
    return code.format(regname,reg_size,reg_cov)

def ret_section4(regname):
    code = """
    // Function: build
    // 
    virtual function void build();
"""
    return code

def ret_section5(regname):
    code = ""
    for i in range(1, len(registers)):
        inner_code = """      {} = uvm_reg_field::type_id::create("{}");\n"""
        if reg_details(i)[0] == regname and reg_or_field(registers[i]) == "FIELD":
            code += inner_code.format(field_details(i)[0],field_details(i)[0])
    return code

def ret_section6(regname):
    code = ""
    for i in range(1, len(registers)):
        inner_code = """      {}.configure(
        .parent                 ( this ),
        .size                   ( {} ),
        .lsb_pos                ( {} ),
        .access                 ( "{}" ),
        .volatile               ( {} ),
        .reset                  ( 'h{} ),
        .has_reset              ( {} ),
        .is_rand                ( {} ),
        .individually_accessible( {} ));\n
"""
        if reg_details(i)[0] == regname and reg_or_field(registers[i]) == "FIELD":
            code += inner_code.format(*field_details(i))
    return code

def ret_section7(regname):
    code = """    endfunction
  endclass: {}_reg
"""
    return code.format(regname)

def ret_rb_section1():
    code = """
  //--------------------------------------------------------------------
  // Class: my_reg_block
  // 
  //--------------------------------------------------------------------
  class my_reg_block extends uvm_reg_block;
    `uvm_object_utils(my_reg_block)
"""
    return code

def ret_rb_section2():
    code = ""
    reg_names = get_reg_names()
    for reg_name in reg_names:
        inner_code = "    rand {}_reg {};\n".format(reg_name,reg_name)
        code += inner_code
    return code

def ret_rb_section3():
    code = """
    // Function: new
    // 
    function new (string name = "top_reg_block");
      super.new(name, UVM_NO_COVERAGE);
    endfunction

    // Function: build
    // 
    function void build;"""
    return code

def ret_rb_section4():
    code = ""
    for reg_name in get_reg_names():
        inner_code = """
      {} = {}_reg::type_id::create("{}");
      {}.build();
      {}.configure(this);
      """.format(reg_name,reg_name,reg_name,reg_name,reg_name)
        code += inner_code
    return code

def ret_rb_section5():
    code = """      default_map = create_map("default_map", 0, 8, UVM_LITTLE_ENDIAN); // instance, base_addr, size in byte, endian\n"""
    for i in range(1, len(registers)):
        if reg_or_field(registers[i]) == "REG":
            inner_code = """      default_map.add_reg({}, 'h{}, "RW"); // instance, offset , access\n""".format(registers[i][0],registers[i][1])
            code += inner_code
    return code
def ret_rb_section6():
    code = """      lock_model();
          
    endfunction
  endclass: my_reg_block
"""
    return code

def reg_classes_generate():
    for regname in get_reg_names():
        print(ret_section1(regname))
        print(ret_section2(regname))
        print(ret_section3(regname))
        print(ret_section4(regname))
        print(ret_section5(regname))
        print(ret_section6(regname))
        print(ret_section7(regname))

        print("\n\n\n\n")

def reg_block_generate():
    print(ret_rb_section1())
    print(ret_rb_section2())
    print(ret_rb_section3())
    print(ret_rb_section4())
    print(ret_rb_section5())
    print(ret_rb_section6())

def gen_reg_pkg():
    print("""
// ** Note: This code was auto-generated by a python file

//----------------------------------------------------------------------
// my_reg_pkg
//----------------------------------------------------------------------
package my_reg_pkg;

   import uvm_pkg::*;

   `include "uvm_macros.svh"

    """)
    reg_classes_generate()
    reg_block_generate()
    print("endpackage: my_reg_pkg")


gen_reg_pkg()

# print(ret_section1("Reg1"))
# print(ret_section2("Reg1"))
# print(ret_section3("Reg1"))
# print(ret_section4("Reg1"))
# print(ret_section5("Reg1"))
# print(ret_section6("Reg1"))
# print(ret_section7("Reg1"))

# Field Name CTRL
# Field Size 32
# Field LSB Position 0
# Field Access RW
# Field Volatile 0
# Field Reset Value 0
# Field Has Reset 1
# Field Is Rand 1
# Field Individually Accessible 1



# for i in range(1,len(registers)):
#     print(registers[i])
#     print(reg_or_field(registers[i]))
#     print(reg_details(i))
#     print(field_details(i))
#     print()

# reg_class = """
#    //--------------------------------------------------------------------
#    // Class: {}
#    // 
#    //--------------------------------------------------------------------

#    class {} extends uvm_reg;
#       `uvm_object_utils({})

#       rand uvm_reg_field {}; 
#       rand uvm_reg_field {}; 

#       // Function: new
#       // 
#       function new(string name = "{}");
#          super.new(name, {}, {});
#       endfunction

#       // Function: build
#       // 
#       virtual function void build();
#          {} = uvm_reg_field::type_id::create("{}");
#          {} = uvm_reg_field::type_id::create("{}");

#          {}.configure(this, 8, 8, "RW", 0, 8'h00, 1, 1, 1);
#          cs.configure(this, 8, 0, "RW", 0, 8'h00, 1, 1, 1);
#       endfunction
#    endclass

# """