#!/usr/bin/python

import sys

dir = sys.argv[1]

pts = open (dir + '/pts')

n_pts = 0
n_cols = 0
for line in pts:
	cols = len (line.split (','))
	if (n_cols == 0):
		n_cols = cols
	else:
		assert (n_cols == cols)
	
	n_pts += 1
	
lbls = open (dir + '/lbls')
n_lbls = len (lbls.readlines ())
assert (n_lbls == n_pts), 'wrong number of labels: %d (%d)' % (n_lbls, n_pts)

types = open (dir + '/types')
line = types.readline ()
n_types = len (line.split (','))
assert (n_types == n_cols), 'wrong number of types: %d (%d)' % (n_types, n_cols)