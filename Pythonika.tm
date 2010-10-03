:Begin:
:Function: Py
:Pattern: Py[input_String]
:Arguments: {input}
:ArgumentTypes: {String}
:ReturnType: Manual
:End:

:Begin:
:Function: PyInteger
:Pattern: PyInteger[name_String, value_Integer]
:Arguments: {name, N[value]}
:ArgumentTypes: {String, LongInteger}
:ReturnType: Null
:End:

:Begin:
:Function: PyReal
:Pattern: PyReal[name_String, value_Real]
:Arguments: {name, N[value]}
:ArgumentTypes: {String, Real}
:ReturnType: Null
:End:

:Begin:
:Function: PyComplex
:Pattern: PyComplex[name_String, value_Complex]
:Arguments: {name, Re[N[value]], Im[N[value]]}
:ArgumentTypes: {String, Real, Real}
:ReturnType: Null
:End:

:Begin:
:Function: PyString
:Pattern: PyString[name_String, value_String]
:Arguments: {name, ToCharacterCode[value]}
:ArgumentTypes: {String, IntegerList}
:ReturnType: Manual
:End:

:Begin:
:Function: PyUnicodeString
:Pattern: PyString[name_String, value_UnicodeString]
:Arguments: {name, value}
:ArgumentTypes: {String, UnicodeString}
:ReturnType: Null
:End:

:Begin:
:Function: PySymbol
:Pattern: PySymbol[name_String, value_Symbol]
:Arguments: {name, value}
:ArgumentTypes: {String, Symbol}
:ReturnType: Null
:End:

:Begin:
:Function: PyOpenList
:Pattern: PyOpenList[name_String]
:Arguments: {name}
:ArgumentTypes: {String}
:ReturnType: Manual
:End:

:Begin:
:Function: PyCloseList
:Pattern: PyCloseList[]
:Arguments: {}
:ArgumentTypes: {}
:ReturnType: Null
:End:

:Evaluate: ToPy[arg_, obj_:Null] := If[StringQ[arg], ToPySingle[arg, obj], If[ListQ[arg], Map[ToPySingle[#[[1]], #[[2]]]&, arg];] ]

:Evaluate: ToPySingle[name_, obj_] := Switch[obj, _Integer, PyInteger[name, obj], _String, PyString[name, obj], _Real, PyReal[name, obj], _Symbol, PySymbol[name, obj], _Complex, PyComplex[name, obj], _UnicodeString, PyUnicodeString[name, obj], _List, PyOpenList[name]; Map[ToPy["", #]&, obj]; PyCloseList[]; ]

:Evaluate: code = "import parser, symbol\ndef scan(tree):\n  if tree[0] == symbol.funcdef:\n    return tree[2][1] # Function name\n  elif isinstance(tree[1], tuple):\n      return scan(tree[1])\n  return None\n\ndef __get_function_name__(code):\n  ast = parser.suite(code)\n  tup = ast.totuple()\n  return scan(tup)\n"

:Evaluate: PyFunctionCreator[funcDef_, args__] = {
    If[Length[Names["code"]]==1, Py[code]; Remove["code"]];
    Py[funcDef];
    ToPy["__function_code__", funcDef];
    ToPy[
    "__function_arguments__", If[Length[{args}] == 1, {args}, {
    args}]];
    funcName = Py["__get_function_name__(__function_code__)"];
    result = Py[funcName <> "(*__function_arguments__)"];
    Py["del __function_code__, __function_arguments__"];
    result}[[1]] &;
          
:Evaluate: PyFunction=Function[{funcDef},PyFunctionCreator[funcDef,##]];
