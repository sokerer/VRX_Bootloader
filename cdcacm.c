/*
 * This file is part of the libopencm3 project.
 *
 * Copyright (C) 2010 Gareth McMullin <gareth@blacksphere.co.nz>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdlib.h>
#include <libopencm3/stm32/f4/rcc.h>
#include <libopencm3/stm32/f4/gpio.h>
#include <libopencm3/stm32/f4/flash.h>
#include <libopencm3/stm32/nvic.h>
#include <libopencm3/usb/usbd.h>
#include <libopencm3/usb/cdc.h>

#include "bl.h"

static const char *usb_strings[] = {
	"",
#if defined(BOARD_VRBRAINV40)
	"Laser Navigation",
#elif defined(BOARD_VRBRAINV45)
	"Laser Navigation",
#elif defined(BOARD_VRBRAINV50)
	"Laser Navigation",
#elif defined(BOARD_VRBRAINV51)
	"Laser Navigation",
#elif defined(BOARD_VRBRAINV52)
	"Laser Navigation",
#elif defined(BOARD_VRBRAINV53)
	"Laser Navigation",
#elif defined(BOARD_VRUBRAINV51)
	"Laser Navigation",
#elif defined(BOARD_VRUBRAINV52)
	"Laser Navigation",
#elif defined(BOARD_VRHEROV10)
	"Laser Navigation",
#elif defined(BOARD_VRUGIMBALV11)
	"Laser Navigation",
#elif defined(BOARD_VRGIMBALV20)
	"Laser Navigation",
#elif defined(BOARD_VRFLIGHTSTOPV10)
	"Laser Navigation",
#elif defined(BOARD_VRSPARKV11)
	"Laser Navigation",
#elif defined(BOARD_VRSPARKV21)
	"Laser Navigation",
#elif defined(BOARD_VRTHERMALV10)
	"Laser Navigation",
#elif defined(BOARD_VRTHERMALV20)
	"Laser Navigation",
#elif defined(BOARD_VRTHERMALV30)
	"Laser Navigation",
#elif defined(BOARD_VRTHERMALV31)
	"Laser Navigation",
#elif defined(BOARD_VRTHERMALV32)
	"Laser Navigation",
#elif defined(BOARD_VRCOREV10)
	"Laser Navigation",
#elif defined(BOARD_VRMAPPERV10)
	"Laser Navigation",
#else
	"3D Robotics",
#endif
	USBDEVICESTRING,
	"0",
};

static const struct usb_device_descriptor dev = {
	.bLength = USB_DT_DEVICE_SIZE,
	.bDescriptorType = USB_DT_DEVICE,	/**< Specifies he descriptor type */
	.bcdUSB = 0x0200,					/**< The USB interface version, binary coded (2.0) */
	.bDeviceClass = USB_CLASS_CDC,		/**< USB device class, CDC in this case */
	.bDeviceSubClass = 0,
	.bDeviceProtocol = 0,
	.bMaxPacketSize0 = 64,
#if defined(BOARD_VRBRAINV40)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRBRAINV45)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRBRAINV50)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRBRAINV51)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRBRAINV52)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRBRAINV53)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRUBRAINV51)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRUBRAINV52)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRHEROV10)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRUGIMBALV11)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRGIMBALV20)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRFLIGHTSTOPV10)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRSPARKV11)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRSPARKV21)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRTHERMALV10)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRTHERMALV20)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRTHERMALV30)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRTHERMALV31)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRTHERMALV32)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRCOREV10)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#elif defined(BOARD_VRMAPPERV10)
	.idVendor = 0x27AC,					/**< Vendor ID (VID) */
#else
	.idVendor = 0x26AC,					/**< Vendor ID (VID) */
#endif
	.idProduct = USBPRODUCTID,			/**< Product ID (PID) */
	.bcdDevice = 0x0101,				/**< Product version. Set to 1.01 (0x0101) to agree with NuttX */
	.iManufacturer = 1,					/**< Use string with index 1 for the manufacturer string ("3D Robotics") */
	.iProduct = 2,						/**< Use string with index 2 for the product string (USBDEVICESTRING define) */
	.iSerialNumber = 3,					/**< Use string with index 3 for the serial number string (empty) */
	.bNumConfigurations = 1,			/**< Number of configurations (one) */
};

/*
 * This notification endpoint isn't implemented. According to CDC spec it's
 * optional, but its absence causes a NULL pointer dereference in the
 * Linux cdc_acm driver.
 */
static const struct usb_endpoint_descriptor comm_endp[] = {{
	.bLength = USB_DT_ENDPOINT_SIZE,
	.bDescriptorType = USB_DT_ENDPOINT,
	.bEndpointAddress = 0x83,
	.bmAttributes = USB_ENDPOINT_ATTR_INTERRUPT,
	.wMaxPacketSize = 16,
	.bInterval = 255,
}};

static const struct usb_endpoint_descriptor data_endp[] = {{
	.bLength = USB_DT_ENDPOINT_SIZE,
	.bDescriptorType = USB_DT_ENDPOINT,
	.bEndpointAddress = 0x01,
	.bmAttributes = USB_ENDPOINT_ATTR_BULK,
	.wMaxPacketSize = 64,
	.bInterval = 1,
}, {
	.bLength = USB_DT_ENDPOINT_SIZE,
	.bDescriptorType = USB_DT_ENDPOINT,
	.bEndpointAddress = 0x82,
	.bmAttributes = USB_ENDPOINT_ATTR_BULK,
	.wMaxPacketSize = 64,
	.bInterval = 1,
}};

static const struct {
	struct usb_cdc_header_descriptor header;
	struct usb_cdc_call_management_descriptor call_mgmt;
	struct usb_cdc_acm_descriptor acm;
	struct usb_cdc_union_descriptor cdc_union;
} __attribute__((packed)) cdcacm_functional_descriptors = {
	.header = {
		.bFunctionLength = sizeof(struct usb_cdc_header_descriptor),
		.bDescriptorType = CS_INTERFACE,
		.bDescriptorSubtype = USB_CDC_TYPE_HEADER,
		.bcdCDC = 0x0110,
	},
	.call_mgmt = {
		.bFunctionLength =
			sizeof(struct usb_cdc_call_management_descriptor),
		.bDescriptorType = CS_INTERFACE,
		.bDescriptorSubtype = USB_CDC_TYPE_CALL_MANAGEMENT,
		.bmCapabilities = 0,
		.bDataInterface = 1,
	},
	.acm = {
		.bFunctionLength = sizeof(struct usb_cdc_acm_descriptor),
		.bDescriptorType = CS_INTERFACE,
		.bDescriptorSubtype = USB_CDC_TYPE_ACM,
		.bmCapabilities = 0,
	},
	.cdc_union = {
		.bFunctionLength = sizeof(struct usb_cdc_union_descriptor),
		.bDescriptorType = CS_INTERFACE,
		.bDescriptorSubtype = USB_CDC_TYPE_UNION,
		.bControlInterface = 0,
		.bSubordinateInterface0 = 1,
	 }
};

static const struct usb_interface_descriptor comm_iface[] = {{
	.bLength = USB_DT_INTERFACE_SIZE,
	.bDescriptorType = USB_DT_INTERFACE,
	.bInterfaceNumber = 0,
	.bAlternateSetting = 0,
	.bNumEndpoints = 1,
	.bInterfaceClass = USB_CLASS_CDC,
	.bInterfaceSubClass = USB_CDC_SUBCLASS_ACM,
	.bInterfaceProtocol = USB_CDC_PROTOCOL_AT,
	.iInterface = 0,

	.endpoint = comm_endp,

	.extra = &cdcacm_functional_descriptors,
	.extralen = sizeof(cdcacm_functional_descriptors)
}};

static const struct usb_interface_descriptor data_iface[] = {{
	.bLength = USB_DT_INTERFACE_SIZE,
	.bDescriptorType = USB_DT_INTERFACE,
	.bInterfaceNumber = 1,
	.bAlternateSetting = 0,
	.bNumEndpoints = 2,
	.bInterfaceClass = USB_CLASS_DATA,
	.bInterfaceSubClass = 0,
	.bInterfaceProtocol = 0,
	.iInterface = 0,

	.endpoint = data_endp,
}};

static const struct usb_interface ifaces[] = {{
	.num_altsetting = 1,
	.altsetting = comm_iface,
}, {
	.num_altsetting = 1,
	.altsetting = data_iface,
}};

static const struct usb_config_descriptor config = {
	.bLength = USB_DT_CONFIGURATION_SIZE,
	.bDescriptorType = USB_DT_CONFIGURATION,
	.wTotalLength = 0,
	.bNumInterfaces = 2,
	.bConfigurationValue = 1,
	.iConfiguration = 0,
	.bmAttributes = 0x80,
	.bMaxPower = 0xFA, /* Request 500 mA power (0xFA=250, get doubled in protocol) */

	.interface = ifaces,
};

static int cdcacm_control_request(struct usb_setup_data *req, u8 **buf,
		u16 *len, void (**complete)(struct usb_setup_data *req))
{
	(void)complete;
	(void)buf;

	switch (req->bRequest) {
	case USB_CDC_REQ_SET_CONTROL_LINE_STATE: {
		/*
		 * This Linux cdc_acm driver requires this to be implemented
		 * even though it's optional in the CDC spec, and we don't
		 * advertise it in the ACM functional descriptor.
		 */
		return 1;
		}
	case USB_CDC_REQ_SET_LINE_CODING:
		if (*len < sizeof(struct usb_cdc_line_coding))
			return 0;

		return 1;
	}
	return 0;
}

static void cdcacm_data_rx_cb(u8 ep)
{
	(void)ep;

	char buf[64];
	unsigned i;
	unsigned len = usbd_ep_read_packet(0x01, buf, 64);

	for (i = 0; i < len; i++)
		buf_put(buf[i]);
}

static void cdcacm_set_config(u16 wValue)
{
	(void)wValue;

	usbd_ep_setup(0x01, USB_ENDPOINT_ATTR_BULK, 64, cdcacm_data_rx_cb);
	usbd_ep_setup(0x82, USB_ENDPOINT_ATTR_BULK, 64, NULL);
	usbd_ep_setup(0x83, USB_ENDPOINT_ATTR_INTERRUPT, 16, NULL);

	usbd_register_control_callback(
				USB_REQ_TYPE_CLASS | USB_REQ_TYPE_INTERFACE,
				USB_REQ_TYPE_TYPE | USB_REQ_TYPE_RECIPIENT,
				cdcacm_control_request);
}

void cdc_init(void)
{

	rcc_peripheral_enable_clock(&RCC_AHB1ENR, RCC_AHB1ENR_IOPAEN);
	rcc_peripheral_enable_clock(&RCC_AHB2ENR, RCC_AHB2ENR_OTGFSEN);

#if (BOARD == PX4FLOW)
	gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO11 | GPIO12);
	gpio_set_af(GPIOA, GPIO_AF10, GPIO11 | GPIO12);
#else
#if defined(BOARD_VRBRAINV40) || defined(BOARD_VRBRAINV45) || defined(BOARD_VRHEROV10) || defined(BOARD_VRGIMBALV20)
	gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO11 | GPIO12);
	gpio_set_af(GPIOA, GPIO_AF10, GPIO11 | GPIO12);
#else
	gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO9 | GPIO11 | GPIO12);
	gpio_set_af(GPIOA, GPIO_AF10, GPIO9 | GPIO11 | GPIO12);
#endif
#endif

	usbd_init(&otgfs_usb_driver, &dev, &config, usb_strings);
	usbd_register_set_config_callback(cdcacm_set_config);
}

static void cdc_disconnect(void)
{
	usbd_disconnect(true);
}

void
otg_fs_isr(void)
{
	usbd_poll();
}

void
cinit(void *config)
{
	cdc_init();
	nvic_enable_irq(NVIC_OTG_FS_IRQ);
}

void
cfini()
{
	cdc_disconnect();
	nvic_disable_irq(NVIC_OTG_FS_IRQ);
}

int
cin(void)
{
	return buf_get();
}

void
cout(uint8_t *buf, unsigned count)
{
	while (count) {
		unsigned len = (count > 64) ? 64 : count;
		unsigned sent;

		sent = usbd_ep_write_packet(0x82, buf, len);

		count -= sent;
		buf += sent;
	}
}
