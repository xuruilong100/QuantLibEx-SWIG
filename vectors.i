#ifndef quantlib_vectors_i
#define quantlib_vectors_i

%include stl.i
%include date.i

namespace std {

    %template(IntVector) vector<int>;
    %template(UnsignedIntVector) vector<unsigned int>;
    %template(DoubleVector) vector<double>;
    %template(StrVector) vector<std::string>;
    %template(BoolVector) vector<bool>;
    %template(DoublePair) pair<double,double>;
    %template(DoublePairVector) vector<pair<double,double> >;
}

%{
#include <boost/tuple/tuple.hpp>
%}

namespace boost {
  template <typename T1=void, typename T2=void, typename T3=void>
  struct tuple;

  template <>
  struct tuple<void,void,void> {
  };

  template <typename T1>
  struct tuple<T1, void, void> {
    tuple(T1);
    %extend {
      T1 first() const {
        return boost::get<0>(*$self);
      }
    }
  };

  template <typename T1, typename T2>
  struct tuple <T1, T2, void> {
    tuple(T1,T2);
    %extend {
      T1 first() const {
        return boost::get<0>(*$self);
      }
      T2 second() const {
        return boost::get<1>(*$self);
      }
    }
  };

  template <typename T1, typename T2, typename T3>
  struct tuple <T1,T2,T3> {
    tuple(T1,T2,T3);
    %extend {
      T1 first() const {
        return boost::get<0>(*$self);
      }
      T2 second() const {
        return boost::get<1>(*$self);
      }
      T3 third() const {
        return boost::get<2>(*$self);
      }
    }
  };
}

#endif //quantlib_vectors_i
