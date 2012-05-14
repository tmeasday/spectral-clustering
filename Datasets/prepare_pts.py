#!/usr/bin/python

import sys

data = []

n_fields = 0

for line in sys.stdin:
	if (line.strip () == ''):
		continue
		
	line = line.strip ().split (',')
	size = len (line)
	if n_fields == 0:
		n_fields = size
	else:
		assert (n_fields == size)
	
	data.append (line)
	
# check for strings in the first line
cols = []
classes = {}
for i, col in enumerate (data[0]):
	try:
		float (col)
	except:
		cols.append (i)
		classes[i] = [col.strip ()]

for i, line in enumerate (data):
	for j in range (n_fields):
		col = data[i][j].strip ()	

		if (j in cols):
			if col in classes [j]:
				data[i][j] = classes[j].index (col)
			else:
				data[i][j] = len (classes[j])
				classes[j].append (col)
		
		sys.stdout.write (str (data[i][j]).strip ())
		if (j != n_fields -1):
			sys.stdout.write (',')
	print