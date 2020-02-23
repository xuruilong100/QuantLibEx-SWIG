#ifndef quantlib_rate_helpers_i
#define quantlib_rate_helpers_i

%include bonds.i
%include date.i
%include calendars.i
%include daycounters.i
%include marketelements.i
%include types.i
%include vectors.i

%{
using QuantLib::RateHelper;
using QuantLib::BondHelper;
using QuantLib::FixedRateBondHelper;
%}

%shared_ptr(RateHelper)
class RateHelper : public Observable {
  public:
    const Handle<Quote>& quote() const;
    Date latestDate() const;
	Date earliestDate() const;
	Date maturityDate() const;
	Date latestRelevantDate() const;
	Date pillarDate() const;
	Real impliedQuote() const;
	Real quoteError() const;
  private:
    RateHelper();
};

%shared_ptr(BondHelper)
class BondHelper : public RateHelper {
  public:
    BondHelper(const Handle<Quote>& cleanPrice,
               const boost::shared_ptr<Bond>& bond,
               bool useCleanPrice = true);

    boost::shared_ptr<Bond> bond();
};

%shared_ptr(FixedRateBondHelper)
class FixedRateBondHelper : public BondHelper {
  public:
    FixedRateBondHelper(
                  const Handle<Quote>& cleanPrice,
                  Size settlementDays,
                  Real faceAmount,
                  const Schedule& schedule,
                  const std::vector<Rate>& coupons,
                  const DayCounter& paymentDayCounter,
                  BusinessDayConvention paymentConvention = Following,
                  Real redemption = 100.0,
                  const Date& issueDate = Date(),
                  const Calendar& paymentCalendar = Calendar(),
                  const Period& exCouponPeriod = Period(),
                  const Calendar& exCouponCalendar = Calendar(),
                  BusinessDayConvention exCouponConvention = Unadjusted,
                  bool exCouponEndOfMonth = false,
                  bool useCleanPrice = true);

    boost::shared_ptr<FixedRateBond> fixedRateBond();
};

// allow use of RateHelper vectors
namespace std {
    %template(RateHelperVector) vector<boost::shared_ptr<RateHelper> >;
}

// allow use of RateHelper vectors
namespace std {
    %template(BondHelperVector) vector<boost::shared_ptr<BondHelper> >;
}

#endif //quantlib_rate_helpers_i
