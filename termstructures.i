#ifndef quantlib_term_structures_i
#define quantlib_term_structures_i

%include common.i
%include types.i
%include observer.i
%include date.i
%include interestrate.i
%include calendars.i
%include daycounters.i

%{
using QuantLib::TermStructure;
using QuantLib::Calendar;
using QuantLib::DayCounter;
using QuantLib::InterestRate;
using QuantLib::Date;
%}

%shared_ptr(TermStructure);
class TermStructure : public Observable {
  private:
    TermStructure();
  public:
    DayCounter dayCounter() const;
    Time timeFromReference(const Date& date) const;
    Calendar calendar() const;
    Date referenceDate() const;
    Date maxDate() const;
    Time maxTime() const;
    // from Extrapolator, since we can't use multiple inheritance
    // and we're already inheriting from Observable
    void enableExtrapolation();
    void disableExtrapolation();
    bool allowsExtrapolation();
};

%{
using QuantLib::YieldTermStructure;
%}

%shared_ptr(YieldTermStructure);
class YieldTermStructure : public TermStructure {
  private:
    YieldTermStructure();
  public:
    DiscountFactor discount(const Date&, bool extrapolate = false);
    DiscountFactor discount(Time, bool extrapolate = false);
    InterestRate zeroRate(const Date& d,
                          const DayCounter&, Compounding, Frequency f = Annual,
                          bool extrapolate = false) const;
    InterestRate zeroRate(Time t,
                          Compounding, Frequency f = Annual,
                          bool extrapolate = false) const;
    InterestRate forwardRate(const Date& d1, const Date& d2,
                             const DayCounter&, Compounding,
                             Frequency f = Annual,
                             bool extrapolate = false) const;
    InterestRate forwardRate(Time t1, Time t2,
                             Compounding, Frequency f = Annual,
                             bool extrapolate = false) const;
};

#endif //quantlib_term_structures_i
