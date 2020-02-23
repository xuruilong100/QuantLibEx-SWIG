#ifndef quantlib_observer_i
#define quantlib_observer_i

%include common.i
%include boost_shared_ptr.i

%{
using QuantLib::Observer;
using QuantLib::Observable;
%}

%shared_ptr(Observable);
class Observable {};

%extend Handle {
    boost::shared_ptr<Observable> asObservable() {
        return boost::shared_ptr<Observable>(*self);
    }
}

%{
// C++ wrapper for Python observer
class PyObserver : public Observer {
  public:
    PyObserver(PyObject* callback)
    : callback_(callback) {
        /* make sure the Python object stays alive
           as long as we need it */
        Py_XINCREF(callback_);
    }
    PyObserver(const PyObserver& o)
    : callback_(o.callback_) {
        /* make sure the Python object stays alive
           as long as we need it */
        Py_XINCREF(callback_);
    }
    PyObserver& operator=(const PyObserver& o) {
        if ((this != &o) && (callback_ != o.callback_)) {
            Py_XDECREF(callback_);
            callback_ = o.callback_;
            Py_XINCREF(callback_);
        }
        return *this;
    }
    ~PyObserver() {
        // now it can go as far as we are concerned
        Py_XDECREF(callback_);
    }
    void update() {
        PyObject* pyResult = PyObject_CallFunction(callback_,NULL);
        QL_ENSURE(pyResult != NULL, "failed to notify Python observer");
        Py_XDECREF(pyResult);
    }
  private:
    PyObject* callback_;
};
%}

// Python wrapper
%rename(Observer) PyObserver;
class PyObserver {
    %rename(_registerWith)   registerWith;
    %rename(_unregisterWith) unregisterWith;
  public:
    PyObserver(PyObject* callback);
    void registerWith(const boost::shared_ptr<Observable>&);
    void unregisterWith(const boost::shared_ptr<Observable>&);
    %pythoncode %{
        def registerWith(self,x):
            if hasattr(x, "asObservable"):
                self._registerWith(x.asObservable())
            else:
                self._registerWith(x)
        def unregisterWith(self,x):
            if hasattr(x, "asObservable"):
                self._unregisterWith(x.asObservable())
            else:
                self._unregisterWith(x)
    %}
};

#endif //quantlib_observer_i
