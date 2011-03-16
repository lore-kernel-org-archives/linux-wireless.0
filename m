Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61005 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1CPM3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 08:29:19 -0400
Received: by qyk7 with SMTP id 7so3343163qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 05:29:19 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Mar 2011 13:29:18 +0100
Message-ID: <AANLkTik25XJ0DKhH3e=vr=wRL65hqoRQyjKdDRUXvt1c@mail.gmail.com>
Subject: [rt2x00] New device id?AirLive WN-5000USB v2 (1b75:2770)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We've Ralink USB card owner on polish forum, he is using old 2.6.34
kernel, but I think his card it not supported even in latest
wireless-testing.

Some provided data:

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID 1b75:2770 Ovislink Corp.

43: USB 00.0: 0000 Unclassified device
  [Created at usb.122]
  Unique ID: ADDn.SoYTWydfmC1
  Parent ID: k4bc.3f5c44ENLJ9
  SysFS ID: /devices/pci0000:00/0000:00:13.2/usb1/1-1/1-1:1.0
  SysFS BusID: 1-1:1.0
  Hardware Class: unknown
  Model: "Ralink 802.11 n WLAN"
  Hotplug: USB
  Vendor: usb 0x1b75 "Ralink"
  Device: usb 0x2770 "802.11 n WLAN"
  Revision: "1.01"
  Serial ID: "1.0"
  Speed: 480 Mbps
  Module Alias: "usb:v1B75p2770d0101dc00dsc00dp00icFFiscFFipFF"
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #40 (Hub)

Should this card be supported by just adding it's ID?

Is there a way to add card's ID on the fly, without recompiling kernel?

-- 
Rafał
