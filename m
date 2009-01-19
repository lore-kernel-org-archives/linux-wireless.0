Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.baz.cz ([81.19.45.35]:54909 "EHLO smtp.baz.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbZASTKB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 14:10:01 -0500
Received: from mentalek.tisnov.czf ([10.129.26.37])
	by server-i.cipis.net with esmtp (Exim 4.50)
	id 1LOzOx-00050N-An
	for linux-wireless@vger.kernel.org; Mon, 19 Jan 2009 20:03:17 +0100
From: Petr =?UTF-8?Q?Men=C5=A1=C3=ADk?= <pihhan@cipis.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-ofVmPaRIsrTHrMgZB7rb"
Date: Mon, 19 Jan 2009 20:03:11 +0100
Message-Id: <1232391791.7271.23.camel@mentalek> (sfid-20090119_201010_311318_0155258E)
Mime-Version: 1.0
Subject: TP-Link TL-WN422G with RF MAXIM_NEW_RF
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ofVmPaRIsrTHrMgZB7rb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

i bought today new usb wifi card with hope it will work under linux, as
it is zydas based card. It does not work however. 

It does report itself as:
Bus 007 Device 011: ID 0ace:1215 ZyDAS WLA-54L WiFi

Advertised name of it 
manufacturer:TP-LINK model:TL-WN422G

After reading firmware it reports error:
[  655.364272] zd1211rw 5-2:1.0: RF MAXIM_NEW_RF 0x8 is not supported

It tries to reload firmware, after while it begin returning -110 error. 

Are there any chances it will ever work? What is needed to get
initialization procedure? I have drivers for most MS Windows from 98 to
vista. Are somewhere guidelines to extract needed initialization for
unknown RF chips? What can i do for it? I know some programming, but
never did real disassembling. Is there way to get more info about used
chips without breaking cover?

Yours,
Petr Mensik

--=-ofVmPaRIsrTHrMgZB7rb
Content-Disposition: attachment; filename=zydas-kern.log
Content-Type: text/x-log; name=zydas-kern.log; charset=UTF-8
Content-Transfer-Encoding: 7bit

Jan 19 18:54:16 mentuzok2 kernel: [  637.960428] usb 5-2: Could not load firmware file zd1211/zd1211b_ub. Error number -2
Jan 19 18:54:16 mentuzok2 kernel: [  637.960434] zd1211rw 5-2:1.0: couldn't load firmware. Error number -2
Jan 19 18:54:33 mentuzok2 kernel: [  655.311427] firmware: requesting zd1211/zd1211b_ub
Jan 19 18:54:33 mentuzok2 kernel: [  655.323560] firmware: requesting zd1211/zd1211b_uphr
Jan 19 18:54:33 mentuzok2 kernel: [  655.364272] zd1211rw 5-2:1.0: RF MAXIM_NEW_RF 0x8 is not supported
Jan 19 18:54:50 mentuzok2 kernel: [  672.410088] firmware: requesting zd1211/zd1211b_ub
Jan 19 18:54:50 mentuzok2 kernel: [  672.422701] firmware: requesting zd1211/zd1211b_uphr
Jan 19 18:55:01 mentuzok2 kernel: [  683.815428] usb 5-2: USB disconnect, address 5
Jan 19 18:55:05 mentuzok2 kernel: [  688.441554] usb 5-2: new high speed USB device using ehci_hcd and address 6
Jan 19 18:55:06 mentuzok2 kernel: [  688.574621] usb 5-2: configuration #1 chosen from 1 choice
Jan 19 18:55:06 mentuzok2 kernel: [  688.690632] usb 5-2: reset high speed USB device using ehci_hcd and address 6
Jan 19 18:55:06 mentuzok2 kernel: [  688.828078] phy1: Selected rate control algorithm 'pid'
Jan 19 18:55:06 mentuzok2 kernel: [  688.830800] zd1211rw 5-2:1.0: phy1
Jan 19 18:55:06 mentuzok2 kernel: [  688.830859] usb 5-2: New USB device found, idVendor=0ace, idProduct=1215
Jan 19 18:55:06 mentuzok2 kernel: [  688.830861] usb 5-2: New USB device strings: Mfr=16, Product=32, SerialNumber=0
Jan 19 18:55:06 mentuzok2 kernel: [  688.830863] usb 5-2: Product: USB2.0 WLAN
Jan 19 18:55:06 mentuzok2 kernel: [  688.830864] usb 5-2: Manufacturer: ZyDAS
Jan 19 18:55:06 mentuzok2 kernel: [  688.936931] firmware: requesting zd1211/zd1211b_ub
Jan 19 18:55:06 mentuzok2 kernel: [  688.950233] firmware: requesting zd1211/zd1211b_uphr
Jan 19 18:55:06 mentuzok2 kernel: [  688.989798] zd1211rw 5-2:1.0: RF MAXIM_NEW_RF 0x8 is not supported
Jan 19 18:55:09 mentuzok2 kernel: [  691.608881] firmware: requesting zd1211/zd1211b_ub
Jan 19 18:55:09 mentuzok2 kernel: [  691.620796] firmware: requesting zd1211/zd1211b_uphr
Jan 19 18:55:31 mentuzok2 kernel: [  713.865106] firmware: requesting zd1211/zd1211b_ub
Jan 19 18:55:31 mentuzok2 kernel: [  713.878265] firmware: requesting zd1211/zd1211b_uphr
Jan 19 18:55:32 mentuzok2 kernel: [  714.889227] usb 5-2: USB control request for firmware upload failed. Error number -110
Jan 19 18:55:32 mentuzok2 kernel: [  714.889233] usb 5-2: Could not upload firmware code uph. Error number -110
Jan 19 18:55:32 mentuzok2 kernel: [  714.889247] zd1211rw 5-2:1.0: couldn't load firmware. Error number -110
Jan 19 18:55:49 mentuzok2 kernel: [  732.126942] firmware: requesting zd1211/zd1211b_ub
Jan 19 18:55:49 mentuzok2 kernel: [  732.138999] firmware: requesting zd1211/zd1211b_uphr
Jan 19 18:55:50 mentuzok2 kernel: [  733.152586] usb 5-2: USB control request for firmware upload failed. Error number -110
Jan 19 18:55:50 mentuzok2 kernel: [  733.152591] usb 5-2: Could not upload firmware code uph. Error number -110
Jan 19 18:55:50 mentuzok2 kernel: [  733.152611] zd1211rw 5-2:1.0: couldn't load firmware. Error number -110
Jan 19 18:56:07 mentuzok2 kernel: [  750.454139] firmware: requesting zd1211/zd1211b_ub
Jan 19 18:56:07 mentuzok2 kernel: [  750.466555] firmware: requesting zd1211/zd1211b_uphr


--=-ofVmPaRIsrTHrMgZB7rb
Content-Disposition: attachment; filename=zydas-lsusb.txt
Content-Type: text/plain; name=zydas-lsusb.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit


Bus 007 Device 011: ID 0ace:1215 ZyDAS WLA-54L WiFi
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x0ace ZyDAS
  idProduct          0x1215 WLA-54L WiFi
  bcdDevice           48.10
  iManufacturer          16 
  iProduct               32 
  iSerial                 0 
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
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1

--=-ofVmPaRIsrTHrMgZB7rb
Content-Disposition: attachment; filename=zydas-tplink-lsusb.txt
Content-Type: text/plain; name=zydas-tplink-lsusb.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit


Bus 005 Device 003: ID 0ace:1215 ZyDAS WLA-54L WiFi
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x0ace ZyDAS
  idProduct          0x1215 WLA-54L WiFi
  bcdDevice           48.10
  iManufacturer          16 ZyDAS
  iProduct               32 USB2.0 WLAN
  iSerial                 0 
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
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
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
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--=-ofVmPaRIsrTHrMgZB7rb--

