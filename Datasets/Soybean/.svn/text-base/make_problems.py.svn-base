#!/usr/bin/python

P_DIR = 'Problems/'
labels_file = 'large_wo_qns_text_labels.txt'
data_file   = 'large_wo_qns_unnormalized.txt'

label_lengths = []
last = ''
length = 0
labels = []
for line in open (labels_file):
	if line != last:
		if length != 0:
			label_lengths.append (length)
			labels.append (line.strip ())
		last = line
		length = 1
	else:
		length += 1
label_lengths.append (length)
labels.append (line.strip ())

n = len (label_lengths)

data = open(data_file).readlines ()

for i in range (n):
	i_first = sum (label_lengths[0:i])
	
	for j in range (i+1, n):
		j_first = sum (label_lengths[0:j])

		pts_file = P_DIR + 'pts_%s_%s' % (labels[i], labels[j])
		lbls_file = P_DIR + 'lbls_%s_%s' % (labels[i], labels[j])
		
		lbls = open (lbls_file, 'w')
		pts  = open (pts_file, 'w')
		for k in range (label_lengths[i]):
			print >> lbls, -1
			print >> pts, data[i_first + k],
			
			
		for k in range (label_lengths[j]):
			print >> lbls, 1
			print >> pts, data[j_first + k],
		