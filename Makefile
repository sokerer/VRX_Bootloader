#
# Common Makefile for the VRBRAIN bootloaders
#

#
# Paths to common dependencies
#
export LIBOPENCM3	?= $(wildcard ../libopencm3)
ifeq ($(LIBOPENCM3),)
$(error Cannot locate libopencm3 - set LIBOPENCM3 to the root of a built version and try again)
endif

#
# Tools
#
export CC	 	 = arm-none-eabi-gcc
export OBJCOPY		 = arm-none-eabi-objcopy

#
# Common configuration
#
export FLAGS		 = -std=gnu99 \
			   -Os \
			   -g \
			   -Wall \
			   -fno-builtin \
			   -I$(LIBOPENCM3)/include \
			   -ffunction-sections \
			   -nostartfiles \
			   -lnosys \
	   		   -Wl,-gc-sections

export COMMON_SRCS	 = bl.c

#
# Bootloaders to build
#
TARGETS			 = vrbrainv40_bl vrbrainv45_bl vrbrainv50_bl vrbrainv51_bl vrubrainv51_bl vrherov10_bl

all:	$(TARGETS)

clean:
	rm -f *.elf *.bin

#
# Specific bootloader targets.
#
# Pick a Makefile from Makefile.f1, Makefile.f4
# Pick an interface supported by the Makefile (USB, UART, I2C)
# Specify the board type.
#

vrbrainv40_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=brainv40 INTERFACE=USB BOARD=BRAINV40 USBDEVICESTRING="\\\"VR BL BRAIN v4.0\\\"" USBPRODUCTID="0x1140"

vrbrainv45_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=brainv45 INTERFACE=USB BOARD=BRAINV45 USBDEVICESTRING="\\\"VR BL BRAIN v4.5\\\"" USBPRODUCTID="0x1145"

vrbrainv50_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=brainv50 INTERFACE=USB BOARD=BRAINV50 USBDEVICESTRING="\\\"VR BL BRAIN v5.0\\\"" USBPRODUCTID="0x1150"

vrbrainv51_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=brainv51 INTERFACE=USB BOARD=BRAINV51 USBDEVICESTRING="\\\"VR BL BRAIN v5.1\\\"" USBPRODUCTID="0x1151"

vrubrainv51_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=ubrainv51 INTERFACE=USB BOARD=UBRAINV51 USBDEVICESTRING="\\\"VR BL MICRO BRAIN v5.1\\\"" USBPRODUCTID="0x1351"

vrherov10_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=herov10 INTERFACE=USB BOARD=HEROV10 USBDEVICESTRING="\\\"VR BL HERO v1.0\\\"" USBPRODUCTID="0x1210"
