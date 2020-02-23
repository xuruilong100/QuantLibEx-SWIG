%{
#ifdef barrier
#undef barrier
#endif
%}

%{
#include <ql/quantlib.hpp>

#ifdef BOOST_MSVC
#ifdef QL_ENABLE_THREAD_SAFE_OBSERVER_PATTERN
#define BOOST_LIB_NAME boost_thread
#include <boost/config/auto_link.hpp>
#undef BOOST_LIB_NAME
#define BOOST_LIB_NAME boost_system
#include <boost/config/auto_link.hpp>
#undef BOOST_LIB_NAME
#endif
#endif

// add here SWIG version check

#if defined(_MSC_VER)         // Microsoft Visual C++ 6.0
// disable Swig-dependent warnings

// 'identifier1' has C-linkage specified,
// but returns UDT 'identifier2' which is incompatible with C
#pragma warning(disable: 4190)

// 'int' : forcing value to bool 'true' or 'false' (performance warning)
#pragma warning(disable: 4800)

// debug info too long etc etc
#pragma warning(disable: 4786)
#endif
%}

#ifdef SWIGPYTHON
%{
#if PY_VERSION_HEX < 0x02010000
    #error Python version 2.1.0 or later is required
#endif
%}
#endif

%include bonds.i
%include calendars.i
%include cashflows.i
%include common.i
%include date.i
%include daycounters.i
%include fittedbondcurve.i
%include functions.i
%include instruments.i
%include interestrate.i
%include linearalgebra.i
%include marketelements.i
%include null.i
%include observer.i
%include optimizers.i
%include ratehelpers.i
%include scheduler.i
%include settings.i
%include termstructures.i
%include types.i
%include vectors.i
