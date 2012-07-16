Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34480 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab2GPHKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 03:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SqfRU-0000oC-2T
	for linux-wireless@vger.kernel.org; Mon, 16 Jul 2012 09:10:04 +0200
Received: from dslb-088-078-189-015.pools.arcor-ip.net ([88.78.189.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2012 09:10:04 +0200
Received: from elektronenblitz63 by dslb-088-078-189-015.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2012 09:10:04 +0200
To: linux-wireless@vger.kernel.org
From: Rainer Elstrodt <elektronenblitz63@online.de>
Subject: new BT device / ath3k unknown Product-ID / error
Date: Mon, 16 Jul 2012 07:04:43 +0000 (UTC)
Message-ID: <loom.20120716T085725-103@post.gmane.org> (sfid-20120716_091010_728899_B975987C)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
unknown Pruduct-ID, but patch don't work.

Bug Report with detailed information also here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1024884

Modul ath3k
BT-Chipset maybe AR3012

WLAN:

0d:00.0 Network controller [0280]: Atheros Communications Inc. AR9462 Wireless
Network Adapter [168c:0034] (rev 01)
Subsystem: Lite-On Communications Inc Device [11ad:6621]
Kernel driver in use: ath9k
Kernel modules: ath9k

lsusb (BT-device identified as):
Bus 002 Device 003: ID 04ca:3006 Lite-On Technology Corp.

iProduct value is 2, so it must be a AR3012 based chipset for BT (see lsusb -v).

lsusb -v

Bus 002 Device 004: ID 04ca:3006 Lite-On Technology Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  idVendor           0x04ca Lite-On Technology Corp.
  idProduct          0x3006 
  bcdDevice            0.01
  iManufacturer           1 
  iProduct                2 
  iSerial                 3 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          177
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          4 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1


diff -urN compat-wireless-2012-07-03/drivers/bluetooth/ath3k.c
compat-wireless-2012-07-03_bt_ath3k_04ca_3006_mod/drivers/bluetooth/ath3k.c
--- compat-wireless-2012-07-03/drivers/bluetooth/ath3k.c	2012-07-04
02:38:39.000000000 +0200
+++ compat-wireless-2012-07-03_bt_ath3k_04ca_3006_mod/drivers/bluetooth/ath3k.c
2012-07-13 23:29:04.000000000 +0200
@@ -76,6 +76,7 @@
 	{ USB_DEVICE(0x0CF3, 0x311D) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x04CA, 0x3005) },
+	{ USB_DEVICE(0x04CA, 0x3006) },
 	{ USB_DEVICE(0x13d3, 0x3362) },
 	{ USB_DEVICE(0x0CF3, 0xE004) },
 	{ USB_DEVICE(0x0930, 0x0219) },
@@ -101,6 +102,7 @@
 	{ USB_DEVICE(0x0cf3, 0x311D), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },
diff -urN compat-wireless-2012-07-03/drivers/bluetooth/btusb.c
compat-wireless-2012-07-03_bt_ath3k_04ca_3006_mod/drivers/bluetooth/btusb.c
--- compat-wireless-2012-07-03/drivers/bluetooth/btusb.c	2012-07-04
02:38:39.000000000 +0200
+++ compat-wireless-2012-07-03_bt_ath3k_04ca_3006_mod/drivers/bluetooth/btusb.c
2012-07-13 23:30:35.000000000 +0200
@@ -130,6 +130,7 @@
 	{ USB_DEVICE(0x0cf3, 0x311d), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
+	{ USB_DEVICE(0x04ca, 0x3006), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
 	{ USB_DEVICE(0x0930, 0x0219), .driver_info = BTUSB_ATH3012 },

error 01 (patch_01):

[ 38.428012] Bluetooth: Patch file not found ar3k/AthrBT_0x11020000.dfu
[ 38.428015] Bluetooth: Loading patch file failed
[ 38.428021] ath3k: probe of 2-1.6:1.0 failed with error -2


diff -urN compat-wireless-2012-07-03/drivers/bluetooth/ath3k.c
compat-wireless-2012-07-03_bt_ath3k_04ca_3006_mod/drivers/bluetooth/ath3k.c
--- compat-wireless-2012-07-03/drivers/bluetooth/ath3k.c	2012-07-04
02:38:39.000000000 +0200
+++ compat-wireless-2012-07-03_bt_ath3k_04ca_3006_mod/drivers/bluetooth/ath3k.c
2012-07-14 10:09:18.740066000 +0200
@@ -76,6 +76,7 @@
 	{ USB_DEVICE(0x0CF3, 0x311D) },
 	{ USB_DEVICE(0x13d3, 0x3375) },
 	{ USB_DEVICE(0x04CA, 0x3005) },
+	{ USB_DEVICE(0x04CA, 0x3006) },
 	{ USB_DEVICE(0x13d3, 0x3362) },
 	{ USB_DEVICE(0x0CF3, 0xE004) },
 	{ USB_DEVICE(0x0930, 0x0219) },

error 02 (patch_02):

[ 15.770583] Bluetooth: Core ver 2.16
[ 15.770601] Bluetooth: HCI device and connection manager initialized
[ 15.770603] Bluetooth: HCI socket layer initialized
[ 15.770604] Bluetooth: L2CAP socket layer initialized
[ 15.770609] Bluetooth: SCO socket layer initialized
[ 18.979363] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[ 18.979366] Bluetooth: BNEP filters: protocol multicast
[ 19.003989] Bluetooth: RFCOMM TTY layer initialized
[ 19.003995] Bluetooth: RFCOMM socket layer initialized
[ 19.003997] Bluetooth: RFCOMM ver 1.11
[ 19.213474] Bluetooth: Error in firmware loading err = -110,len = 0, size = 4096
[ 19.213506] ath3k: probe of 2-1.6:1.0 failed with error -110
[ 19.213539] usbcore: registered new interface driver ath3k

with best regards
Rainer Elstrodt

