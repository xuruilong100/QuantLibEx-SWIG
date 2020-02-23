#ifndef quantlib_interest_rate_i
#define quantlib_interest_rate_i

%include common.i
%include types.i
%include daycounters.i
%include stl.i

%{
using QuantLib::Compounding;
using QuantLib::Simple;
using QuantLib::Compounded;
using QuantLib::Continuous;
using QuantLib::SimpleThenCompounded;
using QuantLib::CompoundedThenSimple;
%}

enum Compounding {
    Simple,
    Compounded,
    Continuous,
    SimpleThenCompounded,
    CompoundedThenSimple
};

%{
using QuantLib::InterestRate;
%}

class InterestRate {
  public:
    InterestRate();
    InterestRate(Rate r,
                 const DayCounter& dc,
                 Compounding comp,
                 Frequency freq);
    Rate rate() const;
    DayCounter dayCounter() const;
    Compounding compounding() const;
    Frequency frequency() const;
    DiscountFactor discountFactor(Time t) const;
    DiscountFactor discountFactor(const Date& d1, const Date& d2,
                                  const Date& refStart = Date(),
                                  const Date& refEnd = Date()) const;
    Real compoundFactor(Time t) const;
    Real compoundFactor(const Date& d1, const Date& d2,
                        const Date& refStart = Date(),
                        const Date& refEnd = Date()) const;
    static InterestRate impliedRate(Real compound,
                                    const DayCounter& resultDC,
                                    Compounding comp,
                                    Frequency freq,
                                    Time t);
    static InterestRate impliedRate(Real compound,
                                    const DayCounter& resultDC,
                                    Compounding comp,
                                    Frequency freq,
                                    const Date& d1,
                                    const Date& d2,
                                    const Date& refStart = Date(),
                                    const Date& refEnd = Date());
    InterestRate equivalentRate(Compounding comp,
                                Frequency freq,
                                Time t) const;
    InterestRate equivalentRate(const DayCounter& resultDayCounter,
                                Compounding comp,
                                Frequency freq,
                                const Date& d1,
                                const Date& d2,
                                const Date& refStart = Date(),
                                const Date& refEnd = Date()) const;
    %extend {
        std::string __str__() {
            std::ostringstream out;
            out << *self;
            return out.str();
        }
    }
};

namespace std {
    %template(InterestRateVector) vector<InterestRate>;
}

#endif //quantlib_interest_rate_i
