Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34211 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934907AbcJRQWX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 12:22:23 -0400
Received: by mail-lf0-f51.google.com with SMTP id b81so350634021lfe.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2016 09:22:22 -0700 (PDT)
Received: from localhost.localdomain (127.7.150.83.ftth.as8758.net. [83.150.7.127])
        by smtp.gmail.com with ESMTPSA id g198sm238639wme.21.2016.10.18.09.22.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Oct 2016 09:22:19 -0700 (PDT)
Subject: Intel 7260 not working on 4.4.24 / armv7
To: linux-wireless@vger.kernel.org
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com>
 <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
 <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com>
From: Oliver Zemann <oliver.zemann@gmail.com>
Message-ID: <fa098763-cdf6-03f8-6d75-0fa9dfb270e4@gmail.com> (sfid-20161018_182323_634850_59C65E60)
Date: Tue, 18 Oct 2016 18:22:19 +0200
MIME-Version: 1.0
In-Reply-To: <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of the problems with the ath10 card, i bought an intel 7260 
(mpcie) wifi card. Unfortunately it is also not working.
I get tons of those messages:

[  175.777030] usb 1-1: new full-speed USB device number 2 using orion-ehci
[  175.933953] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  175.940681] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  175.966954] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  175.973313] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  176.183954] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  176.749831] usb 1-1: USB disconnect, device number 2
[  177.076993] usb 1-1: new full-speed USB device number 3 using orion-ehci
[  177.233953] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  177.240682] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  177.266957] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  177.273316] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  177.482955] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  178.046910] usb 1-1: USB disconnect, device number 3
[  178.376958] usb 1-1: new full-speed USB device number 4 using orion-ehci
[  178.533954] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  178.540682] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  178.566973] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  178.573315] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  178.782953] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  179.356044] usb 1-1: USB disconnect, device number 4
[  179.686915] usb 1-1: new full-speed USB device number 5 using orion-ehci
[  179.842952] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  179.849680] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  179.878956] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  179.885298] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  180.094953] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  180.650673] usb 1-1: USB disconnect, device number 5
[  180.976877] usb 1-1: new full-speed USB device number 6 using orion-ehci
[  181.132954] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  181.139682] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  181.165957] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  181.172311] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  181.381955] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  181.950509] usb 1-1: USB disconnect, device number 6
[  182.276841] usb 1-1: new full-speed USB device number 7 using orion-ehci
[  182.432953] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  182.439681] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  182.465956] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  182.472309] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  182.681956] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  183.247916] usb 1-1: USB disconnect, device number 7
[  183.576809] usb 1-1: new full-speed USB device number 8 using orion-ehci
[  183.732954] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  183.739682] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  183.765954] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  183.772307] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  183.982955] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  184.552876] usb 1-1: USB disconnect, device number 8
[  184.886772] usb 1-1: new full-speed USB device number 9 using orion-ehci
[  185.042953] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  185.049681] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  185.073955] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  185.080318] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  185.291956] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  185.854882] usb 1-1: USB disconnect, device number 9
[  186.186739] usb 1-1: new full-speed USB device number 10 using orion-ehci
[  186.342953] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  186.349680] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  186.373956] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  186.380311] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  186.589954] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  187.160396] usb 1-1: USB disconnect, device number 10
[  187.486706] usb 1-1: new full-speed USB device number 11 using orion-ehci
[  187.642954] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  187.649682] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  187.675955] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  187.682314] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  187.892955] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  188.464325] usb 1-1: USB disconnect, device number 11
[  188.796675] usb 1-1: new full-speed USB device number 12 using orion-ehci
[  188.952953] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  188.959681] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  188.985954] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  188.992344] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  189.202955] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  189.770861] usb 1-1: USB disconnect, device number 12
[  190.106645] usb 1-1: new full-speed USB device number 13 using orion-ehci
[  190.262953] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
[  190.269682] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[  190.296958] Bluetooth: hci0: read Intel version: 3707100180012d0d00
[  190.303299] Bluetooth: hci0: Intel Bluetooth firmware file: 
intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
[  190.512954] Bluetooth: hci0: Intel Bluetooth firmware patch completed 
and activated
[  191.076700] usb 1-1: USB disconnect, device number 13

some information about the card:
Bus 001 Device 011: ID 8087:07dc Intel Corp.
Couldn't open device, some information will be missing
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass          224 Wireless
   bDeviceSubClass         1 Radio Frequency
   bDeviceProtocol         1 Bluetooth
   bMaxPacketSize0        64
   idVendor           0x8087 Intel Corp.
   idProduct          0x07dc
   bcdDevice            0.01
   iManufacturer           0
   iProduct                0
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          177
     bNumInterfaces          2
     bConfigurationValue     1
     iConfiguration          0
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
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
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
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0009  1x 9 bytes
         bInterval               1
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
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0011  1x 17 bytes
         bInterval               1
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
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0019  1x 25 bytes
         bInterval               1
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
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0021  1x 33 bytes
         bInterval               1
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
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0031  1x 49 bytes
         bInterval               1
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


[root@alarm log]# uname -a
Linux alarm 4.4.24-2-ARCH #1 SMP Fri Oct 14 01:04:22 MDT 2016 armv7l 
GNU/Linux

What's confusing me is that this device is connected through pcie, not 
usb. When i use lspci i get:
[root@alarm log]# lspci
00:02.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04)
00:03.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04)
02:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac 
Wireless Network Adapter (rev ff)

So the other card is seen as pci device, but the intel is not. I am 
really lost now.
