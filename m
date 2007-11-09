Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:57755 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbXKISfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 13:35:43 -0500
Received: by nf-out-0910.google.com with SMTP id g13so559128nfb
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2007 10:35:41 -0800 (PST)
Message-ID: <2b74932e0711091035v323364e6n1e458e82a590dd3e@mail.gmail.com> (sfid-20071109_183616_006841_DFE72980)
Date: Fri, 9 Nov 2007 19:35:40 +0100
From: "David Dallet" <ddmdllt@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: unrecognized usb card D-LINK DWA-110
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I bought a D-Link DWA-110 usb stick and according to iwconfig, it
seems that the card is not recognized.
I searched on google but I was not able to find something relevant
about the problem.
I sent the result of some commands and the end of the message.
Is there anything I did wrong or is there something I could do to help
to identify the problem? (as long as I still have the card, maybe I'll
try a refund)
Thanks for your attention,

David Dallet

PS: I'm using Ubuntu 6.06 LTS

Here are lines from the result of "sudo lsusb -v":

Bus 004 Device 008: ID 07d1:3c07 D-Link System
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x07d1 D-Link System
  idProduct          0x3c07
  bcdDevice            0.01
  iManufacturer           1 Ralink
  iProduct                2 802.11 bg WLAN
  iSerial                 0
  bNumConfigurations      1
  (I don't paste all the lines here, but they are in http://pastebin.ca/767375)

Here are some lines from "sudo lshw":
              *-usb:1 UNCLAIMED
                   description: Generic USB device
                   product: 802.11 bg WLAN
                   vendor: Ralink
                   physical id: 3
                   bus info: usb@4:3
                   version: 0.01
                   capabilities: usb-2.00
                   configuration: maxpower=300mA speed=480.0MB/s
