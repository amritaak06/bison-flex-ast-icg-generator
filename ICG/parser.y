%{
// NAME: AMRITAA KALANEE
// SRN: PES1UG22CS077
// SECTION: B
#include "quad_generation.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYSTYPE char*

void yyerror(char* s);                    // error handling function
int yylex();                              // declare the function performing lexical analysis
extern int yylineno;                      // track the line number

FILE* icg_quad_file;
int temp_no = 1;
int label_no = 1;
%}

%token T_ID T_NUM T_IF T_ELSE GTEQ LTEQ EQQ NEQ GT LT OC CC
%token T_DO T_WHILE

%start START

%nonassoc T_IF
%nonassoc T_ELSE

%%

START : S {
    printf("-----------------------------------------------------\n");
    printf("Valid syntax\n");
    YYACCEPT;
};

ASSGN : T_ID '=' E {
    quad_code_gen($1, $3, "=", " ");
};

E : E '+' T {
        $$ = new_temp();
        quad_code_gen($$, $1, "+", $3);
    }
  | E '-' T {
        $$ = new_temp();
        quad_code_gen($$, $1, "-", $3);
    }
  | T
;

T : T '*' F {
        $$ = new_temp();
        quad_code_gen($$, $1, "*", $3);
    }
  | T '/' F {
        $$ = new_temp();
        quad_code_gen($$, $1, "/", $3);
    }
  | F
;

F : '(' E ')' {
        $$ = strdup($2);
    }
  | T_ID {
        $$ = strdup($1);
    }
  | T_NUM {
        $$ = strdup($1);
    }
;

S : T_IF '(' C ')' OC S CC {
        quad_code_gen($3, "", "Label", "");
    } S
  | T_IF '(' C ')' OC S CC T_ELSE OC S CC {
        $2 = new_label();
        quad_code_gen($2, "", "goto", "");
        quad_code_gen($3, "", "Label", "");
        quad_code_gen($2, "", "Label", "");
    } S
  | T_DO OC S CC T_WHILE '(' C ')' ';' S {
        char* Lstart = new_label();
        char* Ltrue = new_label();
        char* Lexit = new_label();

        quad_code_gen(Lstart, "", "Label", "");      // Lstart: start of loop body
        // S is already processed (loop body)
        quad_code_gen($7, "", "if", Ltrue);          // if condition true → Ltrue
        quad_code_gen(Lexit, "", "goto", "");        // else → exit
        quad_code_gen(Ltrue, "", "Label", "");       // Ltrue:
        quad_code_gen(Lstart, "", "goto", "");       // loop
        quad_code_gen(Lexit, "", "Label", "");       // Lexit:
    }
  | ASSGN ';' S
  | '{' S '}'
  | /* epsilon */
;

C : E rel E {
        $$ = new_temp();
        quad_code_gen($$, $1, $2, $3);
        $1 = new_label();
        quad_code_gen($1, $$, "if", "");
        $$ = new_label();
        quad_code_gen($$, "", "goto", "");
        quad_code_gen($1, "", "Label", "");
    }
;

rel : GT    { strcpy($$, ">"); }
    | LT    { strcpy($$, "<"); }
    | LTEQ  { strcpy($$, "<="); }
    | GTEQ  { strcpy($$, ">="); }
    | EQQ   { strcpy($$, "=="); }
    | NEQ   { strcpy($$, "!="); }
;

%%

void yyerror(char* s)
{
    printf("Error :%s at %d \n", s, yylineno);
}

int yywrap() {
    return 1;
}

int main(int argc, char* argv[])
{
    printf("Generated Intermediate Code \n");
    printf("-----------------------------------------------------\n");
    printf("| %-10s | %-10s | %-10s | %-10s |\n", "op", "arg1", "arg2", "result");
    printf("-----------------------------------------------------\n");
    yyparse();
    return 0;
}
