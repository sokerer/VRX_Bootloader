#
# Common Makefile for the PX4 and VRX bootloaders
#

#
# Paths to common dependencies
#
export BL_BASE		?= $(wildcard .)
export LIBOPENCM3	?= $(wildcard libopencm3)

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
TARGETS			 = px4fmu_bl px4fmuv2_bl px4flow_bl stm32f4discovery_bl px4io_bl aerocore_bl \
        		   vrbrainv40_bl vrbrainv45_bl vrbrainv50_bl vrbrainv51_bl vrbrainv52_bl \
        		   vrubrainv51_bl vrubrainv52_bl \
        		   vrherov10_bl \
        		   vrugimbalv11_bl vrgimbalv20_bl



all:	$(TARGETS)

clean:
	rm -f *.elf *.bin *.hex *.dfu

#
# Specific bootloader targets.
#
# Pick a Makefile from Makefile.f1, Makefile.f4
# Pick an interface supported by the Makefile (USB, UART, I2C)
# Specify the board type.
#

#PX4 boards
px4fmu_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=fmu INTERFACE=USB BOARD=FMU USBDEVICESTRING="\\\"PX4 BL FMU v1.x\\\"" USBPRODUCTID="0x0010"

px4fmuv2_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=fmuv2 INTERFACE=USB BOARD=FMUV2 USBDEVICESTRING="\\\"PX4 BL FMU v2.x\\\"" USBPRODUCTID="0x0011"

stm32f4discovery_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=discovery INTERFACE=USB BOARD=DISCOVERY USBDEVICESTRING="\\\"PX4 BL DISCOVERY\\\"" USBPRODUCTID="0x0001"

px4flow_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=flow INTERFACE=USB BOARD=FLOW USBDEVICESTRING="\\\"PX4 FLOW v1.3\\\"" USBPRODUCTID="0x0015"

aerocore_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=aerocore INTERFACE=USB BOARD=AEROCORE USBDEVICESTRING="\\\"Gumstix BL AEROCORE\\\"" USBPRODUCTID="0x1001"

# Default bootloader delay is *very* short, just long enough to catch
# the board for recovery but not so long as to make restarting after a 
# brownout problematic.
#
px4io_bl: $(MAKEFILE_LIST)
	make -f Makefile.f1 TARGET=io INTERFACE=USART BOARD=IO PX4_BOOTLOADER_DELAY=200

#VRX boards
vrbrainv40_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=brainv40 INTERFACE=USB BOARD=BRAINV40 USBDEVICESTRING="\\\"VR BL BRAIN v4.0\\\"" USBPRODUCTID="0x1140"

vrbrainv45_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=brainv45 INTERFACE=USB BOARD=BRAINV45 USBDEVICESTRING="\\\"VR BL BRAIN v4.5\\\"" USBPRODUCTID="0x1145"

vrbrainv50_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=brainv50 INTERFACE=USB BOARD=BRAINV50 USBDEVICESTRING="\\\"VR BL BRAIN v5.0\\\"" USBPRODUCTID="0x1150"

vrbrainv51_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=brainv51 INTERFACE=USB BOARD=BRAINV51 USBDEVICESTRING="\\\"VR BL BRAIN v5.1\\\"" USBPRODUCTID="0x1151"

vrbrainv52_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=brainv52 INTERFACE=USB BOARD=BRAINV52 USBDEVICESTRING="\\\"VR BL BRAIN v5.2\\\"" USBPRODUCTID="0x1152"

vrubrainv51_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=ubrainv51 INTERFACE=USB BOARD=UBRAINV51 USBDEVICESTRING="\\\"VR BL MICRO BRAIN v5.1\\\"" USBPRODUCTID="0x1351"

vrubrainv52_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=ubrainv52 INTERFACE=USB BOARD=UBRAINV52 USBDEVICESTRING="\\\"VR BL MICRO BRAIN v5.2\\\"" USBPRODUCTID="0x1352"

vrherov10_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=herov10 INTERFACE=USB BOARD=HEROV10 USBDEVICESTRING="\\\"VR BL HERO v1.0\\\"" USBPRODUCTID="0x1210"

vrugimbalv11_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=ugimbalv11 INTERFACE=USB BOARD=UGIMBALV11 USBDEVICESTRING="\\\"VR BL MICRO GIMBAL v1.1\\\"" USBPRODUCTID="0x1411"

vrgimbalv20_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=gimbalv20 INTERFACE=USB BOARD=GIMBALV20 USBDEVICESTRING="\\\"VR BL GIMBAL v2.0\\\"" USBPRODUCTID="0x1520"
	