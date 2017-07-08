obj-m += virtual_fb.o
EXTRA_CFLAGS += -I$(TARGET_DIR)/usr/include

CCFLAGSY += -D__TDT__ -D__LINUX__ -D__SH4__ -D__KERNEL__ -DMODULE -DEXPORT_SYMTAB

ifneq (,$(findstring 2.6.3,$(KERNELVERSION)))
ccflags-y += $(CCFLAGSY)
else
CFLAGS += $(CCFLAGSY)
endif

all:
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh CROSS_COMPILE=$(TARGET)- M=$(shell pwd) modules

install: all
	$(MAKE) -C $(KERNEL_DIR) ARCH=sh CROSS_COMPILE=$(TARGET)- M=$(shell pwd) INSTALL_MOD_PATH=$(TARGET_DIR) modules_install

distclean:
	rm *.o *.ko modules.order Module.symvers

