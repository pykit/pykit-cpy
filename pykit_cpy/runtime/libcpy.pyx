# -*- coding: utf-8 -*-

"""
Implements a runtime using CPython.
"""

from __future__ import print_function, division, absolute_import

from cpython cimport *

import functools
try:
    import __builtin__ as builtin
except ImportError:
    import builtin

# ______________________________________________________________________
# Iterators

cdef public getiter(obj):
    return iter(obj)

cdef public next(obj):
    return next(obj)

# ______________________________________________________________________
# Attributes

cdef public getfield(obj, str attr):
    return getattr(obj, attr)

cdef public void setfield(obj, str attr, value):
    setattr(obj, attr, value)

# ______________________________________________________________________
# Indexing

cdef public getindex(obj, indices):
    return obj[indices]

cdef public void setindex(obj, indices, value):
    obj[indices] = value

cdef public getslice(obj, indices):
    return obj[indices]

cdef public void setslice(obj, indices, value):
    obj[indices] = value

cdef public slice slice(Py_ssize_t lower, Py_ssize_t upper, Py_ssize_t step):
    return builtins.slice(lower, upper, step)

# ______________________________________________________________________
# Basic operators

# Binary

cdef public add(x, y):
    return x + y

cdef public sub(x, y):
    return x - y

cdef public mul(x, y):
    return x * y

cdef public div(x, y):
    return x / y

cdef public floordiv(x, y):
    return x // y

cdef public lshift(x, y):
    return x << y

cdef public rshift(x, y):
    return x >> y

cdef public bitor(x, y):
    return x | y

cdef public bitand(x, y):
    return x & y

# Unary

cdef public uadd(x):
    return +x

cdef public invert(x):
    return ~x

cdef public not_(x):
    return not x

cdef public usub(x):
    return -x

# Compare

cdef public lt(x, y):
    return x < y

cdef public lte(x, y):
    return x <= y

cdef public gt(x, y):
    return x > y

cdef public gte(x, y):
    return x >= y

cdef public eq(x, y):
    return x == y

cdef public noteq(x, y):
    return x != y

# ______________________________________________________________________
# Constructors

cdef public new_list(elems):
    return list(elems)

cdef public new_tuple(elems):
    return tuple(elems)

cdef public new_dict(keys, values):
    return dict(zip(keys, values))

cdef public new_set(elems):
    return set(elems)

cdef public new_string(elems):
    return bytes(elems)

cdef public new_unicode(elems):
    return unicode(elems)

cdef public new_complex(double real, double imag):
    return complex(real, imag)

# ______________________________________________________________________
# Containers

cdef public concat(a, b):
    return a + b

cdef public Py_ssize_t length(elems):
    return bytes(elems)

cdef public bint contains(a, b):
    return a in b

cdef public void list_append(list L, object item):
    L.append(item)

cdef public void list_pop(list L):
    L.pop()

cdef public void set_add(set s, object item):
    s.add(item)

cdef public void set_remove(set s, object item):
    s.remove(item)

cdef public void dict_add(dict d, key, value):
    d[key] = value

cdef public void dict_remove(dict d, object item):
    del d[item]

cdef public dict_keys(dict d):
    return d.keys()

cdef public dict_values(dict d):
    return d.values()

cdef public dict_items(dict d):
    return d.items()

# ______________________________________________________________________
# Functions

cdef public call(obj, args):
    return obj(*args)

cdef public partial(func, values):
    return functools.partial(func, values)

# ______________________________________________________________________
# Closures

uninitialized = object()

cdef class Cell(object):
    cdef object value

    def __init__(self, value):
        self.value = value

cdef public make_cell():
    return Cell(uninitialized)

cdef public load_cell(Cell cell): # NOTE: object return
    if cell.value is uninitialized:
        raise NameError
    return cell.value

cdef public store_cell(Cell cell, value): # NOTE: object arg
    cell.value = value

# ______________________________________________________________________
# Primitives

cdef public print_(values):
    values = list(values)
    for value in values[:-1]:
        print(value,)
    print(values[-1])

# __________________________________________________________________
# Exceptions

cdef public bint exc_matches(exc, matcher):
    return PyErr_GivenExceptionMatches(exc, matcher)

cdef public void exc_clear():
    PyErr_Clear()

cdef public exc_throw(exc, *args):
    raise exc