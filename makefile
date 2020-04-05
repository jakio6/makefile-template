CFLAGS = -Iinclude

SRCDIR =src
BUILD = build
BINPATH = .

SOURCE_GROUPS = srcs
srcs_DIR=src
srcs_SRCS=hello.c bye.c

EXECUTABLES = hello bye

hello_DIR=test
hello_SRCS=test.c
hello_GROUPS=srcs

bye_DIR=bye
bye_SRCS=bye.c
bye_GROUPS=srcs
bye_BINPATH=bin
bye_BIN=byebye

include auto.mk
