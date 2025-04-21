@echo off
echo Generating parser...
bison -d parser.y

echo Generating lexer...
flex lexer.l

echo Compiling...
gcc -o ast parser.tab.c lex.yy.c abstract_syntax_tree.c

echo Running test_input1.c
ast.exe < test_input1.c

echo Running test_input2.c
ast.exe < test_input2.c

echo Running test_input3.c
ast.exe < test_input3.c


echo Running test_input4.c
ast.exe < test_input4.c
