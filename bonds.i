#ifndef quantlib_bonds_i
#define quantlib_bonds_i

%include instruments.i
%include calendars.i
%include daycounters.i
%include cashflows.i
%include interestrate.i

%{
using QuantLib::Bond;
using QuantLib::FixedRateBond;
%}

%shared_ptr(Bond)
class Bond : public Instrument {
    %rename(bondYield) yield;
  public:
    Bond(Natural settlementDays,
            const Calendar& calendar,
            Real faceAmount,
            const Date& maturityDate,
            const Date& issueDate = Date(),
            const Leg& cashflows = Leg());
    Bond(Natural settlementDays,
            const Calendar& calendar,
            const Date& issueDate = Date(),
            const Leg& coupons = Leg());
    // public functions
    Rate nextCouponRate(const Date& d = Date());
    Rate previousCouponRate(const Date& d = Date());
    // inspectors
    Natural settlementDays() const;
    Date settlementDate(Date d = Date());
    Date startDate() const;
    Date maturityDate() const;
    Date issueDate() const;
    std::vector<boost::shared_ptr<CashFlow> > cashflows() const;
    std::vector<boost::shared_ptr<CashFlow> > redemptions() const;
    boost::shared_ptr<CashFlow> redemption() const;
    Calendar calendar() const;
    std::vector<Real> notionals() const;
    Real notional(Date d = Date()) const;
    // calculations
    Real cleanPrice();
    Real cleanPrice(Rate yield,
                    const DayCounter &dc,
                    Compounding compounding,
                    Frequency frequency,
                    const Date& settlement = Date());
    Real dirtyPrice();
    Real dirtyPrice(Rate yield,
                    const DayCounter &dc,
                    Compounding compounding,
                    Frequency frequency,
                    const Date& settlement = Date());
    Real yield(const DayCounter& dc,
               Compounding compounding,
               Frequency freq,
               Real accuracy = 1.0e-8,
               Size maxEvaluations = 100);
    Real yield(Real cleanPrice,
               const DayCounter& dc,
               Compounding compounding,
               Frequency freq,
               const Date& settlement = Date(),
               Real accuracy = 1.0e-8,
               Size maxEvaluations = 100);
    Real accruedAmount(const Date& settlement = Date());
    Real settlementValue() const;
    Real settlementValue(Real cleanPrice) const;
};

%shared_ptr(FixedRateBond)
class FixedRateBond : public Bond {
  public:
    FixedRateBond(
            Integer settlementDays,
            Real faceAmount,
            const Schedule &schedule,
            const std::vector<Rate>& coupons,
            const DayCounter& paymentDayCounter,
            BusinessDayConvention paymentConvention = QuantLib::Following,
            Real redemption = 100.0,
            Date issueDate = Date(),
            const Calendar& paymentCalendar = Calendar(),
            const Period& exCouponPeriod = Period(),
            const Calendar& exCouponCalendar = Calendar(),
            BusinessDayConvention exCouponConvention = Unadjusted,
            bool exCouponEndOfMonth = false);
    //! generic compounding and frequency InterestRate coupons
    FixedRateBond(
          Integer settlementDays,
          Real faceAmount,
          const Schedule& schedule,
          const std::vector<InterestRate>& coupons,
          BusinessDayConvention paymentConvention = Following,
          Real redemption = 100.0,
          const Date& issueDate = Date(),
          const Calendar& paymentCalendar = Calendar(),
          const Period& exCouponPeriod = Period(),
          const Calendar& exCouponCalendar = Calendar(),
          BusinessDayConvention exCouponConvention = Unadjusted,
          bool exCouponEndOfMonth = false);
    //! simple annual compounding coupon rates with internal schedule calculation
    FixedRateBond(
          Integer settlementDays,
          const Calendar& couponCalendar,
          Real faceAmount,
          const Date& startDate,
          const Date& maturityDate,
          const Period& tenor,
          const std::vector<Rate>& coupons,
          const DayCounter& accrualDayCounter,
          BusinessDayConvention accrualConvention = QuantLib::Following,
          BusinessDayConvention paymentConvention = QuantLib::Following,
          Real redemption = 100.0,
          const Date& issueDate = Date(),
          const Date& stubDate = Date(),
          DateGeneration::Rule rule = QuantLib::DateGeneration::Backward,
          bool endOfMonth = false,
          const Calendar& paymentCalendar = Calendar(),
          const Period& exCouponPeriod = Period(),
          const Calendar& exCouponCalendar = Calendar(),
          const BusinessDayConvention exCouponConvention = Unadjusted,
          bool exCouponEndOfMonth = false);
    %extend {
        //! convenience wrapper around constructor taking rates
        static boost::shared_ptr<FixedRateBond> from_rates(
                              Integer settlementDays,
                              Real faceAmount,
                              const Schedule &schedule,
                              const std::vector<Rate>& coupons,
                              const DayCounter& paymentDayCounter,
                              BusinessDayConvention paymentConvention = QuantLib::Following,
                              Real redemption = 100.0,
                              Date issueDate = Date(),
                              const Calendar& paymentCalendar = Calendar(),
                              const Period& exCouponPeriod = Period(),
                              const Calendar& exCouponCalendar = Calendar(),
                              BusinessDayConvention exCouponConvention = Unadjusted,
                              bool exCouponEndOfMonth = false) {
            return boost::shared_ptr<FixedRateBond>(
                new FixedRateBond(settlementDays, faceAmount, schedule, coupons,
                                  paymentDayCounter, paymentConvention,
                                  redemption, issueDate, paymentCalendar,
                                  exCouponPeriod, exCouponCalendar,
                                  exCouponConvention, exCouponEndOfMonth));
        }
        //! convenience wrapper around constructor taking interest rates
        static boost::shared_ptr<FixedRateBond> from_interest_rates(
                              Integer settlementDays,
                              Real faceAmount,
                              const Schedule& schedule,
                              const std::vector<InterestRate>& coupons,
                              BusinessDayConvention paymentConvention = Following,
                              Real redemption = 100.0,
                              const Date& issueDate = Date(),
                              const Calendar& paymentCalendar = Calendar(),
                              const Period& exCouponPeriod = Period(),
                              const Calendar& exCouponCalendar = Calendar(),
                              BusinessDayConvention exCouponConvention = Unadjusted,
                              bool exCouponEndOfMonth = false) {
            return boost::shared_ptr<FixedRateBond>(
                new FixedRateBond(settlementDays, faceAmount, schedule, coupons,
                                  paymentConvention, redemption,
                                  issueDate, paymentCalendar,
                                  exCouponPeriod, exCouponCalendar,
                                  exCouponConvention, exCouponEndOfMonth));
        }
        //! convenience wrapper around constructor doing internal schedule calculation
        static boost::shared_ptr<FixedRateBond> from_date_info(
                              Integer settlementDays,
                              const Calendar& couponCalendar,
                              Real faceAmount,
                              const Date& startDate,
                              const Date& maturityDate,
                              const Period& tenor,
                              const std::vector<Rate>& coupons,
                              const DayCounter& accrualDayCounter,
                              BusinessDayConvention accrualConvention = QuantLib::Following,
                              BusinessDayConvention paymentConvention = QuantLib::Following,
                              Real redemption = 100.0,
                              const Date& issueDate = Date(),
                              const Date& stubDate = Date(),
                              DateGeneration::Rule rule = QuantLib::DateGeneration::Backward,
                              bool endOfMonth = false,
                              const Calendar& paymentCalendar = Calendar(),
                              const Period& exCouponPeriod = Period(),
                              const Calendar& exCouponCalendar = Calendar(),
                              const BusinessDayConvention exCouponConvention = Unadjusted,
                              bool exCouponEndOfMonth = false) {
            return boost::shared_ptr<FixedRateBond>(
                new FixedRateBond(settlementDays, couponCalendar, faceAmount,
                                  startDate, maturityDate, tenor,
                                  coupons, accrualDayCounter, accrualConvention,
                                  paymentConvention, redemption, issueDate,
                                  stubDate, rule, endOfMonth, paymentCalendar,
                                  exCouponPeriod, exCouponCalendar,
                                  exCouponConvention, exCouponEndOfMonth));
        }
    }
    Frequency frequency() const;
    DayCounter dayCounter() const;
};

#endif //quantlib_bonds_i
