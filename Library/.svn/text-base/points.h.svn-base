#ifndef _POINTS_H_
#define _POINTS_H_

#include <stdio.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>

typedef gsl_vector* point;

point* read_points (FILE* in, int dim, int n_ps);
void print_point (FILE* out, point p, int dim);

double distance (point x, point y);
double distance_A (point x, point y, gsl_matrix* A);

#endif /* _POINTS_H_ */
