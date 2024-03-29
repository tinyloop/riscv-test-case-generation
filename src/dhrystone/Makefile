default: all

src_dir = $(BASEDIR)/soft/src
bld_dir = $(BASEDIR)/build/dhrystone/elf
srcs = $(wildcard $(src_dir)/common/*.S) $(wildcard $(src_dir)/common/*.c) $(wildcard $(src_dir)/dhrystone/*.c)
objs0 = $(srcs:.c=.o)
objs = $(objs0:.S=.o)

RISCV_GCC ?= $(RISCV)gcc
RISCV_GCC_OPTS ?= -march=$(MARCH) -mabi=$(MABI) -g -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O3 -ffast-math -fno-common
RISCV_LINK_OPTS ?= -static -nostartfiles -lm -lc -lgcc -T $(src_dir)/common/link.ld -D DEBUG_ENABLED
RISCV_OBJDUMP ?= $(RISCV)objdump -S -Mnumeric,no-aliases --disassemble --disassemble-zeroes
RISCV_OBJCOPY ?= $(RISCV)objcopy -O binary
RISCV_INCL ?= -I$(src_dir)/env -I$(src_dir)/dhrystone -I$(src_dir)/common -I$(src_dir)/common/env
RISCV_NM ?= $(RISCV)nm -A

dhrystone.elf: $(objs)
	$(RISCV_GCC) $(RISCV_INCL) $(RISCV_GCC_OPTS) $^ -o $(bld_dir)/$@ $(RISCV_LINK_OPTS)
	mv $^ $(bld_dir)

%.o: %.c
	$(RISCV_GCC) $(RISCV_INCL) $(RISCV_GCC_OPTS) -DNUMBER_OF_RUNS=$(ITER) -c $< -o $@

%.o: %.S
	$(RISCV_GCC) $(RISCV_INCL) $(RISCV_GCC_OPTS) -c $< -o $@

dhrystone.host: $(bld_dir)/dhrystone.elf
	$(RISCV_NM) $< | grep -sw 'tohost' | sed -e 's/.*:\(.*\) D.*/\1/' > $(bld_dir)/$@

dhrystone.dump: $(bld_dir)/dhrystone.elf
	$(RISCV_OBJDUMP) $< > $(bld_dir)/$@

dhrystone.bin: $(bld_dir)/dhrystone.elf
	$(RISCV_OBJCOPY) $< $(bld_dir)/$@

# Default

all: dhrystone.elf dhrystone.host dhrystone.dump dhrystone.bin
