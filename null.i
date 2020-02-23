#ifndef quantlib_null_values_i
#define quantlib_null_values_i

%include exception.i

%{
using QuantLib::Null;
typedef int intOrNull;
typedef double doubleOrNull;
%}

%inline%{
int nullInt() { return Null<int>(); }
double nullDouble() { return Null<double>(); }
%}

%typemap(in) intOrNull {
    if ($input == Py_None)
        $1 = Null<int>();
    else if (PyInt_Check($input))
        $1 = int(PyInt_AsLong($input));
    else
        SWIG_exception(SWIG_TypeError,"int expected");
}
%typecheck(SWIG_TYPECHECK_INTEGER) intOrNull {
    $1 = ($input == Py_None || PyInt_Check($input)) ? 1 : 0;
}
%typemap(out) intOrNull {
    if ($1 == Null<int>()) {
        Py_INCREF(Py_None);
        $result = Py_None;
    } else {
        $result = PyInt_FromLong(long($1));
    }
}

%typemap(in) doubleOrNull {
    if ($input == Py_None)
        $1 = Null<double>();
    else if (PyFloat_Check($input))
        $1 = PyFloat_AsDouble($input);
    else
        SWIG_exception(SWIG_TypeError,"double expected");
}
%typecheck(SWIG_TYPECHECK_DOUBLE) doubleOrNull {
    $1 = ($input == Py_None || PyFloat_Check($input)) ? 1 : 0;
}
%typemap(out) doubleOrNull {
    if ($1 == Null<double>()) {
        Py_INCREF(Py_None);
        $result = Py_None;
    } else {
        $result = PyFloat_FromDouble($1);
    }
}

#endif //quantlib_null_values_i
