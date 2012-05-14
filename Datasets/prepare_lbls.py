#!/usr/bin/python

import sys

lbl_1 = ''

for line in sys.stdin:
	if lbl_1 == '':
		lbl_1 = line
		
	if lbl_1 == line:
		print 1
	else:
		print -1