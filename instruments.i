#ifndef quantlib_instruments_i
#define quantlib_instruments_i

%include common.i
%include types.i
%include marketelements.i
%include observer.i
%include stl.i

// pricing engine

%{
using QuantLib::PricingEngine;
%}

%shared_ptr(PricingEngine)
class PricingEngine : public Observable {
  private:
    PricingEngine();
};

// instrument

%{
using QuantLib::Instrument;
%}

%shared_ptr(Instrument)
class Instrument : public Observable {
  public:
    Real NPV() const;
    Real errorEstimate() const;
    bool isExpired() const;
    void setPricingEngine(const boost::shared_ptr<PricingEngine>&);
    void recalculate();
    void freeze();
    void unfreeze();
  private:
    Instrument();
};

namespace std {
    %template(InstrumentVector) vector<boost::shared_ptr<Instrument> >;
}

// actual instruments

%{
using QuantLib::Stock;
%}

%shared_ptr(Stock)
class Stock : public Instrument {
  public:
    Stock(const Handle<Quote>& quote);
};

%{
using QuantLib::CompositeInstrument;
%}

%shared_ptr(CompositeInstrument)
class CompositeInstrument : public Instrument {
  public:
    CompositeInstrument();
    void add(const boost::shared_ptr<Instrument>& instrument,
             Real multiplier = 1.0);
    void subtract(const boost::shared_ptr<Instrument>& instrument,
                  Real multiplier = 1.0);
};

#endif //quantlib_instruments_i
