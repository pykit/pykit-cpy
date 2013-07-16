# -*- coding: utf-8 -*-

"""
Conversions through the CPython C API.
"""

from libc.stdint cimport int16_t, int32_t, int64_t, uint16_t, uint32_t, uint64_t

#===------------------------------------------------------------------===
# Integral
#===------------------------------------------------------------------===

cdef public int16_t int16_from_object(obj) except? -1:
    return obj

cdef public int32_t int32_from_object(obj) except? -1:
    return obj

cdef public int64_t int64_from_object(obj) except? -1:
    return obj

cdef public uint16_t uint16_from_object(obj) except? 0x7FFF:
    return obj

cdef public uint32_t uint32_from_object(obj) except? 0x7FFF:
    return obj

cdef public uint64_t uint64_from_object(obj) except? 0x7FFF:
    return obj

# Unsigned

cdef public object_from_int16(int16_t i):
    return i

cdef public object_from_int32(int32_t i):
    return i

cdef public object_from_int64(int64_t i):
    return i

cdef public object_from_uint16(uint16_t i):
    return i

cdef public object_from_uint32(uint32_t i):
    return i

cdef public object_from_uint64(uint64_t i):
    return i

#===------------------------------------------------------------------===
# Floating
#===------------------------------------------------------------------===

cdef public float float32_from_object(obj) except? 0x7FFF:
    return obj

cdef public double float64_from_object(obj) except? 0x7FFF:
    return obj

cdef public object_from_float32(float f):
    return f

cdef public object_from_float64(double f):
    return f

#===------------------------------------------------------------------===
# Complex
#===------------------------------------------------------------------===

cdef public float complex complex64_from_object(obj) except? 0x7FFF:
    return obj

cdef public double complex complex128_from_object(obj) except? 0x7FFF:
    return obj

cdef public object_from_complex64(float complex c):
    return c

cdef public object_from_complex128(double complex c):
    return c
