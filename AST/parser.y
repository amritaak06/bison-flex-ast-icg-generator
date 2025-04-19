%{
// NAME: AMRITAA KALANEE
// SRN: PES1UG22CS077
// SECTION: B
#include "abstract_syntax_tree.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char* s);       // error handling function
int yylex();                 // lexical analyzer function
extern int yylineno;         // track the line number
%}

%union
{
	char* text;
	expression_node* exp_node;
}

%token <text> T_ID T_NUM IF ELSE DO WHILE
%type <text> RELOP
%type <exp_node> E T F START ASSGN S C SEQ

%start START

%%

START : SEQ {
	display_exp_tree($1);
	printf("\nValid syntax\n");
	YYACCEPT;
};

SEQ : S SEQ {
		$$ = init_exp_node("seq", $1, $2, NULL);
	}
	| S {
		$$ = $1;
	}
;

S : IF '(' C ')' '{' SEQ '}' {
		$$ = init_exp_node(strdup("if"), $3, $6, NULL);
	}
	| IF '(' C ')' '{' SEQ '}' ELSE '{' SEQ '}' {
		$$ = init_exp_node(strdup("if-else"), $3, $6, $10);
	}
	| DO '{' SEQ '}' WHILE '(' C ')' ';' {
		$$ = init_exp_node(strdup("do-while"), $7, $3, NULL);
	}
	| ASSGN {
		$$ = $1;
	}
;

C : F RELOP F {
	$$ = init_exp_node(strdup($2), $1, $3, NULL);
}
;

RELOP : '<'        { $$ = "<"; }
      | '>'        { $$ = ">"; }
      | '>' '='    { $$ = ">="; }
      | '<' '='    { $$ = "<="; }
      | '=' '='    { $$ = "=="; }
      | '!' '='    { $$ = "!="; }
;

ASSGN : T_ID '=' E ';' {
	$$ = init_exp_node(strdup("="), init_exp_node(strdup($1), NULL, NULL, NULL), $3, NULL);
}
;

E : E '+' T {
	$$ = init_exp_node(strdup("+"), $1, $3, NULL);
}
  | E '-' T {
	$$ = init_exp_node(strdup("-"), $1, $3, NULL);
}
  | T { $$ = $1; }
;

T : T '*' F {
	$$ = init_exp_node(strdup("*"), $1, $3, NULL);
}
  | T '/' F {
	$$ = init_exp_node(strdup("/"), $1, $3, NULL);
}
  | F { $$ = $1; }
;

F : '(' E ')' { $$ = $2; }
  | T_ID {
	$$ = init_exp_node(strdup($1), NULL, NULL, NULL);
}
  | T_NUM {
	$$ = init_exp_node(strdup($1), NULL, NULL, NULL);
}
;

%%

void yyerror(char* s)
{
	printf("Error: %s at line %d\n", s, yylineno);
}

int yywrap() {
	return 1;
}

int main(int argc, char* argv[])
{
	printf("Preorder:\n");
	yyparse();
	return 0;
}
