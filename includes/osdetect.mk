# Provides variables useful for determining the operating system we're running
# on.
#
# OS_NAME will reflect the name of the operating system: Darwin, Linux or Windows
# OS_CPU will be either x86 (32bit) or amd64 (64bit)
# OS_ARCH will be either i686 (32bit) or x86_64 (64bit)
#
ifeq (Windows_NT,$(OS))
OS_NAME := Windows
OS_CPU  := $(call _lower,$(PROCESSOR_ARCHITECTURE))
OS_ARCH := $(if $(findstring amd64,$(OS_CPU)),x86_64,i686)
else
OS_NAME := $(shell uname -s)
OS_ARCH := $(shell uname -m)
OS_CPU  := $(if $(findstring 64,$(OS_ARCH)),amd64,x86)
endif

ifneq (main.mk,$(findstring main.mk,$(MAKEFILE_LIST)))
include $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/main.mk
endif
