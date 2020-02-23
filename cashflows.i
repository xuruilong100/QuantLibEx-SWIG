#ifndef quantlib_cash_flows_i
#define quantlib_cash_flows_i

%include date.i
%include types.i
%include calendars.i
%include daycounters.i
%include termstructures.i
%include scheduler.i
%include vectors.i

%{
using QuantLib::CashFlow;
%}

%shared_ptr(CashFlow)
class CashFlow : public Observable {
  private:
    CashFlow();
  public:
    Real amount() const;
    Date date() const;
};

%template(Leg) std::vector<boost::shared_ptr<CashFlow> >;
typedef std::vector<boost::shared_ptr<CashFlow> > Leg;

%{
using QuantLib::Coupon;
using QuantLib::FixedRateCoupon;
using QuantLib::Leg;
%}

%shared_ptr(Coupon)
class Coupon : public CashFlow {
  private:
    Coupon();
  public:
    Real nominal() const;
    Date accrualStartDate() const;
    Date accrualEndDate() const;
    Date referencePeriodStart() const;
    Date referencePeriodEnd() const;
    Date exCouponDate() const;
    Real rate() const;
    Time accrualPeriod() const;
    BigInteger accrualDays() const;
    DayCounter dayCounter() const;
    Real accruedAmount(const Date& date) const;
};

%inline %{
    boost::shared_ptr<Coupon> as_coupon(const boost::shared_ptr<CashFlow>& cf) {
        return boost::dynamic_pointer_cast<Coupon>(cf);
    }
%}

%shared_ptr(FixedRateCoupon)
class FixedRateCoupon : public Coupon {
  public:
    FixedRateCoupon(const Date& paymentDate, Real nominal,
                    Rate rate, const DayCounter& dayCounter,
                    const Date& startDate, const Date& endDate,
                    const Date& refPeriodStart = Date(),
                    const Date& refPeriodEnd = Date(),
                    const Date& exCouponDate = Date());
    InterestRate interestRate() const;
};

%inline %{
    boost::shared_ptr<FixedRateCoupon> as_fixed_rate_coupon(
                                      const boost::shared_ptr<CashFlow>& cf) {
        return boost::dynamic_pointer_cast<FixedRateCoupon>(cf);
    }
%}

// cash flow vector builders

%{
Leg _FixedRateLeg(const Schedule& schedule,
                  const DayCounter& dayCount,
                  const std::vector<Real>& nominals,
                  const std::vector<Rate>& couponRates,
                  BusinessDayConvention paymentAdjustment = Following,
                  const DayCounter& firstPeriodDayCount = DayCounter(),
                  const Period& exCouponPeriod = Period(),
                  const Calendar& exCouponCalendar = Calendar(),
                  BusinessDayConvention exCouponConvention = Unadjusted,
                  bool exCouponEndOfMonth = false) {
    return QuantLib::FixedRateLeg(schedule)
        .withNotionals(nominals)
        .withCouponRates(couponRates,dayCount)
        .withPaymentAdjustment(paymentAdjustment)
        .withFirstPeriodDayCounter(firstPeriodDayCount)
        .withExCouponPeriod(exCouponPeriod,
                            exCouponCalendar,
                            exCouponConvention,
                            exCouponEndOfMonth);
}
%}

%rename(FixedRateLeg) _FixedRateLeg;
Leg _FixedRateLeg(const Schedule& schedule,
                  const DayCounter& dayCount,
                  const std::vector<Real>& nominals,
                  const std::vector<Rate>& couponRates,
                  BusinessDayConvention paymentAdjustment = Following,
                  const DayCounter& firstPeriodDayCount = DayCounter(),
                  const Period& exCouponPeriod = Period(),
                  const Calendar& exCouponCalendar = Calendar(),
                  BusinessDayConvention exCouponConvention = Unadjusted,
                  bool exCouponEndOfMonth = false);

// cash-flow analysis

%{
using QuantLib::CashFlows;
using QuantLib::Duration;
%}

struct Duration {
    enum Type { Simple, Macaulay, Modified };
};

class CashFlows {
    %rename("yieldRate")   yield;
  private:
    CashFlows();
    CashFlows(const CashFlows&);
  public:
    static Date startDate(const Leg &);
    static Date maturityDate(const Leg &);
    static Date
        previousCashFlowDate(const Leg& leg,
                             bool includeSettlementDateFlows,
                             Date settlementDate = Date());
    static Date
        nextCashFlowDate(const Leg& leg,
                         bool includeSettlementDateFlows,
                         Date settlementDate = Date());

    %extend {
        static Real npv(
                   const Leg& leg,
                   const boost::shared_ptr<YieldTermStructure>& discountCurve,
                   Spread zSpread,
                   const DayCounter &dayCounter,
                   Compounding compounding,
                   Frequency frequency,
                   bool includeSettlementDateFlows,
                   const Date& settlementDate = Date(),
                   const Date& npvDate = Date()) {
            return QuantLib::CashFlows::npv(leg, discountCurve,
                                            zSpread,
                                            dayCounter,
                                            compounding,
                                            frequency,
                                            includeSettlementDateFlows,
                                            settlementDate,
                                            npvDate);
        }
        static Real npv(
                   const Leg& leg,
                   const Handle<YieldTermStructure>& discountCurve,
                   bool includeSettlementDateFlows,
                   const Date& settlementDate = Date(),
                   const Date& npvDate = Date()) {
            return QuantLib::CashFlows::npv(leg, **discountCurve,
                                            includeSettlementDateFlows,
                                            settlementDate, npvDate);
        }
    }
    static Real npv(const Leg&,
                    const InterestRate&,
                    bool includeSettlementDateFlows,
                    Date settlementDate = Date(),
                    Date npvDate = Date());

    static Real npv(const Leg&,
                    Rate yield,
                    const DayCounter&dayCounter,
                    Compounding compounding,
                    Frequency frequency,
                    bool includeSettlementDateFlows,
                    Date settlementDate = Date(),
                    Date npvDate = Date());
    %extend {
        static Real bps(
                   const Leg& leg,
                   const boost::shared_ptr<YieldTermStructure>& discountCurve,
                   bool includeSettlementDateFlows,
                   const Date& settlementDate = Date(),
                   const Date& npvDate = Date()) {
            return QuantLib::CashFlows::bps(leg, *discountCurve,
                                            includeSettlementDateFlows,
                                            settlementDate, npvDate);
        }
        static Real bps(
                   const Leg& leg,
                   const Handle<YieldTermStructure>& discountCurve,
                   bool includeSettlementDateFlows,
                   const Date& settlementDate = Date(),
                   const Date& npvDate = Date()) {
            return QuantLib::CashFlows::bps(leg, **discountCurve,
                                            includeSettlementDateFlows,
                                            settlementDate, npvDate);
        }
    }
    static Real bps(const Leg&,
                    const InterestRate &,
                    bool includeSettlementDateFlows,
                    Date settlementDate = Date(),
                    Date npvDate = Date());
    static Real bps(const Leg&,
                    Rate yield,
                    const DayCounter&dayCounter,
                    Compounding compounding,
                    Frequency frequency,
                    bool includeSettlementDateFlows,
                    Date settlementDate = Date(),
                    Date npvDate = Date());

    %extend {
        static Rate atmRate(
                   const Leg& leg,
                   const boost::shared_ptr<YieldTermStructure>& discountCurve,
                   bool includeSettlementDateFlows,
                   const Date& settlementDate = Date(),
                   const Date& npvDate = Date(),
                   Real npv = Null<Real>()) {
            return QuantLib::CashFlows::atmRate(leg, *discountCurve,
                                                includeSettlementDateFlows,
                                                settlementDate, npvDate,
                                                npv);
        }
    }
    static Rate yield(const Leg&,
                      Real npv,
                      const DayCounter& dayCounter,
                      Compounding compounding,
                      Frequency frequency,
                      bool includeSettlementDateFlows,
                      Date settlementDate = Date(),
                      Date npvDate = Date(),
                      Real accuracy = 1.0e-10,
                      Size maxIterations = 10000,
                      Rate guess = 0.05);
    static Time duration(const Leg&,
                         const InterestRate&,
                         Duration::Type type,
                         bool includeSettlementDateFlows,
                         Date settlementDate = Date());

    static Time duration(const Leg&,
             Rate yield,
             const DayCounter& dayCounter,
             Compounding compounding,
             Frequency frequency,
             Duration::Type type,
             bool includeSettlementDateFlows,
             Date settlementDate = Date(),
             Date npvDate = Date());

    static Real convexity(const Leg&,
                          const InterestRate&,
                          bool includeSettlementDateFlows,
                          Date settlementDate = Date(),
                          Date npvDate = Date());

    static Real convexity(const Leg&,
             Rate yield,
             const DayCounter& dayCounter,
             Compounding compounding,
             Frequency frequency,
             bool includeSettlementDateFlows,
             Date settlementDate = Date(),
             Date npvDate = Date());

    static Real basisPointValue(const Leg& leg,
             const InterestRate& yield,
             bool includeSettlementDateFlows,
             Date settlementDate = Date(),
             Date npvDate = Date());

    static Real basisPointValue(const Leg& leg,
             Rate yield,
             const DayCounter& dayCounter,
             Compounding compounding,
             Frequency frequency,
             bool includeSettlementDateFlows,
             Date settlementDate = Date(),
             Date npvDate = Date());

    static Spread zSpread(const Leg& leg,
             Real npv,
             const boost::shared_ptr<YieldTermStructure>&,
             const DayCounter& dayCounter,
             Compounding compounding,
             Frequency frequency,
             bool includeSettlementDateFlows,
             Date settlementDate = Date(),
             Date npvDate = Date(),
             Real accuracy = 1.0e-10,
             Size maxIterations = 100,
             Rate guess = 0.0);

};

#endif //quantlib_cash_flows_i
