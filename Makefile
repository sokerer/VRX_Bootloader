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
        		   vrugimbalv11_bl \
        		   vrgimbalv20_bl \
        		   vrflightstopv10_bl \
        		   vrsparkv11_bl vrsparkv21_bl \
        		   vrthermalv10_bl vrthermalv20_bl vrthermalv30_bl vrthermalv31_bl vrthermalv32_bl \
        		   vrcorev10_bl \
        		   vrmapperv10_bl



all:	$(TARGETS)

BUILDPATH = bootloader/

clean:
	rm -f $(BUILDPATH)*.elf $(BUILDPATH)*.bin $(BUILDPATH)*.hex $(BUILDPATH)*.dfu

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
	make -f Makefile_VRX.f4 TARGET=brainv40 INTERFACE=USB BOARD=VRBRAINV40 USBDEVICESTRING="\\\"VR BL BRAIN v4.0\\\"" USBPRODUCTID="0x1140"

vrbrainv45_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=brainv45 INTERFACE=USB BOARD=VRBRAINV45 USBDEVICESTRING="\\\"VR BL BRAIN v4.5\\\"" USBPRODUCTID="0x1145"

vrbrainv50_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=brainv50 INTERFACE=USB BOARD=VRBRAINV50 USBDEVICESTRING="\\\"VR BL BRAIN v5.0\\\"" USBPRODUCTID="0x1150"

vrbrainv51_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=brainv51 INTERFACE=USB BOARD=VRBRAINV51 USBDEVICESTRING="\\\"VR BL BRAIN v5.1\\\"" USBPRODUCTID="0x1151"

vrbrainv52_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=brainv52 INTERFACE=USB BOARD=VRBRAINV52 USBDEVICESTRING="\\\"VR BL BRAIN v5.2\\\"" USBPRODUCTID="0x1152"

vrubrainv51_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=ubrainv51 INTERFACE=USB BOARD=VRUBRAINV51 USBDEVICESTRING="\\\"VR BL MICRO BRAIN v5.1\\\"" USBPRODUCTID="0x1351"

vrubrainv52_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=ubrainv52 INTERFACE=USB BOARD=VRUBRAINV52 USBDEVICESTRING="\\\"VR BL MICRO BRAIN v5.2\\\"" USBPRODUCTID="0x1352"

vrherov10_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=herov10 INTERFACE=USB BOARD=VRHEROV10 USBDEVICESTRING="\\\"VR BL HERO v1.0\\\"" USBPRODUCTID="0x1210"

vrugimbalv11_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=ugimbalv11 INTERFACE=USB BOARD=VRUGIMBALV11 USBDEVICESTRING="\\\"VR BL MICRO GIMBAL v1.1\\\"" USBPRODUCTID="0x1411"

vrgimbalv20_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=gimbalv20 INTERFACE=USB BOARD=VRGIMBALV20 USBDEVICESTRING="\\\"VR BL GIMBAL v2.0\\\"" USBPRODUCTID="0x1520"

vrflightstopv10_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=flightstopv10 INTERFACE=USB BOARD=VRFLIGHTSTOPV10 USBDEVICESTRING="\\\"VR BL FLIGHT STOP v1.0\\\"" USBPRODUCTID="0x1610"

vrsparkv11_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=sparkv11 INTERFACE=USB BOARD=VRSPARKV11 USBDEVICESTRING="\\\"VR BL SPARK v1.1\\\"" USBPRODUCTID="0x1711"

vrsparkv21_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=sparkv21 INTERFACE=USB BOARD=VRSPARKV21 USBDEVICESTRING="\\\"VR BL SPARK v2.1\\\"" USBPRODUCTID="0x1721"

vrthermalv10_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=thermalv10 INTERFACE=USB BOARD=VRTHERMALV10 USBDEVICESTRING="\\\"VR BL THERMAL v1.0\\\"" USBPRODUCTID="0x1810"

vrthermalv20_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=thermalv20 INTERFACE=USB BOARD=VRTHERMALV20 USBDEVICESTRING="\\\"VR BL THERMAL v2.0\\\"" USBPRODUCTID="0x1820"

vrthermalv30_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=thermalv30 INTERFACE=USB BOARD=VRTHERMALV30 USBDEVICESTRING="\\\"VR BL THERMAL v3.0\\\"" USBPRODUCTID="0x1830"

vrthermalv31_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=thermalv31 INTERFACE=USB BOARD=VRTHERMALV31 USBDEVICESTRING="\\\"VR BL THERMAL v3.1\\\"" USBPRODUCTID="0x1831"

vrthermalv32_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=thermalv32 INTERFACE=USB BOARD=VRTHERMALV32 USBDEVICESTRING="\\\"VR BL THERMAL v3.2\\\"" USBPRODUCTID="0x1832"

vrcorev10_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=corev10 INTERFACE=USB BOARD=VRCOREV10 USBDEVICESTRING="\\\"VR BL BRAIN CORE v1.0\\\"" USBPRODUCTID="0x1910"

vrmapperv10_bl: $(MAKEFILE_LIST)
	make -f Makefile_VRX.f4 TARGET=mapperv10 INTERFACE=USB BOARD=VRMAPPERV10 USBDEVICESTRING="\\\"VR BL MAPPER v1.0\\\"" USBPRODUCTID="0x2010"
