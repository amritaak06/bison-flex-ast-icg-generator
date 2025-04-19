#ifndef QUAD_GENERATION_H
#define QUAD_GENERATION_H

#include <stdio.h>

extern FILE* icg_quad_file;
extern int temp_no;
extern int label_no;

void quad_code_gen(char* a, char* b, char* op, char* c);
char* new_temp();
char* new_label();  // <-- ADD THIS

#endif
