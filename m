Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay02.solcon.nl ([212.45.32.108]:44642 "EHLO
	mailrelay02.solcon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2J2Q5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 12:57:53 -0400
Message-ID: <508EB140.5010102@solcon.nl> (sfid-20121029_175757_351644_21A28FF9)
Date: Mon, 29 Oct 2012 17:39:28 +0100
From: Albert Pool <albertpool@solcon.nl>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
Subject: Unknown Realtek USB device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Can any of you help me identify the Realtek chip in this device so that the USB ID can be added to the right driver?
It's a 802.11n USB nano dongle from ISY. I only have the dongle for short time, so I may not be able to test it myself if it takes some time.
usb-devices and lsusb -v output is attached.

Kind regards,

Albert Pool

T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=050d ProdID=11f2 Rev=02.00
S:  Manufacturer=Realtek
S:  Product=802.11n WLAN Adapter
S:  SerialNumber=00e04c000001
C:  #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

Bus 001 Device 003: ID 050d:11f2 Belkin Components
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x050d Belkin Components
   idProduct          0x11f2
   bcdDevice            2.00
   iManufacturer           1 Realtek
   iProduct                2 802.11n WLAN Adapter
   iSerial                 3 00e04c000001
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              0
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
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               1
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

