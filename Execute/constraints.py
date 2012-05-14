#!/usr/bin/env python
# encoding: utf-8
"""
constraints.py

Created by Tom Coleman on 2007-11-01.
Copyright (c) 2007 __MyCompanyName__. All rights reserved.
"""

import sys
import os
import random

"Generate n constraints from stdin (a set of labels)"
def main():
	n = int (sys.argv [1])

	labels = [line for line in sys.stdin]
	n_data = len (labels)
	
	# there are probably much more efficient ways to do this--FIXME if this
	# is slow...
	# can't do this in the natural way I'd like
	used = [[False] * n_data for i in range (n_data)]
	used[0][0] = True
	
	for i in range(n):
		x = y = 0
		while (used[x][y]):
			x = random.randint (0, n_data-2)
			y = random.randint (x+1, n_data-1)
		
		used[x][y] = True
			
		if labels[x] == labels[y]:
			sign = +1
		else:
			sign = -1
			
		print "%d,%d:%d" % (x, y, sign)

if __name__ == '__main__':
	main()

