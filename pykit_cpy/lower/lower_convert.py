# -*- coding: utf-8 -*-

"""
Lower all conversions between native values <-> objects to calls to a
runtime.conversion module set in the environment.
"""

from __future__ import print_function, division, absolute_import
from pykit import types
from pykit.ir import transform, GlobalValue, Module, Builder

def build_conversion_table(convertable=types.scalar_set):
    """Returns { (from_type, to_type) -> funcname }"""
    table = {}
    for type in convertable:
        typename = types.typename(type).lower()
        table[(type, types.Object)] = "object_from_%s" % typename
        table[(types.Object, type)] = "%s_from_object" % typename
    return table

def conversion_runtime(convertable=types.scalar_set):
    """Returns a Module with declared external runtime conversion functions"""
    table = build_conversion_table(convertable)
    mod = Module()
    for (from_type, to_type), funcname in table.iteritems():
        signature = types.Function(to_type, [from_type])
        gv = GlobalValue(funcname, signature, external=True, address=0)
        mod.add_global(gv)
    return mod

class LowerConversions(object):

    def __init__(self, func, conversion_table):
        self.conversion_table = conversion_table
        self.builder = Builder(func)

    def op_convert(self, op):
        arg = op.args[0]
        if (op.type, arg.type) in self.conversion_table:
            funcname = self.conversion_table[op.type, arg.type]
            return self.builder.gen_call_external(funcname, [arg])


def run(func, env):
    if not env.get("runtime.conversion"):
        env["runtime.conversion"] = conversion_runtime()
        func.module.link(env["runtime.conversion"])
    transform(LowerConversions(func, build_conversion_table()), func)