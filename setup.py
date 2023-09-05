#!/usr/bin/env python

"""
setup.py file for SWIG example
"""

from distutils.core import setup, Extension


fastestrplidar_module = Extension(
    "_fastestrplidar",

    sources=[
        "fastestrplidar_wrap.cxx",
        "fastestrplidar.cpp",
        "src/rplidar_driver.cpp",
        #"src/rplidar_driver.cpp",
    ],
    #swig_opts=["-c++"],
    extra_objects=["librplidar_sdk.a"],
    extra_compile_args=["-lpthread", "-lstdc++", "-Wno-write-strings", "-Wno-narrowing", "-Wno-undef"],
    
)

setup(
    name="fastestrplidar",
    version="0.1",
    author="Ayo Ayibiowu",
    description="""An Advanced but easy to use Fast Rplidar Library""",
    ext_modules=[fastestrplidar_module],
    py_modules=["fastestrplidar"],
)
