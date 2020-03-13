"""
This file is just a copy of __init__.py of
QuantLib-Python, but changes a little of codes.
"""

import sys

if sys.version_info.major >= 3:
    from .QuantLibEx import *
    from .QuantLibEx import _QuantLibEx
else:
    from QuantLibEx import *
    from QuantLibEx import _QuantLibEx
del sys

__author__ = 'xrl'
__email__ = 'xuruilong100@hotmail.com'

if hasattr(_QuantLibEx, '__version__'):
    __version__ = _QuantLibEx.__version__
elif hasattr(_QuantLibEx.cvar, '__version__'):
    __version__ = _QuantLibEx.cvar.__version__
else:
    print('Could not find __version__ attribute')

if hasattr(_QuantLibEx, '__hexversion__'):
    __hexversion__ = _QuantLibEx.__hexversion__
elif hasattr(_QuantLibEx.cvar, '__hexversion__'):
    __hexversion__ = _QuantLibEx.cvar.__hexversion__
else:
    print('Could not find __hexversion__ attribute')

__license__ = "Follow QuantLib's license"
