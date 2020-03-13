"""
setup.py file for QuantLibEx
"""

from distutils.core import setup, Extension

qlx_module = Extension(
    name='QuantLibEx._QuantLibEx',
    sources=[
        'QuantLibEx/qlx_wrap.cpp',
        '../QuantLibExSrc/AdjustedSvenssonFitting.cpp',
        '../QuantLibExSrc/BjorkChristensenFitting.cpp',
        '../QuantLibExSrc/BlissFitting.cpp',
        '../QuantLibExSrc/DieboldLiFitting.cpp'],
    include_dirs=['/usr/include/', '../QuantLibExSrc/'],
    library_dirs=['/usr/lib/'],
    libraries=['QuantLib'],
    extra_compile_args=['-fopenmp', '-Wno-unused'],
    extra_link_args=['-fopenmp'])

setup(
    name='QuantLibEx',
    version='1.15-ex',
    author="xrl",
    author_email="xuruilong100@hotmail.com",
    description="Python bindings for the QuantLibEx library",
    ext_modules=[qlx_module],
    py_modules=['QuantLibEx.__init__', 'QuantLibEx.QuantLibEx'],
    url="https://github.com/xuruilong100",
    license="follows QuantLib's license")
