#ifndef quantlib_linear_algebra_i
#define quantlib_linear_algebra_i

%include common.i
%include types.i
%include stl.i

%{
using QuantLib::Array;
using QuantLib::Matrix;
using QuantLib::SampledCurve;
%}

%define QL_TYPECHECK_ARRAY       4210    %enddef
%define QL_TYPECHECK_MATRIX      4220    %enddef

%{
bool extractArray(PyObject* source, Array* target) {
    if (PyTuple_Check(source) || PyList_Check(source)) {
        Size size = (PyTuple_Check(source) ?
                     PyTuple_Size(source) :
                     PyList_Size(source));
        *target = Array(size);
        for (Size i=0; i<size; i++) {
            PyObject* o = PySequence_GetItem(source,i);
            if (PyFloat_Check(o)) {
                (*target)[i] = PyFloat_AsDouble(o);
                Py_DECREF(o);
            } else if (PyInt_Check(o)) {
                (*target)[i] = Real(PyInt_AsLong(o));
                Py_DECREF(o);
            } else {
                Py_DECREF(o);
                return false;
            }
        }
        return true;
    } else {
        return false;
    }
}
%}
%typemap(in) Array (Array* v) {
    if (extractArray($input,&$1)) {
        ;
    } else {
        SWIG_ConvertPtr($input,(void **) &v, $&1_descriptor,1);
        $1 = *v;
    }
};
%typemap(in) const Array& (Array temp) {
    if (extractArray($input,&temp)) {
        $1 = &temp;
    } else {
        SWIG_ConvertPtr($input,(void **) &$1,$1_descriptor,1);
    }
};
%typecheck(QL_TYPECHECK_ARRAY) Array {
    /* native sequence? */
    if (PyTuple_Check($input) || PyList_Check($input)) {
        Size size = PySequence_Size($input);
        if (size == 0) {
            $1 = 1;
        } else {
            PyObject* o = PySequence_GetItem($input,0);
            if (PyNumber_Check(o))
                $1 = 1;
            else
                $1 = 0;
            Py_DECREF(o);
        }
    } else {
        /* wrapped Array? */
        Array* v;
        if (SWIG_ConvertPtr($input,(void **) &v,
                            $&1_descriptor,0) != -1)
            $1 = 1;
        else
            $1 = 0;
    }
}
%typecheck(QL_TYPECHECK_ARRAY) const Array & {
    /* native sequence? */
    if (PyTuple_Check($input) || PyList_Check($input)) {
        Size size = PySequence_Size($input);
        if (size == 0) {
            $1 = 1;
        } else {
            PyObject* o = PySequence_GetItem($input,0);
            if (PyNumber_Check(o))
                $1 = 1;
            else
                $1 = 0;
            Py_DECREF(o);
        }
    } else {
        /* wrapped Array? */
        Array* v;
        if (SWIG_ConvertPtr($input,(void **) &v,
                            $1_descriptor,0) != -1)
            $1 = 1;
        else
            $1 = 0;
    }
}

%typemap(in) Matrix (Matrix* m) {
    if (PyTuple_Check($input) || PyList_Check($input)) {
        Size rows, cols;
        rows = (PyTuple_Check($input) ?
                PyTuple_Size($input) :
                PyList_Size($input));
        if (rows > 0) {
            // look ahead
            PyObject* o = PySequence_GetItem($input,0);
            if (PyTuple_Check(o) || PyList_Check(o)) {
                cols = (PyTuple_Check(o) ?
                        PyTuple_Size(o) :
                        PyList_Size(o));
                Py_DECREF(o);
            } else {
                PyErr_SetString(PyExc_TypeError, "Matrix expected");
                Py_DECREF(o);
                return NULL;
            }
        } else {
            cols = 0;
        }
        $1 = Matrix(rows,cols);
        for (Size i=0; i<rows; i++) {
            PyObject* o = PySequence_GetItem($input,i);
            if (PyTuple_Check(o) || PyList_Check(o)) {
                Size items = (PyTuple_Check(o) ?
                                        PyTuple_Size(o) :
                                        PyList_Size(o));
                if (items != cols) {
                    PyErr_SetString(PyExc_TypeError,
                        "Matrix must have equal-length rows");
                    Py_DECREF(o);
                    return NULL;
                }
                for (Size j=0; j<cols; j++) {
                    PyObject* d = PySequence_GetItem(o,j);
                    if (PyFloat_Check(d)) {
                        $1[i][j] = PyFloat_AsDouble(d);
                        Py_DECREF(d);
                    } else if (PyInt_Check(d)) {
                        $1[i][j] = Real(PyInt_AsLong(d));
                        Py_DECREF(d);
                    } else {
                        PyErr_SetString(PyExc_TypeError,"doubles expected");
                        Py_DECREF(d);
                        Py_DECREF(o);
                        return NULL;
                    }
                }
                Py_DECREF(o);
            } else {
                PyErr_SetString(PyExc_TypeError, "Matrix expected");
                Py_DECREF(o);
                return NULL;
            }
        }
    } else {
        SWIG_ConvertPtr($input,(void **) &m,$&1_descriptor,1);
        $1 = *m;
    }
};
%typemap(in) const Matrix & (Matrix temp) {
    if (PyTuple_Check($input) || PyList_Check($input)) {
        Size rows, cols;
        rows = (PyTuple_Check($input) ?
                PyTuple_Size($input) :
                PyList_Size($input));
        if (rows > 0) {
            // look ahead
            PyObject* o = PySequence_GetItem($input,0);
            if (PyTuple_Check(o) || PyList_Check(o)) {
                cols = (PyTuple_Check(o) ?
                        PyTuple_Size(o) :
                        PyList_Size(o));
                Py_DECREF(o);
            } else {
                PyErr_SetString(PyExc_TypeError, "Matrix expected");
                Py_DECREF(o);
                return NULL;
            }
        } else {
            cols = 0;
        }

        temp = Matrix(rows,cols);
        for (Size i=0; i<rows; i++) {
            PyObject* o = PySequence_GetItem($input,i);
            if (PyTuple_Check(o) || PyList_Check(o)) {
                Size items = (PyTuple_Check(o) ?
                                        PyTuple_Size(o) :
                                        PyList_Size(o));
                if (items != cols) {
                    PyErr_SetString(PyExc_TypeError,
                        "Matrix must have equal-length rows");
                    Py_DECREF(o);
                    return NULL;
                }
                for (Size j=0; j<cols; j++) {
                    PyObject* d = PySequence_GetItem(o,j);
                    if (PyFloat_Check(d)) {
                        temp[i][j] = PyFloat_AsDouble(d);
                        Py_DECREF(d);
                    } else if (PyInt_Check(d)) {
                        temp[i][j] = Real(PyInt_AsLong(d));
                        Py_DECREF(d);
                    } else {
                        PyErr_SetString(PyExc_TypeError,"doubles expected");
                        Py_DECREF(d);
                        Py_DECREF(o);
                        return NULL;
                    }
                }
                Py_DECREF(o);
            } else {
                PyErr_SetString(PyExc_TypeError, "Matrix expected");
                Py_DECREF(o);
                return NULL;
            }
        }
        $1 = &temp;
    } else {
        SWIG_ConvertPtr($input,(void **) &$1,$1_descriptor,1);
    }
};
%typecheck(QL_TYPECHECK_MATRIX) Matrix {
    /* native sequence? */
    if (PyTuple_Check($input) || PyList_Check($input)) {
        $1 = 1;
    /* wrapped Matrix? */
    } else {
        Matrix* m;
        if (SWIG_ConvertPtr($input,(void **) &m,
                            $&1_descriptor,0) != -1)
            $1 = 1;
        else
            $1 = 0;
    }
}
%typecheck(QL_TYPECHECK_MATRIX) const Matrix & {
    /* native sequence? */
    if (PyTuple_Check($input) || PyList_Check($input)) {
        $1 = 1;
    /* wrapped Matrix? */
    } else {
        Matrix* m;
        if (SWIG_ConvertPtr($input,(void **) &m,
                            $1_descriptor,0) != -1)
            $1 = 1;
        else
            $1 = 0;
    }
}

class Array {
    %rename(__len__)   size;
  public:
    Array();
    Array(Size n, Real fill = 0.0);
    Array(const Array&);
    Size size() const;
    %extend {
        std::string __str__() {
            std::ostringstream out;
            out << *self;
            return out.str();
        }
        Array __add__(const Array& a) {
            return Array(*self+a);
        }
        Array __sub__(const Array& a) {
            return Array(*self-a);
        }
        Array __mul__(Real a) {
            return Array(*self*a);
        }
        Real __mul__(const Array& a) {
            return QuantLib::DotProduct(*self,a);
        }
        Array __mul__(const Matrix& a) {
            return *self*a;
        }
        Array __div__(Real a) {
            return Array(*self/a);
        }
        Array __rmul__(Real a) {
            return Array(*self*a);
        }
        Array __getslice__(Integer i, Integer j) {
            Integer size_ = static_cast<Integer>(self->size());
            if (i<0)
                i = size_+i;
            if (j<0)
                j = size_+j;
            i = std::max(0,i);
            j = std::min(size_,j);
            Array tmp(j-i);
            std::copy(self->begin()+i,self->begin()+j,tmp.begin());
            return tmp;
        }
        void __setslice__(Integer i, Integer j, const Array& rhs) {
            Integer size_ = static_cast<Integer>(self->size());
            if (i<0)
                i = size_+i;
            if (j<0)
                j = size_+j;
            i = std::max(0,i);
            j = std::min(size_,j);
            QL_ENSURE(static_cast<Integer>(rhs.size()) == j-i,
                      "arrays are not resizable");
            std::copy(rhs.begin(),rhs.end(),self->begin()+i);
        }
        bool __nonzero__() {
            return (self->size() != 0);
        }
        bool __bool__() {
            return (self->size() != 0);
        }
        Real __getitem__(Integer i) {
            Integer size_ = static_cast<Integer>(self->size());
            if (i>=0 && i<size_) {
                return (*self)[i];
            } else if (i<0 && -i<=size_) {
                return (*self)[size_+i];
            } else {
                throw std::out_of_range("array index out of range");
            }
        }
        void __setitem__(Integer i, Real x) {
            Integer size_ = static_cast<Integer>(self->size());
            if (i>=0 && i<size_) {
                (*self)[i] = x;
            } else if (i<0 && -i<=size_) {
                (*self)[size_+i] = x;
            } else {
                throw std::out_of_range("array index out of range");
            }
        }
    }
};

// 2-D view

%{
typedef QuantLib::LexicographicalView<Array::iterator>
    DefaultLexicographicalView;
typedef QuantLib::LexicographicalView<Array::iterator>::y_iterator
    DefaultLexicographicalViewColumn;
%}

class DefaultLexicographicalViewColumn {
  private:
    // access control - no constructor exported
    DefaultLexicographicalViewColumn();
  public:
    %extend {
        Real __getitem__(Size i) {
            return (*self)[i];
        }
        void __setitem__(Size i, Real x) {
            (*self)[i] = x;
        }
    }
};

%rename(LexicographicalView) DefaultLexicographicalView;
class DefaultLexicographicalView {
  public:
    Size xSize() const;
    Size ySize() const;
    %extend {
        DefaultLexicographicalView(Array& a, Size xSize) {
            return new DefaultLexicographicalView(a.begin(),a.end(),xSize);
        }
        std::string __str__() {
            std::ostringstream s;
            for (Size j=0; j<self->ySize(); j++) {
                s << "\n";
                for (Size i=0; i<self->xSize(); i++) {
                    if (i != 0)
                        s << ",";
                    Array::value_type value = (*self)[i][j];
                    s << value;
                }
            }
            s << "\n";
            return s.str();
        }
        DefaultLexicographicalViewColumn __getitem__(Size i) {
            return (*self)[i];
        }
    }
};

// matrix class
%{
typedef QuantLib::Matrix::row_iterator MatrixRow;
using QuantLib::outerProduct;
using QuantLib::transpose;
using QuantLib::SVD;
%}

class MatrixRow {
  private:
    MatrixRow();
  public:
    %extend {
        Real __getitem__(Size i) {
            return (*self)[i];
        }
        void __setitem__(Size i, Real x) {
            (*self)[i] = x;
        }
    }
};

class Matrix {
  public:
    Matrix();
    Matrix(Size rows, Size columns, Real fill = 0.0);
    Matrix(const Matrix&);
    Size rows() const;
    Size columns() const;
    %extend {
        std::string __str__() {
            std::ostringstream out;
            out << *self;
            return out.str();
        }
        Matrix __add__(const Matrix& m) {
            return *self+m;
        }
        Matrix __sub__(const Matrix& m) {
            return *self-m;
        }
        Matrix __mul__(Real x) {
            return *self*x;
        }
        Array __mul__(const Array& x) {
            return *self*x;
        }
        Matrix __mul__(const Matrix& x) {
            return *self*x;
        }
        Matrix __div__(Real x) {
            return *self/x;
        }
        MatrixRow __getitem__(Size i) {
            return (*self)[i];
        }
        Matrix __rmul__(Real x) {
            return x*(*self);
        }
        Array __rmul__(const Array& x) {
            return x*(*self);
        }
        Matrix __rmul__(const Matrix& x) {
            return x*(*self);
        }
    }
};

// functions

%{
using QuantLib::pseudoSqrt;
using QuantLib::SalvagingAlgorithm;
%}

struct SalvagingAlgorithm {
    %rename(NoAlgorithm) None;
    enum Type { None, Spectral };
};

Matrix transpose(const Matrix& m);
Matrix outerProduct(const Array& v1, const Array& v2);
Matrix pseudoSqrt(const Matrix& m, SalvagingAlgorithm::Type a);

class SVD {
  public:
    SVD(const Matrix&);
    const Matrix& U() const;
    const Matrix& V() const;
    Matrix S() const;
    const Array& singularValues() const;
};

#endif //quantlib_linear_algebra_i