default: all

src_dir = $(BASEDIR)/soft/src/isa
bld_dir = $(BASEDIR)/build/isa/elf

include $(src_dir)/rv32ui/Makefrag
include $(src_dir)/rv32uc/Makefrag
include $(src_dir)/rv32um/Makefrag
include $(src_dir)/rv32mi/Makefrag

RISCV_GCC ?= $(RISCV)gcc
RISCV_GCC_OPTS ?= -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles
RISCV_INCL ?= -I $(src_dir)/../common -I $(src_dir)/../common/env -I $(src_dir)/macros/scalar
RISCV_LINK_OPTS ?= -T $(src_dir)/../common/link.ld
RISCV_OBJDUMP ?= $(RISCV)objdump -Mnumeric,no-aliases --disassemble --disassemble-zeroes
RISCV_OBJCOPY ?= $(RISCV)objcopy -O binary
RISCV_NM ?= $(RISCV)nm -A

vpath %.S $(src_dir)

define compile_template

$$($(1)_tests): $(1)-%: $(1)/%.S
	$$(RISCV_GCC) $$(RISCV_GCC_OPTS) $(4) $$(RISCV_INCL) $$(RISCV_LINK_OPTS) $$< -o $(3)/$$@.elf
	$$(RISCV_NM) $(3)/$$@.elf | grep -sw 'tohost' | sed -e 's/.*:\(.*\) D.*/\1/' > $(3)/$$@.host
	$$(RISCV_OBJDUMP) $(3)/$$@.elf > $(3)/$$@.dump
	$$(RISCV_OBJCOPY) $(3)/$$@.elf $(3)/$$@.bin
tests += $$($(1)_tests)

endef

$(eval $(call compile_template,rv32ui,$(src_dir),$(bld_dir),-march=rv32i_zicsr_zifencei -mabi=ilp32 -DXLEN=32))
$(eval $(call compile_template,rv32ua,$(src_dir),$(bld_dir),-march=rv32ia_zicsr_zifencei -mabi=ilp32 -DXLEN=32))
$(eval $(call compile_template,rv32uc,$(src_dir),$(bld_dir),-march=rv32ic_zicsr_zifencei -mabi=ilp32 -DXLEN=32))
$(eval $(call compile_template,rv32um,$(src_dir),$(bld_dir),-march=rv32im_zicsr_zifencei -mabi=ilp32 -DXLEN=32))
$(eval $(call compile_template,rv32uf,$(src_dir),$(bld_dir),-march=rv32if_zicsr_zifencei -mabi=ilp32 -DXLEN=32))
$(eval $(call compile_template,rv32ud,$(src_dir),$(bld_dir),-march=rv32id_zicsr_zifencei -mabi=ilp32 -DXLEN=32))
$(eval $(call compile_template,rv32mi,$(src_dir),$(bld_dir),-march=rv32imfd_zicsr_zifencei -mabi=ilp32 -DXLEN=32))

all: $(tests)

clean:
	rm -rf $(tests)
