#ifndef quantlib_day_counters_i
#define quantlib_day_counters_i

%include common.i
%include calendars.i
%include date.i
%include types.i
%include stl.i
%include null.i
%include scheduler.i

%{
using QuantLib::DayCounter;
%}

class DayCounter {
  protected:
    DayCounter();
  public:
    BigInteger dayCount(const Date& d1, const Date& d2) const;
    Time yearFraction(const Date& d1, const Date& d2,
                      const Date& startRef = Date(),
                      const Date& endRef = Date()) const;
    std::string name() const;
    %extend {
        std::string __str__() {
            return self->name()+" day counter";
        }
        bool __eq__(const DayCounter& other) {
            return (*self) == other;
        }
        bool __ne__(const DayCounter& other) {
            return (*self) != other;
        }
    }
    %pythoncode %{
    def __hash__(self):
        return hash(self.name())
    %}
};

namespace QuantLib {

    class Actual360 : public DayCounter {
      public:
        Actual360(const bool includeLastDay = false);
    };
    class Actual365Fixed : public DayCounter {
      public:
        enum Convention { Standard, Canadian, NoLeap };
        Actual365Fixed(Convention c = Standard);
    };
    class Thirty360 : public DayCounter {
      public:
        enum Convention { USA, BondBasis, European, EurobondBasis, Italian };
        Thirty360(Convention c = USA);
    };
    class ActualActual : public DayCounter {
      public:
        enum Convention { ISMA, Bond, ISDA, Historical, Actual365, AFB, Euro };
        ActualActual(Convention c = ISDA, const Schedule& schedule = Schedule());
    };
    class OneDayCounter : public DayCounter {};
    class SimpleDayCounter : public DayCounter {};
    class Business252 : public DayCounter {
      public:
        Business252(Calendar c = Brazil());
    };
}

%inline %{
    /* avoid deprecation warnings */
    DayCounter Actual365NoLeap() {
        return QuantLib::Actual365Fixed(QuantLib::Actual365Fixed::NoLeap);
    }
%}

#endif //quantlib_day_counters_i