#ifndef quantlib_settings_i
#define quantlib_settings_i

%include date.i

%{
using QuantLib::Settings;
%}

class Settings {
  private:
    Settings();
  public:
    static Settings& instance();
    %extend {
        Date getEvaluationDate() {
            return self->evaluationDate();
        }
        void setEvaluationDate(const Date& d) {
            self->evaluationDate() = d;
        }
        void includeReferenceDateEvents(bool b) {
            self->includeReferenceDateEvents() = b;
        }
        void includeTodaysCashFlows(bool b) {
            self->includeTodaysCashFlows() = b;
        }
    }

    %pythoncode %{
    evaluationDate = property(getEvaluationDate,setEvaluationDate,None)
    includeReferenceDateCashFlows = property(None,includeReferenceDateEvents,None)
    includeReferenceDateEvents = property(None,includeReferenceDateEvents,None)
    includeTodaysCashFlows = property(None,includeTodaysCashFlows,None)
    %}
};

#endif //quantlib_settings_i
