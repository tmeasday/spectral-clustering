#!/usr/bin/env python
# encoding: utf-8
"""
to_matrix.py

Created by Tom Coleman on 2007-11-04.
Copyright (c) 2007 __MyCompanyName__. All rights reserved.
"""

import sys
import os
import math

sigmasq = 0.1

def distsq (p1, p2):
	s = sum ([(c1 - c2)**2 for (c1, c2) in zip (p1, p2)])
	return s

def sim (p1, p2):
	return math.exp (-distsq (p1, p2)/(2*sigmasq))	

def main():
	points = []
	for line in sys.stdin:
		points.append (map (float, line.strip ().split (",")))

	n = len (points)

	W = []
	for p1 in points:
		m_line = []
		for p2 in points:
			m_line.append (sim (p1, p2))
		W.append (m_line)
		
	D = []
	for i in range (n):
		D.append ([0] * n)
		D[i][i] = sum (W[i])
		
	V = [[0] * n for i in range (n)]
	for i in range (n):
		for j in range (n):
			V[i][j] = D[i][j] - W[i][j]
			
	
	for i in range (n):
		for j in range (n):
			print V[i][j],
		print
		
if __name__ == '__main__':
	main()

