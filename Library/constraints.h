#ifndef _CONSTRAINTS_H_
#define _CONSTRAINTS_H_

#include <stdio.h>


#define ML 1;
#define CL -1;

typedef struct {
	int x;
	int y;
	int sign;
} constraint;

constraint* read_constraints (FILE* in, int n_cs);

#endif /* _CONSTRAINTS_H_ */
