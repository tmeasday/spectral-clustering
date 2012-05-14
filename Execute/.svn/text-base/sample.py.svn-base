#!/usr/bin/env python
# encoding: utf-8
"""
sample.py

Created by Tom Coleman on 2007-11-01.
Copyright (c) 2007 __MyCompanyName__. All rights reserved.
"""

import sys
import os
import random

def main():
	dimension = 0
	n = int (sys.argv [1])
	
	# file format is as follows:
	# weight:x_mean, y_mean, ...:x_var, y_var (or just one for isotropic)
	dists = []
	weights = []
	for line in sys.stdin:
		(w, means, varies) = line.split (":")
		
		weights.append (float (w))
		means = [float (m) for m in means.split (",")]
		
		if dimension != 0:
			assert (len (means) == dimension)
		else:
			dimension = len (means)
			
		varies = [float (v) for v in varies.split (",")]
		if len (varies) == 1:
			varies = varies * dimension
		else:
			assert (len (varies) == dimension)
		
		dists.append ((means, varies))
	
	# normalize the weights
	weights = [w / sum (weights) for w in weights]

	# output is x, y, z, ...:label
	for i in range (n):
		distr = random.random ()
		distn  = -1
		while distr >= 0:
			distn += 1
			distr -= weights[distn]
		dist = dists[distn]
		
		coord = []
		for d in range (dimension):
			coord.append (random.gauss (dist[0][d], dist[1][d]))
	
		print ",".join (["%.3f" % c for c in coord]) + ":" + str (distn)
	

if __name__ == '__main__':
	main()

