# AST & ICG for Control Structures using Flex and Bison

This project is a **compiler front-end for a subset of C**, developed as part of the Compiler Design Lab at PES University (Semester 6). It implements two key components of a compiler:
- Abstract Syntax Tree (AST) Construction  
- Intermediate Code Generation (ICG)  
The compiler supports key control flow constructs like `if`, `if-else`, and `do-while` using tools like **Flex**, **Bison**, and **C**.

## 📌 Features

### Abstract Syntax Tree (AST)
- Built during syntax analysis using Bison grammar rules
- Supports:
  - Assignment statements
  - Arithmetic expressions
  - `if`, `if-else`, `do-while` statements
- Displays **preorder traversal** of the AST

### Intermediate Code Generation (ICG)
- Generates 3-address (quadruple-style) intermediate code
- Handles:
  - Arithmetic and assignment operations
  - Conditional and unconditional jumps
  - Label generation for `if`, `else`, `do-while`
- Outputs neatly formatted intermediate code in a tabular structure

### Prerequisites
Ensure the following tools are installed:
- `flex` (Lexical Analyzer Generator)
- `bison` (Parser Generator)
- `gcc` (C Compiler)

To install them on Ubuntu:

```sh
sudo apt-get install flex bison gcc
```

### 🛠️ Compilation & Execution

**To compile and run AST:**

```sh
cd AST
bison -d parser.y
flex lexer.l
gcc -o ast parser.tab.c lex.yy.c abstract_syntax_tree.c
./ast < test_input1.c
```

**To compile and run ICG:**

```sh
cd ICG
bison -d parser.y
flex lexer.l
gcc -o icg parser.tab.c lex.yy.c quad_generation.c
./icg < test_input1.c
```

## 📂 Project Structure

```
compiler-ast-icg/
├── AST/
│   ├── abstract_syntax_tree.c          # AST node creation & traversal
│   ├── abstract_syntax_tree.h
│   ├── parser.y                        # Bison grammar for AST
│   ├── parser.tab.c/h                  # Bison-generated files
│   ├── lexer.l                         # Flex scanner
│   ├── lex.yy.c                        # Flex-generated lexer
│   ├── test_input{1..4}.c              # Sample input files
│   ├── test_input{sol}.png             # AST Output screenshots
│   └── ast.exe                         # Executable
│
├── ICG/
│   ├── quad_generation.c              # Quadruple generation logic
│   ├── quad_generation.h
│   ├── parser.y                       # Bison grammar for ICG
│   ├── parser.tab.c/h
│   ├── lexer.l
│   ├── lex.yy.c
│   ├── test_input{1..3}.c
│   ├── test_input{sol}.png            # ICG Output screenshots
│   └── a.exe
```

## Supported Language Constructs

- Arithmetic expressions (`+`, `-`, `*`, `/`)
- Assignment statements (`a = b + 1;`)
- Conditional statements (`if`, `if-else`)
- Looping constructs (`do-while`)
- Nested blocks `{ ... }`
- Preorder AST traversal and 3-address code generation

### Sample AST Output

```
Preorder:
do-while,<,a,b,seq,=,a,+,a,1,=,b,-,b,1
Valid syntax
```

### Sample ICG Output

```
Generated Intermediate Code
-----------------------------------------------------
| op         | arg1       | arg2       | result     |
-----------------------------------------------------
| +          | a          | 1          | t1         |
| =          | t1         |            | a          |
| -          | b          | 1          | t2         |
| =          | t2         |            | b          |
| <          | a          | b          | t3         |
| if         | t3         |            | L1         |
| goto       |            |            | L2         |
| Label      |            |            | L1         |
| goto       |            |            | L0         |
| Label      |            |            | L2         |
Valid syntax
```

## Author

**Amritaa**  
3rd Year B.Tech  
PES University  
Compiler Design Lab – Semester 6

## 📜 References

- PES University Compiler Design Lab Syllabus  
- Flex & Bison documentation
