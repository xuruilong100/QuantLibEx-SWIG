#ifndef quantlib_optimizers_i
#define quantlib_optimizers_i

%include functions.i
%include linearalgebra.i
%include stl.i
%include types.i
%include common.i

%{
using QuantLib::OptimizationMethod;
using QuantLib::ConjugateGradient;
using QuantLib::Simplex;
using QuantLib::SteepestDescent;
using QuantLib::BFGS;
using QuantLib::LevenbergMarquardt;
using QuantLib::DifferentialEvolution;
using QuantLib::SamplerGaussian;
using QuantLib::SamplerLogNormal;
using QuantLib::SamplerMirrorGaussian;
using QuantLib::ProbabilityBoltzmannDownhill;
using QuantLib::TemperatureExponential;
using QuantLib::ReannealingTrivial;
using QuantLib::GaussianSimulatedAnnealing;
using QuantLib::MirrorGaussianSimulatedAnnealing;
using QuantLib::LogNormalSimulatedAnnealing;
%}

%shared_ptr(OptimizationMethod)
class OptimizationMethod {
  private:
    // prevent direct instantiation
    OptimizationMethod();
};

%shared_ptr(ConjugateGradient)
class ConjugateGradient : public OptimizationMethod {
  public:
    ConjugateGradient();
};

%shared_ptr(Simplex)
class Simplex : public OptimizationMethod {
  public:
    Simplex(Real lambda);
};

%shared_ptr(SteepestDescent)
class SteepestDescent : public OptimizationMethod {
  public:
    SteepestDescent();
};

%shared_ptr(BFGS)
class BFGS : public OptimizationMethod {
  public:
    BFGS();
};

%shared_ptr(LevenbergMarquardt)
class LevenbergMarquardt : public OptimizationMethod {
  public:
    LevenbergMarquardt(Real epsfcn = 1.0e-8,
                       Real xtol = 1.0e-8,
                       Real gtol = 1.0e-8,
                       bool useCostFunctionsJacobian = false);
};

%shared_ptr(DifferentialEvolution)
class DifferentialEvolution : public OptimizationMethod {
  public:
    DifferentialEvolution();
};

class SamplerGaussian{
  public:
    SamplerGaussian(unsigned long seed = 0);
};

class SamplerLogNormal{
  public:
    SamplerLogNormal(unsigned long seed = 0);
};

class SamplerMirrorGaussian{
  public:
    SamplerMirrorGaussian(const Array& lower, const Array& upper, unsigned long seed = 0);
};

class ProbabilityBoltzmannDownhill{
  public:
    ProbabilityBoltzmannDownhill(unsigned long seed = 0);
};

class TemperatureExponential {
  public:
    TemperatureExponential(Real initialTemp, Size dimension, Real power = 0.95);
};

class ReannealingTrivial {
  public:
    ReannealingTrivial();
};

%shared_ptr(GaussianSimulatedAnnealing)
class GaussianSimulatedAnnealing : public OptimizationMethod {
  public:
    enum ResetScheme{
        NoResetScheme,
        ResetToBestPoint,
        ResetToOrigin
    };
    GaussianSimulatedAnnealing(const SamplerGaussian &sampler,
            const ProbabilityBoltzmannDownhill &probability,
            const TemperatureExponential &temperature,
            const ReannealingTrivial &reannealing = ReannealingTrivial(),
            Real startTemperature = 200.0,
            Real endTemperature = 0.01,
            Size reAnnealSteps = 50,
            ResetScheme resetScheme = ResetToBestPoint,
            Size resetSteps = 150);
};

%shared_ptr(MirrorGaussianSimulatedAnnealing)
class MirrorGaussianSimulatedAnnealing : public OptimizationMethod {
  public:
    enum ResetScheme{
        NoResetScheme,
        ResetToBestPoint,
        ResetToOrigin
    };
    MirrorGaussianSimulatedAnnealing(const SamplerMirrorGaussian &sampler,
            const ProbabilityBoltzmannDownhill &probability,
            const TemperatureExponential &temperature,
            const ReannealingTrivial &reannealing = ReannealingTrivial(),
            Real startTemperature = 200.0,
            Real endTemperature = 0.01,
            Size reAnnealSteps = 50,
            ResetScheme resetScheme = ResetToBestPoint,
            Size resetSteps = 150);
};

%shared_ptr(LogNormalSimulatedAnnealing)
class LogNormalSimulatedAnnealing : public OptimizationMethod {
  public:
   enum ResetScheme{
        NoResetScheme,
        ResetToBestPoint,
        ResetToOrigin
    };
    LogNormalSimulatedAnnealing(const SamplerLogNormal &sampler,
            const ProbabilityBoltzmannDownhill &probability,
            const TemperatureExponential &temperature,
            const ReannealingTrivial &reannealing = ReannealingTrivial(),
            Real startTemperature = 10.0,
            Real endTemperature = 0.01,
            Size reAnnealSteps = 50,
            ResetScheme resetScheme = ResetToBestPoint,
            Size resetSteps = 150);
};

#endif //quantlib_optimizers_i
