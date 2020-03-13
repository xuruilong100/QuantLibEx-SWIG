#ifndef quantlib_fitted_bond_i
#define quantlib_fitted_bond_i

%include stl.i
%include types.i
%include common.i
%include termstructures.i
%include linearalgebra.i
%include optimizers.i
%include ratehelpers.i

%{
using QuantLib::FittedBondDiscountCurve;

typedef boost::shared_ptr<YieldTermStructure> FittedBondDiscountCurvePtr;
typedef QuantLib::FittedBondDiscountCurve::FittingMethod FittingMethod;

std::vector<boost::shared_ptr<BondHelper> > convert_bond_helpers(
                 const std::vector<boost::shared_ptr<RateHelper> >& helpers) {
    std::vector<boost::shared_ptr<BondHelper> > result(helpers.size());
    for (Size i=0; i<helpers.size(); ++i)
        result[i] = boost::dynamic_pointer_cast<BondHelper>(helpers[i]);
    return result;
}

using QuantLib::Calendar;
using QuantLib::DayCounter;
using QuantLib::Date;
%}

class FittingMethod {
  public:
    virtual ~FittingMethod() = 0;
    Size size() const;
    Array solution() const;
    Integer numberOfIterations() const;
    Real minimumCostValue() const;
    bool constrainAtZero() const;
    Array weights() const;
    Array l2 () const;
    boost::shared_ptr<OptimizationMethod> optimizationMethod () const;
};

%shared_ptr(FittedBondDiscountCurve);
class FittedBondDiscountCurve : public YieldTermStructure {
  public:
    FittedBondDiscountCurve(
                   Natural settlementDays,
                   const Calendar& calendar,
                   const std::vector<boost::shared_ptr<BondHelper> >& helpers,
                   const DayCounter& dayCounter,
                   const FittingMethod& fittingMethod,
                   Real accuracy = 1.0e-10,
                   Size maxEvaluations = 10000,
                   const Array& guess = Array(),
                   Real simplexLambda = 1.0);
    FittedBondDiscountCurve(
                   const Date &referenceDate,
                   const std::vector<boost::shared_ptr<BondHelper> >& helpers,
                   const DayCounter& dayCounter,
                   const FittingMethod& fittingMethod,
                   Real accuracy = 1.0e-10,
                   Size maxEvaluations = 10000,
                   const Array &guess = Array(),
                   Real simplexLambda = 1.0);
    const FittingMethod& fitResults() const;
};

%{
using QuantLib::ExponentialSplinesFitting;
using QuantLib::NelsonSiegelFitting;
using QuantLib::SvenssonFitting;
using QuantLib::CubicBSplinesFitting;
using QuantLib::SimplePolynomialFitting;
%}

class ExponentialSplinesFitting : public FittingMethod {
  public:
    ExponentialSplinesFitting(bool constrainAtZero = true,
                              const Array& weights = Array(),
                              boost::shared_ptr<OptimizationMethod> optimizationMethod = boost::shared_ptr<OptimizationMethod>(),
                              const Array &l2 = Array());
};

class NelsonSiegelFitting : public FittingMethod {
  public:
    NelsonSiegelFitting(const Array& weights = Array(),
    boost::shared_ptr<OptimizationMethod> optimizationMethod = boost::shared_ptr<OptimizationMethod>(),
    const Array &l2 = Array());
};

class SvenssonFitting : public FittingMethod {
  public:
    SvenssonFitting(const Array& weights = Array(),
    boost::shared_ptr<OptimizationMethod> optimizationMethod = boost::shared_ptr<OptimizationMethod>(),
    const Array &l2 = Array());
};

class CubicBSplinesFitting : public FittingMethod {
  public:
    CubicBSplinesFitting(const std::vector<Time>& knotVector,
                         bool constrainAtZero = true,
                         const Array& weights = Array(),
                         boost::shared_ptr<OptimizationMethod> optimizationMethod = boost::shared_ptr<OptimizationMethod>(),
                         const Array &l2 = Array());
    Real basisFunction(Integer i, Time t);
};

class SimplePolynomialFitting : public FittingMethod {
  public:
    SimplePolynomialFitting(Natural degree,
                            bool constrainAtZero = true,
                            const Array& weights = Array(),
                            boost::shared_ptr<OptimizationMethod> optimizationMethod = boost::shared_ptr<OptimizationMethod>(),
                            const Array &l2 = Array());
};

%{
#include <AdjustedSvenssonFitting.hpp>
#include <BjorkChristensenFitting.hpp>
#include <BlissFitting.hpp>
#include <DieboldLiFitting.hpp>

using QuantLib::AdjustedSvenssonFitting;
using QuantLib::BjorkChristensenFitting;
using QuantLib::BlissFitting;
using QuantLib::DieboldLiFitting;
%}

class AdjustedSvenssonFitting : public FittingMethod {
  public:
    AdjustedSvenssonFitting(const Array& weights = Array(),
                            boost::shared_ptr<OptimizationMethod> optimizationMethod = boost::shared_ptr<OptimizationMethod>(),
                            const Array &l2 = Array());
};

class BjorkChristensenFitting : public FittingMethod {
  public:
    BjorkChristensenFitting(const Array& weights = Array(),
                            boost::shared_ptr<OptimizationMethod> optimizationMethod = boost::shared_ptr<OptimizationMethod>(),
                            const Array &l2 = Array());
};

class BlissFitting : public FittingMethod {
  public:
    BlissFitting(const Array& weights = Array(),
                 boost::shared_ptr<OptimizationMethod> optimizationMethod = boost::shared_ptr<OptimizationMethod>(),
                 const Array &l2 = Array());
};

class DieboldLiFitting : public FittingMethod {
  public:
  DieboldLiFitting(Real kappa,
                   const Array& weights = Array(),
                   boost::shared_ptr<OptimizationMethod> optimizationMethod = boost::shared_ptr<OptimizationMethod>(),
                   const Array& l2 = Array());
  DieboldLiFitting(Real kappa,
                   const Array& weights,
                   const Array& l2);
};

#endif //quantlib_fitted_bond_i
