@echo off
echo Generating parser...
bison -d parser.y

echo Generating lexer...
flex lexer.l

echo Compiling...
gcc -g parser.tab.c lex.yy.c quad_generation.c -o a.exe

echo Running test_input1.c
a.exe < test_input1.c

echo Running test_input2.c
a.exe < test_input2.c

echo Running text_input3.c
a.exe < test_input3.c