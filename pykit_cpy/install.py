# -*- coding: utf-8 -*-

"""
Install cpykit passes in a pykit environment. The passes generate code for
the CPython C API.
"""

from __future__ import print_function, division, absolute_import
from os.path import join, abspath, dirname

root = abspath(dirname(__file__))

def install_in_env(env):
    env["runtime.librarypaths"].append(root)
    env["runtime.libraries"].extend(["python", "conversion"])