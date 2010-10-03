/*
    Pythonika 1.0 - Python Interpreter Interface for Mathematica.
    
    Copyright (c) 2005-2010 Ero Carrera <ero@dkbza.org>

    All rights reserved.

*/

#include <Python.h>
#include <pyport.h>
#include <compile.h>
#include <object.h>
#include <eval.h>

#include <stdio.h>

/*
#define DEBUG(x)    {           \
    FILE *fd;                   \
    fd = fopen("/path/to/log/file.log", "at+");\
    fputs(x, fd);               \
    fputs("\n", fd);            \
    fclose(fd);}
*/
#define DEBUG(x)    {}


// Structure holding the objects dealing
// with a interactive interpreter instance.

typedef struct interpreter_state {
    PyObject *main_module;
    PyObject *main_dict;
    PyObject *capture_stdout;
    PyObject *capture_stderr;
    PyObject *__builtins__;
} InterpreterState;

void init_interpreter(void);
void shutdown_interpreter(void);
void handle_error(void);
void mat_eval_compiled_code(PyObject *code_obj, int parse_mode);
void mat_eval_compiled_code_silent(PyObject *code_obj, int parse_mode);
void mat_process_iterable_object(PyObject *obj, char *error_msg);
void python_to_mathematica_object(PyObject *obj);
void Pythonika(char *input);
