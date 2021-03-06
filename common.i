#ifndef quantlib_common_i
#define quantlib_common_i

%include stl.i
%include exception.i
%include boost_shared_ptr.i

%define QL_TYPECHECK_BOOL       7210    %enddef

%{
// This is necessary to avoid compile failures on
// GCC 4
// see http://svn.boost.org/trac/boost/ticket/1793

#if defined(NDEBUG)
#define BOOST_DISABLE_ASSERTS 1
#endif

#include <boost/algorithm/string/case_conv.hpp>
%}

%typemap(in) boost::optional<bool> %{
	if($input == Py_None)
		$1 = boost::none;
	else if ($input == Py_True)
		$1 = true;
	else
		$1 = false;
%}
%typecheck (QL_TYPECHECK_BOOL) boost::optional<bool> {
if (PyBool_Check($input) || Py_None == $input)
	$1 = 1;
else
	$1 = 0;
}

%{
// generally useful classes
using QuantLib::Error;
using QuantLib::Handle;
using QuantLib::RelinkableHandle;
%}

namespace boost {
    %extend shared_ptr {
        T* operator->() {
            return (*self).operator->();
        }
        bool __nonzero__() {
            return !!(*self);
        }
        bool __bool__() {
            return !!(*self);
        }
    }
}


template <class T>
class Handle {
  public:
    Handle(const boost::shared_ptr<T>& = boost::shared_ptr<T>());
    boost::shared_ptr<T> operator->();
    %extend {
        bool __nonzero__() {
            return !self->empty();
        }
        bool __bool__() {
            return !self->empty();
        }
    }
};

template <class T>
class RelinkableHandle : public Handle<T> {
  public:
    RelinkableHandle(const boost::shared_ptr<T>& = boost::shared_ptr<T>());
    void linkTo(const boost::shared_ptr<T>&);
    %extend {
        // could be defined in C++ class, added here in the meantime
        void reset() {
            self->linkTo(boost::shared_ptr<T>());
        }
    }
};

%define swigr_list_converter(ContainerRType,
                            ContainerCType, ElemCType)
%enddef

%define deprecate_feature(OldName, NewName)
%pythoncode %{
def OldName(*args, **kwargs):
    from warnings import warn
    warn('%s is deprecated; use %s' % (OldName.__name__, NewName.__name__))
    return NewName(*args, **kwargs)
%}
%enddef


#endif //quantlib_common_i
