// 
//  constraints.c
//  Clustering
//  
//  Created by Tom Coleman on 2007-11-08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
// 

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "constraints.h"

constraint*
read_constraints (FILE* in, int n_cs)
{
	constraint* cs = calloc (n_cs, sizeof (constraint));
	
	for (int i = 0; i < n_cs; i++) {
		assert (fscanf (in, "%d, %d: %d", &(cs[i].x), &(cs[i].y), &(cs[i].sign)) == 3); 
	}
	
	return cs;
}