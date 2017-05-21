# https://spin.atomicobject.com/2016/08/26/makefile-c-projects/
CC := g++

TARGET_EXEC ?= directives_tests
BUILD_DIR := build
SRC_DIRS := src
BIN_DIR?=bin
BIN?=$(BIN_DIR)/$(TARGET_EXEC)

SOURCES := $(shell find $(SRC_DIRS) -type f -name *.cpp -or -name *.c -or -name *.s)
TEMP_OBJECTS_C = $(patsubst $(SRC_DIRS)/%.c,$(BUILD_DIR)/%.c.o,$(SOURCES))
TEMP_OBJECTS_S = $(patsubst $(SRC_DIRS)/%.s,$(BUILD_DIR)/%.s.o,$(TEMP_OBJECTS_C))
TEMP_OBJECTS_CPP = $(patsubst $(SRC_DIRS)/%.cpp,$(BUILD_DIR)/%.cpp.o,$(TEMP_OBJECTS_S))
OBJS = $(TEMP_OBJECTS_CPP)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))


CPPFLAGS ?= $(INC_FLAGS) -MMD -MP -g -std=c++0x -Wall
CFLAGS ?= -g -std=c++0x -Wall
LIB := -lpthread

$(BIN): $(OBJS)
	$(CC) $^ -o $@ $(LDFLAGS) $(LIB)

#assembly
$(BUILD_DIR)/%.s.o: $(SRC_DIRS)/%.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: $(SRC_DIRS)/%.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: $(SRC_DIRS)/%.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

.PHONY: clean
clean:
	$(RM) -rf $(BUILD_DIR)/*
	$(RM) -rf $(BIN_DIR)/*

-include $(DEPS)

MKDIR_P ?= mkdir -p
