#ifndef quantlib_market_elements_i
#define quantlib_market_elements_i

%include common.i
%include observer.i
%include functions.i

%{
using QuantLib::Quote;
%}

%shared_ptr(Quote)
class Quote : public Observable {
  private:
    Quote();
  public:
    Real value() const;
    bool isValid() const;
};

%template(QuoteHandle) Handle<Quote>;
%template(RelinkableQuoteHandle) RelinkableHandle<Quote>;

// actual quotes
%{
using QuantLib::SimpleQuote;
%}

%shared_ptr(SimpleQuote)
class SimpleQuote : public Quote {
  public:
    SimpleQuote(Real value);
    void setValue(Real value);
};

%{
typedef QuantLib::DerivedQuote<UnaryFunction> DerivedQuote;
typedef QuantLib::CompositeQuote<BinaryFunction> CompositeQuote;
%}

%shared_ptr(DerivedQuote)
class DerivedQuote : public Quote {
  public:
    %extend {
        DerivedQuote(const Handle<Quote>& h,
                     PyObject* function) {
            return new DerivedQuote(h,UnaryFunction(function));
        }
    }
};

%shared_ptr(CompositeQuote)
class CompositeQuote : public Quote {
  public:
    %extend {
        CompositeQuote(const Handle<Quote>& h1,
                       const Handle<Quote>& h2,
                       PyObject* function) {
            return new CompositeQuote(h1,h2,BinaryFunction(function));
        }
    }
};

namespace std {
    %template(QuoteVector) vector<boost::shared_ptr<Quote> >;
    %template(QuoteVectorVector) vector<vector<boost::shared_ptr<Quote> > >;
    %template(QuoteHandleVector) vector<Handle<Quote> >;
    %template(QuoteHandleVectorVector) vector<vector<Handle<Quote> > >;
    %template(RelinkableQuoteHandleVector) vector<RelinkableHandle<Quote> >;
    %template(RelinkableQuoteHandleVectorVector)
                                  vector<vector<RelinkableHandle<Quote> > >;
}

#endif //quantlib_market_elements_i
