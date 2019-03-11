############################################################################### 
# General Purpose Microsoft Makefile
# 
# Copyright (C) 2018, Martin Tang
############################################################################### 

# Toolchain
AR=$(TARGET)ar
PP=$(TARGET)cpp
AS=$(TARGET)as
CC=$(TARGET)gcc
CX=$(TARGET)g++
DB=$(TARGET)gdb
OD=$(TARGET)objdump
OC=$(TARGET)objcopy
RC=windres
FL=flex
BS=bison
LD=$(TARGET)gcc
RM=del

# Configuration
ARFLAGS=cr
PPFLAGS=
ASFLAGS=
CCFLAGS=-O3 -ffast-math -DVERSION=\"5.08\"
CXFLAGS=
DBFLAGS=
RCFLAGS=
FLFLAGS=
BSFLAGS=
LDFLAGS=
EXFLAGS=

# Projects
OBJECT1=source\atak.o \
				source\book.o \
				source\cmd.o \
				source\epd.o \
				source\eval.o \
				source\genmove.o \
				source\getopt.o \
				source\getopt1.o \
				source\hash.o \
				source\hung.o \
				source\init.o \
				source\input.o \
				source\iterate.o \
				source\main.o \
				source\move.o \
				source\null.o \
				source\output.o \
				source\players.o \
				source\pgn.o \
				source\ponder.o \
				source\quiesce.o \
				source\random.o \
				source\repeat.o \
				source\search.o \
				source\solve.o \
				source\sort.o \
				source\swap.o \
				source\test.o \
				source\ttable.o \
				source\util.o \
				source\lexpgn.o
OUTPUT1=gnuchess.exe

# Dependency
$(OUTPUT1) : $(OBJECT1)

# Summary
LIBRARY=-lpthread
OBJECTS=$(OBJECT1)
OUTPUTS=$(OUTPUT1)
DEPENDS=$(OBJECTS:.o=.dep)
CLEANUP=$(OBJECTS) $(OUTPUTS) $(DEPENDS)

# Build Commands
all: $(OUTPUTS)

run: $(OUTPUTS)
	@echo [EX] $<
	@$< $(EXFLAGS)

debug: $(OUTPUTS)
	@echo [DB] $<
	@$(DB) $(DBFLAGS) $<

clean:
	@echo [RM] $(CLEANUP)
	-@$(RM) $(CLEANUP)

# Standard Procedures
%.dep : %.S
	@$(PP) $(PPFLAGS) -MM -MT $(@:.dep=.o) -o $@ $<

%.dep : %.c
	@$(PP) $(PPFLAGS) -MM -MT $(@:.dep=.o) -o $@ $<

%.dep : %.cpp
	@$(PP) $(PPFLAGS) -MM -MT $(@:.dep=.o) -o $@ $<

%.dep : %.rc
	@$(PP) $(PPFLAGS) -MM -MT $(@:.dep=.o) -o $@ $<

%.dep : %.l
	@$(PP) $(PPFLAGS) -MM -MT $(@:.dep=.o) -o $@ $<

%.dep : %.y
	@$(PP) $(PPFLAGS) -MM -MT $(@:.dep=.o) -o $@ $<

%.o : %.S
	@echo [AS] $<
	@$(AS) $(ASFLAGS) -c -o $@ $<

%.o : %.c
	@echo [CC] $<
	@$(CC) $(CCFLAGS) -c -o $@ $<

%.o : %.cpp
	@echo [CX] $<
	@$(CX) $(CXFLAGS) -c -o $@ $<

%.o : %.rc
	@echo [RC] $<
	@$(RC) $(RCFLAGS) -o $@

%.c : %.l
	@echo [FL] $<
	@$(FL) $(FLFLAGS) -o $@ $<

%.c : %.y
	@echo [BS] $<
	@$(BS) $(BSFLAGS) -d -o $@ $<

%.a :
	@echo [AR] $@
	@$(AR) $(ARFLAGS) $@ $^

%.dll :
	@echo [LD] $@
	@$(LD) $(LDFLAGS) -o $@ $^ $(LIBRARY)

%.exe :
	@echo [LD] $@
	@$(LD) $(LDFLAGS) -o $@ $^ $(LIBRARY)

%.elf:
	@echo [LD] $@
	@$(LD) $(LDFLAGS) -o $@ $^ $(LIBRARY)

%.hex : %.exe
	@echo [OC] $@
	@$(OC) -O ihex $< $@

%.hex : %.elf
	@echo [OC] $@
	@$(OC) -O ihex $< $@

-include $(DEPENDS)
