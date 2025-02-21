import sys
import os
import itertools
import numpy as np
import enum

OUTPUT_FILE = 'set_buf_predef.hpp'
SET_BUFFER_DWORD_TYPE = 'set_static_array_dword'
SET_BUFFER_TYPE = 'set_buf'
DEVICE_MACRO = 'DEVICE'
N_LENGTHS = [4, 8, 16, 24, 32, 48, 64, 96, 128, 256]

class set_buf(object):
    def __init__(self, n, use_v_pk_mov):
        self.n = n
        self.use_v_pk_mov = use_v_pk_mov

    def __call__(self, fp):
        n = self.n
        use_dwordx2_flag = 'true' if self.use_v_pk_mov else 'false'
        fp.write(f'template <typename T> struct {SET_BUFFER_DWORD_TYPE}<T, {n}, false/*disable_inline_asm*/, {use_dwordx2_flag}> {{\n')
        fp.write(f'    template<index_t value = 0>\n')
        fp.write(f'    {DEVICE_MACRO} void operator()(static_buffer<T, {n}> & vec, number<value> = number<0>{{}}) {{\n')
        fp.write(f'        static_assert(sizeof(T) == {8 if self.use_v_pk_mov else 4});\n')
        fp.write(f'        asm volatile(\n')
        for i in range(n):
            if i % 4 == 0:
                fp.write(f'                ')
            if(self.use_v_pk_mov):
                fp.write(f'\"v_pk_mov_b32 %{i}, %{n}, %{n} op_sel:[0, 1]\\n\" ')
            else:
                fp.write(f'\"v_mov_b32 %{i}, %{n}\\n\" ')
            if (i + 1) % 4 == 0:
                fp.write(f'\n')
        fp.write(f'                :\n')
        for i in range(n):
            delim = ',' if i != n-1 else ''
            if i % 4 == 0:
                fp.write(f'                ')
            fp.write(f'\"=v\"(vec[number<{i}>{{}}]){delim} ')
            if (i + 1) % 4 == 0:
                fp.write(f'\n')
        fp.write(f'                : \"n\"(value) );\n')
        fp.write(f'    }}\n')
        fp.write(f'}};\n')

def gen(file_name):
    fp = None
    try:
        fp = open(file_name, "w")
    except IOError as e:
        print("can't open file:{}({})".format(file_name, e))
        sys.exit()
    fp.write(f'// generated by {sys.argv[0]}\n')
    fp.write(f'template <typename T/*sizeof(T)==4*/, index_t N, bool disable_inline_asm = false, bool use_dwordx2 = (sizeof(T) == 8)>\n')
    fp.write(f'struct {SET_BUFFER_DWORD_TYPE} {{\n')
    fp.write(f'    template<index_t value = 0>\n')
    fp.write(f'    {DEVICE_MACRO} void operator()(static_buffer<T, N> & vec, number<value> = number<0>{{}}) {{\n')
    fp.write(f'        constexpr_for<0, N, 1>{{}}([&](auto i){{\n')
    fp.write(f'            vec[i] = static_cast<T>(value);\n')
    fp.write(f'        }});\n')
    fp.write(f'    }}\n')
    fp.write(f'}};\n')
    fp.write(f'\n')
    fp.write(f'// clang-format off\n')
    for n in N_LENGTHS:
        for uv in [True, False]:
            set_buf(n, uv)(fp)
        fp.write(f'\n')
    fp.write(f'// clang-format on\n')
    fp.write(f'// generated by {sys.argv[0]}\n')
    fp.write(f'template <typename T, index_t N, bool disable_inline_asm = false, index_t SET_BY_DWORD = (sizeof(T) * N % 8 == 0 && sizeof(T) <= 8) ? 2 : ((sizeof(T) * N % 4 == 0 && sizeof(T) <= 4) ? 1 : 0)>\n')
    fp.write(f'struct {SET_BUFFER_TYPE};\n')
    fp.write(f'template <typename T, index_t N, bool disable_inline_asm>\n')
    fp.write(f'struct {SET_BUFFER_TYPE}<T, N, disable_inline_asm, 0> {{\n')
    fp.write(f'    template<index_t value = 0>\n')
    fp.write(f'    {DEVICE_MACRO} void operator()(vector_type<T, N> & vec, number<value> = number<0>{{}}) {{\n')
    fp.write(f'        constexpr_for<0, N, 1>{{}}([&](auto i){{\n')
    fp.write(f'            vec.template to_varray<T>()[i] = static_cast<T>(value);\n')
    fp.write(f'        }});\n')
    fp.write(f'    }}\n')
    fp.write(f'}};\n')
    fp.write(f'template <typename T, index_t N, bool disable_inline_asm>\n')
    fp.write(f'struct {SET_BUFFER_TYPE}<T, N, disable_inline_asm, 1> {{\n')
    fp.write(f'    template<index_t value = 0>\n')
    fp.write(f'    {DEVICE_MACRO} void operator()(vector_type<T, N> & vec, number<value> = number<0>{{}}) {{\n')
    fp.write(f'        using dword_t = typename vector_type<T, 4 / sizeof(T)>::type;\n')
    fp.write(f'        {SET_BUFFER_DWORD_TYPE}<dword_t, N * sizeof(T) / 4, disable_inline_asm>{{}}(vec.template to_varray<dword_t>(), number<value>{{}});\n')
    fp.write(f'    }}\n')
    fp.write(f'}};\n')
    fp.write(f'template <typename T, index_t N, bool disable_inline_asm>\n')
    fp.write(f'struct {SET_BUFFER_TYPE}<T, N, disable_inline_asm, 2> {{\n')
    fp.write(f'    template<index_t value = 0>\n')
    fp.write(f'    {DEVICE_MACRO} void operator()(vector_type<T, N> & vec, number<value> = number<0>{{}}) {{\n')
    fp.write(f'        using dword_t = typename vector_type<T, 8 / sizeof(T)>::type;\n')
    fp.write(f'        {SET_BUFFER_DWORD_TYPE}<dword_t, N * sizeof(T) / 8, disable_inline_asm>{{}}(vec.template to_varray<dword_t>(), number<value>{{}});\n')
    fp.write(f'    }}\n')
    fp.write(f'}};\n')
    fp.write(f'\n')

if __name__ == '__main__':
    output_file = OUTPUT_FILE
    if len(sys.argv) >= 2:
        output_file = sys.argv[1]
    gen(output_file)
