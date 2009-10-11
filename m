Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:53010 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZJKMOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 08:14:21 -0400
Received: by fxm27 with SMTP id 27so8039928fxm.17
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 05:13:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1df1788c0910110455q570ca89fy6edbda3235a7a35e@mail.gmail.com>
References: <1df1788c0910110455q570ca89fy6edbda3235a7a35e@mail.gmail.com>
From: =?UTF-8?Q?Br=C3=A1ulio_B_O_Bhavamitra?= <brauliobo@gmail.com>
Date: Sun, 11 Oct 2009 09:13:23 -0300
Message-ID: <1df1788c0910110513j6847bf97q71059fec4ae9722b@mail.gmail.com>
Subject: RaLink 148f:3070 not working since upgrade from 2.6.30 to 2.6.31
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the upgrade from kernel 2.6.30 to 2.6.31 on archlinux the usb
wireless from Ralink doesn't work anymore.
Please ask for more info if necessary.

dmesg:
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_regbusy_read: Error - Indirect register access
failed: offset=0x00007010, value=0xffff8800
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_regbusy_read: Error - Indirect register access
failed: offset=0x00007010, value=0xffff8800
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed
for offset 0x7010 with error -19.
phy2 -> rt2x00usb_regbusy_read: Error - Indirect register access
failed: offset=0x00007010, value=0xffff8800
usb 2-2: new high speed USB device using ehci_hcd and address 6
usb 2-2: configuration #1 chosen from 1 choice
phy3: Selected rate control algorithm 'minstrel'
Registered led device: rt2800usb-phy3::radio
Registered led device: rt2800usb-phy3::assoc
Registered led device: rt2800usb-phy3::quality
rt2800usb 2-2:1.0: firmware: requesting rt2870.bin
phy3 -> rt2x00lib_request_firmware: Error - Failed to request Firmware.
rt2800usb 2-2:1.0: firmware: requesting rt2870.bin
phy3 -> rt2x00lib_request_firmware: Error - Failed to request Firmware.

lsusb -v:
Bus 002 Device 006: ID 148f:3070 Ralink Technology, Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x148f Ralink Technology, Corp.
  idProduct          0x3070
  bcdDevice            1.01
  iManufacturer           1 Ralink
  iProduct                2 802.11 n WLAN
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           67
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              450mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           7
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              5
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x06  EP 6 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)
