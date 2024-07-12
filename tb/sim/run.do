vsim tb_top +UVM_TESTNAME=reset_test

add wave -position insertpoint  \
sim:/tb_top/apb_if0/PCLK \
sim:/tb_top/apb_if0/PRESETn \
sim:/tb_top/apb_if0/PADDR \
sim:/tb_top/apb_if0/PRDATA \
sim:/tb_top/apb_if0/PWDATA \
sim:/tb_top/apb_if0/PSEL \
sim:/tb_top/apb_if0/PENABLE \
sim:/tb_top/apb_if0/PWRITE \
sim:/tb_top/apb_if0/PREADY

run -all