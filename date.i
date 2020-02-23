#ifndef quantlib_date_i
#define quantlib_date_i

%include common.i
%include types.i
%include stl.i

%define QL_TYPECHECK_PERIOD                      5220    %enddef

%{
using QuantLib::Day;
using QuantLib::Year;
%}

typedef Integer Day;
typedef Integer Year;

%{
using QuantLib::Weekday;
using QuantLib::Sunday;
using QuantLib::Monday;
using QuantLib::Tuesday;
using QuantLib::Wednesday;
using QuantLib::Thursday;
using QuantLib::Friday;
using QuantLib::Saturday;
%}

enum Weekday {
    Sunday    = 1,
    Monday    = 2,
    Tuesday   = 3,
    Wednesday = 4,
    Thursday  = 5,
    Friday    = 6,
    Saturday  = 7
};

%{
using QuantLib::Month;
using QuantLib::January;
using QuantLib::February;
using QuantLib::March;
using QuantLib::April;
using QuantLib::May;
using QuantLib::June;
using QuantLib::July;
using QuantLib::August;
using QuantLib::September;
using QuantLib::October;
using QuantLib::November;
using QuantLib::December;
%}

enum Month {
    January   = 1,
    February  = 2,
    March     = 3,
    April     = 4,
    May       = 5,
    June      = 6,
    July      = 7,
    August    = 8,
    September = 9,
    October   = 10,
    November  = 11,
    December  = 12
};

%{
using QuantLib::TimeUnit;
using QuantLib::Days;
using QuantLib::Weeks;
using QuantLib::Months;
using QuantLib::Years;
%}

enum TimeUnit { Days, Weeks, Months, Years};

%{
using QuantLib::Frequency;
using QuantLib::NoFrequency;
using QuantLib::Once;
using QuantLib::Annual;
using QuantLib::Semiannual;
using QuantLib::EveryFourthMonth;
using QuantLib::Quarterly;
using QuantLib::Bimonthly;
using QuantLib::Monthly;
using QuantLib::EveryFourthWeek;
using QuantLib::Biweekly;
using QuantLib::Weekly;
using QuantLib::Daily;
using QuantLib::OtherFrequency;
%}

enum Frequency {
    NoFrequency = -1,
    Once = 0,
    Annual = 1,
    Semiannual = 2,
    EveryFourthMonth = 3,
    Quarterly = 4,
    Bimonthly = 6,
    Monthly = 12,
    EveryFourthWeek = 13,
    Biweekly = 26,
    Weekly = 52,
    Daily = 365,
    OtherFrequency = 999
};

// time period

%{
using QuantLib::Period;
using QuantLib::PeriodParser;
%}

class Period {
  public:
    Period();
    Period(Integer n, TimeUnit units);
    explicit Period(Frequency);
    Integer length() const;
    TimeUnit units() const;
    Frequency frequency() const;
    %extend {
        Period(const std::string& str) {
            return new Period(PeriodParser::parse(str));
        }
        std::string __str__() {
            std::ostringstream out;
            out << *self;
            return out.str();
        }
        std::string __repr__() {
            std::ostringstream out;
            out << "Period(\"" << QuantLib::io::short_period(*self) << "\")";
            return out.str();
        }
        Period __neg__() {
            return -(*self);
        }
        Period __mul__(Integer n) {
            return *self*n;
        }
        Period __rmul__(Integer n) {
            return *self*n;
        }
        bool __lt__(const Period& other) {
            return *self < other;
        }
        bool __gt__(const Period& other) {
            return other < *self;
        }
        bool __le__(const Period& other) {
            return !(other < *self);
        }
        bool __ge__(const Period& other) {
            return !(*self < other);
        }
        bool __eq__(const Period& other) {
            return *self == other;
        }
        int __cmp__(const Period& other) {
            return *self < other  ? -1 :
                   *self == other ?  0 :
                                     1;
        }
    }
    %pythoncode %{
    def __hash__(self):
        return hash(str(self))
    %}
};

%typemap(in) boost::optional<Period> %{
    if($input == Py_None)
        $1 = boost::none;
    else
    {
        Period *temp;
        if (!SWIG_IsOK(SWIG_ConvertPtr($input,(void **) &temp, $descriptor(Period*),0)))
            SWIG_exception_fail(SWIG_TypeError, "in method '$symname', expecting type Period");
        $1 = (boost::optional<Period>) *temp;
    }
%}
%typecheck (QL_TYPECHECK_PERIOD) boost::optional<Period> {
    if($input == Py_None)
        $1 = 1;
    else {
        Period *temp;
        int res = SWIG_ConvertPtr($input,(void **) &temp, $descriptor(Period*),0);
        $1 = SWIG_IsOK(res) ? 1 : 0;
    }

}

namespace std {
    %template(PeriodVector) vector<Period>;
}

%{
using QuantLib::Date;
using QuantLib::DateParser;
%}

%pythoncode %{
import datetime as _datetime
%}

%{
    // used in Date(string, string) defined below
    void _replace_format(std::string& s, const std::string& old_format,
                         const std::string& new_format) {
        std::string::size_type i = s.find(old_format);
        if (i != std::string::npos)
            s.replace(i, old_format.length(), new_format);
    }
%}

class Date {
  public:
    Date();
    Date(Day d, Month m, Year y);
    Date(BigInteger serialNumber);
    // access functions
    Weekday weekday() const;
    Day dayOfMonth() const;
    Day dayOfYear() const;        // one-based
    Month month() const;
    Year year() const;
    BigInteger serialNumber() const;
    // static methods
    static bool isLeap(Year y);
    static Date minDate();
    static Date maxDate();
    static Date todaysDate();
    static Date endOfMonth(const Date&);
    static bool isEndOfMonth(const Date&);
    static Date nextWeekday(const Date&, Weekday);
    static Date nthWeekday(Size n, Weekday, Month m, Year y);
    Date operator+(BigInteger days) const;
    Date operator-(BigInteger days) const;
    Date operator+(const Period&) const;
    Date operator-(const Period&) const;

    %extend {
        Date(const std::string& str, std::string fmt) {
            // convert our old format into the corresponding Boost one
            _replace_format(fmt, "YYYY", "%Y");
            _replace_format(fmt, "yyyy", "%Y");
            _replace_format(fmt, "YY", "%y");
            _replace_format(fmt, "yy", "%y");
            _replace_format(fmt, "MM", "%m");
            _replace_format(fmt, "mm", "%m");
            _replace_format(fmt, "DD", "%d");
            _replace_format(fmt, "dd", "%d");
            return new Date(DateParser::parseFormatted(str,fmt));
        }
        Integer weekdayNumber() {
            return int(self->weekday());
        }
        std::string __str__() {
            std::ostringstream out;
            out << *self;
            return out.str();
        }
        std::string __repr__() {
            std::ostringstream out;
            if (*self == Date())
                out << "Date()";
            else
                out << "Date(" << self->dayOfMonth() << ","
                    << int(self->month()) << "," << self->year() << ")";
            return out.str();
        }
        std::string ISO() {
            std::ostringstream out;
            out << QuantLib::io::iso_date(*self);
            return out.str();
        }
        BigInteger operator-(const Date& other) {
            return *self - other;
        }
        bool __eq__(const Date& other) {
            return *self == other;
        }
        int __cmp__(const Date& other) {
            if (*self < other)
                return -1;
            else if (*self == other)
                return 0;
            else
                return 1;
        }
        bool __nonzero__() {
            return (*self != Date());
        }
        bool __bool__() {
            return (*self != Date());
        }
        int __hash__() {
            return self->serialNumber();
        }
        bool __lt__(const Date& other) {
            return *self < other;
        }
        bool __gt__(const Date& other) {
            return other < *self;
        }
        bool __le__(const Date& other) {
            return !(other < *self);
        }
        bool __ge__(const Date& other) {
            return !(*self < other);
        }
        bool __ne__(const Date& other) {
            return *self != other;
        }
    }

    %pythoncode %{
    def to_date(self):
        return _datetime.date(self.year(), self.month(), self.dayOfMonth())

    @staticmethod
    def from_date(date):
        return Date(date.day, date.month, date.year)
    %}
};

class DateParser {
  public:
    static Date parseFormatted(const std::string& str, const std::string& fmt);
    static Date parseISO(const std::string& str);
    %extend {
        static Date parse(const std::string& str, std::string fmt) {
            // convert our old format into the corresponding Boost one
            _replace_format(fmt, "YYYY", "%Y");
            _replace_format(fmt, "yyyy", "%Y");
            _replace_format(fmt, "YY", "%y");
            _replace_format(fmt, "yy", "%y");
            _replace_format(fmt, "MM", "%m");
            _replace_format(fmt, "mm", "%m");
            _replace_format(fmt, "DD", "%d");
            _replace_format(fmt, "dd", "%d");
            return DateParser::parseFormatted(str,fmt);
        }
    }
};

class PeriodParser {
  public:
    static Period parse(const std::string& str);
};

%pythoncode %{
Date._old___add__ = Date.__add__
Date._old___sub__ = Date.__sub__
def Date_new___add__(self,x):
    if type(x) is tuple and len(x) == 2:
        return self._old___add__(Period(x[0],x[1]))
    else:
        return self._old___add__(x)
def Date_new___sub__(self,x):
    if type(x) is tuple and len(x) == 2:
        return self._old___sub__(Period(x[0],x[1]))
    else:
        return self._old___sub__(x)
Date.__add__ = Date_new___add__
Date.__sub__ = Date_new___sub__
%}

namespace std {
    %template(DateVector) vector<Date>;
}

Time daysBetween(const Date&, const Date&);

%{
using QuantLib::IMM;
%}

struct IMM {
    enum Month { F =  1, G =  2, H =  3,
                 J =  4, K =  5, M =  6,
                 N =  7, Q =  8, U =  9,
                 V = 10, X = 11, Z = 12 };

    static bool isIMMdate(const Date& d,
                          bool mainCycle = true);
    static bool isIMMcode(const std::string& code,
                          bool mainCycle = true);
    static std::string code(const Date& immDate);
    static Date date(const std::string& immCode,
                     const Date& referenceDate = Date());
    static Date nextDate(const Date& d = Date(),
                         bool mainCycle = true);
    static Date nextDate(const std::string& immCode,
                         bool mainCycle = true,
                         const Date& referenceDate = Date());
    static std::string nextCode(const Date& d = Date(),
                                bool mainCycle = true);
    static std::string nextCode(const std::string& immCode,
                                bool mainCycle = true,
                                const Date& referenceDate = Date());
};

%{
using QuantLib::ASX;
%}

struct ASX {
    enum Month { F =  1, G =  2, H =  3,
                 J =  4, K =  5, M =  6,
                 N =  7, Q =  8, U =  9,
                 V = 10, X = 11, Z = 12 };

    static bool isASXdate(const Date& d,
                          bool mainCycle = true);
    static bool isASXcode(const std::string& code,
                          bool mainCycle = true);
    static std::string code(const Date& asxDate);
    static Date date(const std::string& asxCode,
                     const Date& referenceDate = Date());
    static Date nextDate(const Date& d = Date(),
                         bool mainCycle = true);
    static Date nextDate(const std::string& asxCode,
                         bool mainCycle = true,
                         const Date& referenceDate = Date());
    static std::string nextCode(const Date& d = Date(),
                                bool mainCycle = true);
    static std::string nextCode(const std::string& asxCode,
                                bool mainCycle = true,
                                const Date& referenceDate = Date());
};

#endif //quantlib_date_i
