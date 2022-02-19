default: none

RISCV ?= /opt/riscv/bin
MARCH ?= rv64imfdc_zba_zbb_zbc
MABI ?= lp64d
GCC ?= /usr/bin/gcc
PYTHON ?= /usr/bin/python2
CSMITH ?= /opt/csmith
CSMITH_INCL ?= $(shell ls -d $(CSMITH)/include/csmith-* | head -n1)
AAPG ?= aapg
CONFIG ?= integer
BASEDIR ?= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OVP ?= riscv-ovpsim-plus-bitmanip-tests.zip
TEST ?= dhrystone
OFFSET ?= 0x400000
ITER ?= 10

generate:
	@if [ ${TEST} = "compliance" ]; \
	then \
		soft/compliance.sh ${RISCV} ${MARCH} ${MABI} ${XLEN} ${PYTHON} ${OFFSET} ${BASEDIR}; \
	elif [ ${TEST} = "ovp" ]; \
	then \
		soft/ovp.sh ${RISCV} ${MARCH} ${MABI} ${XLEN} ${PYTHON} ${OFFSET} ${BASEDIR} ${OVP}; \
	elif [ ${TEST} = "dhrystone" ]; \
	then \
		soft/dhrystone.sh ${RISCV} ${MARCH} ${MABI} ${ITER} ${PYTHON} ${OFFSET} ${BASEDIR}; \
	elif [ ${TEST} = "coremark" ]; \
	then \
		soft/coremark.sh ${RISCV} ${MARCH} ${MABI} ${ITER} ${PYTHON} ${OFFSET} ${BASEDIR}; \
	elif [ ${TEST} = "csmith" ]; \
	then \
		soft/csmith.sh ${RISCV} ${MARCH} ${MABI} ${GCC} ${CSMITH} ${CSMITH_INCL} ${PYTHON} ${OFFSET} ${BASEDIR}; \
	elif [ ${TEST} = "torture" ]; \
	then \
		soft/torture.sh ${RISCV} ${MARCH} ${MABI} ${PYTHON} ${OFFSET} ${BASEDIR}; \
	elif [ ${TEST} = "uart" ]; \
	then \
		soft/uart.sh ${RISCV} ${MARCH} ${MABI} ${ITER} ${PYTHON} ${OFFSET} ${BASEDIR}; \
	elif [ ${TEST} = "timer" ]; \
	then \
		soft/timer.sh ${RISCV} ${MARCH} ${MABI} ${ITER} ${PYTHON} ${OFFSET} ${BASEDIR}; \
	elif [ ${TEST} = "aapg" ]; \
	then \
		soft/aapg.sh ${RISCV} ${MARCH} ${MABI} ${ITER} ${PYTHON} ${OFFSET} ${BASEDIR} ${AAPG} ${CONFIG}; \
	fi

all: generate
