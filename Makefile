export CC= gcc
export CFLAGS= -Wall -std=c99 -gdwarf-2 -pg 


all: Library Algorithms

.PHONY: Library Algorithms

Library:
	$(MAKE) -C Library

Algorithms:
	$(MAKE) -C Algorithms

Execute:
	$(MAKE) -C Execute

Data:
	$(MAKE) -C Data
