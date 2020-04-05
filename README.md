# makefile template

my toy makefile template

- `SOURCE_GROUPS`: 源文件group
- `x_DIR`: 源文件前缀路径(默认为`SRC_DIR`(默认为`.`))
- `x_SRCS`: 源文件
- `x_CFLAGS`: cflags (默认为`CFLAGS`)
- `x_LDFLAGS`: ldflags (默认为`LDFLAGS`)
- `x_BUILD`: 生成的依赖文件和object文件的位置

- `EXECUTABLES`: 可执行文件
- `x_BINPATH`: 生成可执行文件路径(默认为BINPATH(默认为bin))
- `x_GROUPS`: 生成可执行文件的时候, 加入的源文件group(默认是所有的)
- `x_BIN`: 生成的可执行文件名称(默认为在EXECUTABLES中的名称)

问题:
- [ ] 指定的源文件只能是basename..
- ...
