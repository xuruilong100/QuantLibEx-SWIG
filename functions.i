#ifndef quantlib_functions_i
#define quantlib_functions_i

%include linearalgebra.i
%include types.i

%{
using QuantLib::CostFunction;
using QuantLib::Disposable;
%}

%{
class UnaryFunction {
  public:
    UnaryFunction(PyObject* function) : function_(function) {
        Py_XINCREF(function_);
    }
    UnaryFunction(const UnaryFunction& f) : function_(f.function_) {
        Py_XINCREF(function_);
    }
    UnaryFunction& operator=(const UnaryFunction& f) {
        if ((this != &f) && (function_ != f.function_)) {
            Py_XDECREF(function_);
            function_ = f.function_;
            Py_XINCREF(function_);
        }
        return *this;
    }
    ~UnaryFunction() {
        Py_XDECREF(function_);
    }
    Real operator()(Real x) const {
        PyObject* pyResult = PyObject_CallFunction(function_,"d",x);
        QL_ENSURE(pyResult != NULL, "failed to call Python function");
        Real result = PyFloat_AsDouble(pyResult);
        Py_XDECREF(pyResult);
        return result;
    }
    Real derivative(Real x) const {
        PyObject* pyResult =
            PyObject_CallMethod(function_,"derivative","d",x);
        QL_ENSURE(pyResult != NULL,
                  "failed to call derivative() on Python object");
        Real result = PyFloat_AsDouble(pyResult);
        Py_XDECREF(pyResult);
        return result;
    }
  private:
    PyObject* function_;
};

class BinaryFunction {
  public:
    BinaryFunction(PyObject* function) : function_(function) {
        Py_XINCREF(function_);
    }
    BinaryFunction(const BinaryFunction& f)
    : function_(f.function_) {
        Py_XINCREF(function_);
    }
    BinaryFunction& operator=(const BinaryFunction& f) {
        if ((this != &f) && (function_ != f.function_)) {
            Py_XDECREF(function_);
            function_ = f.function_;
            Py_XINCREF(function_);
        }
        return *this;
    }
    ~BinaryFunction() {
        Py_XDECREF(function_);
    }
    Real operator()(Real x, Real y) const {
        PyObject* pyResult = PyObject_CallFunction(function_,"dd",x,y);
        QL_ENSURE(pyResult != NULL, "failed to call Python function");
        Real result = PyFloat_AsDouble(pyResult);
        Py_XDECREF(pyResult);
        return result;
    }
  private:
    PyObject* function_;
};

class PyCostFunction : public CostFunction {
  public:
    PyCostFunction(PyObject* function) : function_(function) {
        Py_XINCREF(function_);
    }
    PyCostFunction(const PyCostFunction& f)
    : function_(f.function_) {
        Py_XINCREF(function_);
    }
    PyCostFunction& operator=(const PyCostFunction& f) {
        if ((this != &f) && (function_ != f.function_)) {
            Py_XDECREF(function_);
            function_ = f.function_;
            Py_XINCREF(function_);
        }
        return *this;
    }
    ~PyCostFunction() {
        Py_XDECREF(function_);
    }
    Real value(const Array& x) const {
        PyObject* tuple = PyTuple_New(x.size());
        for (Size i=0; i<x.size(); i++)
            PyTuple_SetItem(tuple,i,PyFloat_FromDouble(x[i]));
        PyObject* pyResult = PyObject_CallObject(function_,tuple);
        Py_XDECREF(tuple);
        QL_ENSURE(pyResult != NULL, "failed to call Python function");
        Real result = PyFloat_AsDouble(pyResult);
        Py_XDECREF(pyResult);
        return result;
    }
    Disposable<Array> values(const Array& x) const {
        QL_FAIL("Not implemented");
        // Should be straight forward to copy from a python list
        // to an array
    }
  private:
    PyObject* function_;
};
%}

#endif //quantlib_functions_i
