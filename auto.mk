# ======================================
# SOURCE_GROUPS: groups of sources defined
# x_DIR: source file prefix path
# x_SRCS: source file in this group
# x_CFLAGS: specific CFLAGS (default to CFLAGS)
# x_LDFLAGS: specific LDFLAGS (default to LDFLAGS)
# x_BUILD: directory to put generated object files and dependency files
#
# EXECUTABLES: executable defined
# x_BINPATH: directory to put generated executable
# x_GROUPS: source group that would be linked to this executable
# x_BIN: the generated executable name
#
#
# default build dir
BUILD ?= build
# default source dir
SRCDIR ?= .
# default binary path
BINPATH ?= .

CC ?= gcc
__BUILD_DIR_SEEN :=

# for each group in SOURCE_GROUPS, generate recipes to generate dependency
# and to generate object file
define GROUP_TEMPLATE =

$(1)_CFLAGS ?= $$(CFLAGS)
$(1)_LDFLAGS ?= $$(LDFLAGS)

$(1)_DIR ?= $$(SRC_DIR)
$(1)_BUILD ?= $$(BUILD)

$(1)_OBJS=$$($(1)_SRCS:%.c=$$($(1)_BUILD)/%_$(1).o)
$(1)_DEPS=$$($(1)_SRCS:%.c=$$($(1)_BUILD)/%_$(1).d)


ifneq ($$(($1)_DIR),.)
$$($(1)_BUILD)/%_$(1).o : $$($(1)_DIR)/%.c $$($(1)_BUILD)/%_$(1).d | $$($(1)_BUILD)
	$$(CC) $$($(1)_CFLAGS) -c $$< -o $$@ -MMD
else
$$($(1)_BUILD)/%_$(1).o : %.c $$($(1)_BUILD)/%_$(1).d | $$($(1)_BUILD)
	$$(CC) $$($(1)_CFLAGS) -c $$< -o $$@ -MMD
endif


ifeq ($$(filter $$($(1)_BUILD), $$(__BUILD_DIR_SEEN)),)
__BUILD_DIR_SEEN += $$($(1)_BUILD)
$$($(1)_BUILD):
	@echo "Creating build dir: $$@"
	@mkdir -p $$@
endif
$$($(1)_DEPS): ;
-include $$($(1)_DEPS)
endef



# for each item in EXECUTABLES , first do auto dependency as in source group
# the add a recipe to generate corresponding binary
define EXE_TEMPLATE =
$$(eval $$(call GROUP_TEMPLATE,$(1)))
$(1)_BINPATH ?= $$(BINPATH)
$(1)_BIN ?= $(1)

ifneq ($$($(1)_BINPATH),.)

$$($(1)_BINPATH)/$$($(1)_BIN): $$($(1)_OBJS) $$(foreach grp,$$($(1)_GROUPS),$$($$(grp)_OBJS)) | $$($(1)_BINPATH)
	$$(CC) $$($(1)_CFLAGS) $$^ -o $$@

ifeq ($$(filter $$($(1)_BINPATH), $$(__BUILD_DIR_SEEN)),)
__BUILD_DIR_SEEN += $$($(1)_BINPATH)
$$($(1)_BINPATH):
	@echo "Creating binary dir: $$@"
	@mkdir -p $$@
endif

else
$$($(1)_BIN): $$($(1)_OBJS) $$(foreach grp,$$($(1)_GROUPS),$$($$(grp)_OBJS))
	$$(CC) $$($(1)_CFLAGS) $$^ -o $$@

endif

endef

$(foreach grp, $(SOURCE_GROUPS), $(eval $(call GROUP_TEMPLATE,$(grp))))
$(foreach exe, $(EXECUTABLES), $(eval $(call EXE_TEMPLATE,$(exe))))
