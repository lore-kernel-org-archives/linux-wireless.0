Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:2490 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZBTWV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 17:21:26 -0500
Received: by yx-out-2324.google.com with SMTP id 8so446392yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 14:21:25 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 20 Feb 2009 14:21:24 -0800
Message-ID: <5cd984fd0902201421y5d8ee7ewa96d89b14efa6df8@mail.gmail.com> (sfid-20090220_232130_663454_BD04CF9F)
Subject: Please add linksys wusb54gp to working devices list.
From: Dennis Aliev <dennis@capricornsolutions.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please add Linksys WUSB54GP (no version, so I assume v1?) to a list of
compatible hardware.
http://www1.linksys.com/products/imagelib2/wusb54gp.jpg

Downloaded backtrack 4 beta VM and spent few hours chasing forums to
get the card working (Have been away from Linux 4 years, love the
progress!).  Turned out that simple overwrite of firmware (bundled
with Backtrack4-Beta) did the trick and finally assigned (wlan0)
device to the adapter. Even though the size of the files was identical
(29,500 bytes). Never checked the md5, sorry.

root@bt:~# ls -l /lib/firmware/isl3890usb
-rw-r--r-- 1 root root 29500 2007-02-12 15:51 /lib/firmware/isl3890usb

root@bt:~# lsusb -vvv
Bus 001 Device 003: ID 5041:2235 Linksys (?)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x5041 Linksys (?)
  idProduct          0x2235
  bcdDevice            2.02
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           95
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
      bNumEndpoints          11
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
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
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
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
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8d  EP 13 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0d  EP 13 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8e  EP 14 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0e  EP 14 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8f  EP 15 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0002
  (Bus Powered)
  Remote Wakeup Enabled


root@bt:~# lsmod  | grep p54usb
p54usb                 16384  0
p54common              18944  1 p54usb
mac80211              155936  2 p54usb,p54common


dmesg
usb 1-1: new high speed USB device using ehci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: firmware: requesting isl3890usb
p54: LM86 firmware
p54: FW rev 2.13.1.0 - Softmac protocol 5.5
p54: unknown eeprom code : 0x1
p54: unknown eeprom code : 0x3
p54: unknown eeprom code : 0x1905
p54: unknown eeprom code : 0x1007
p54: unknown eeprom code : 0x1008
p54: unknown eeprom code : 0x1100
phy1: hwaddr 00:0f:66:77:e1:d6, MAC:isl3886 RF:Frisbee
phy1: Selected rate control algorithm 'pid'

root@bt:~# airmon-ng start wlan0
Interface       Chipset         Driver

wlan0           PrismGT         p54usb - [phy1]
                                (monitor mode enabled on mon0)

root@bt:~# iwconfig
lo        no wireless extensions.
eth0      no wireless extensions.
wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:""
          Mode:Managed  Frequency:2.447 GHz  Access Point: Not-Associated
          Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

mon0      IEEE 802.11bg  Mode:Monitor  Frequency:2.447 GHz  Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


Cheers,

Dennis Aliev
Capricorn Solutions
(858) 952-1212

Online and Onsite Tech Support
support@capricornsolutions.com
http://www.capricornsolutions.com
