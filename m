Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41382 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab1CPNTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 09:19:45 -0400
Received: by vxi39 with SMTP id 39so1587586vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 06:19:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik25XJ0DKhH3e=vr=wRL65hqoRQyjKdDRUXvt1c@mail.gmail.com>
References: <AANLkTik25XJ0DKhH3e=vr=wRL65hqoRQyjKdDRUXvt1c@mail.gmail.com>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Wed, 16 Mar 2011 13:11:16 +0000
Message-ID: <AANLkTi=a577NYY6P_St-r5f498Bbari7mcX=S_Kw1_d6@mail.gmail.com>
Subject: Re: [rt2x00] New device id?AirLive WN-5000USB v2 (1b75:2770)
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafal,

2011/3/16 Rafał Miłecki <zajec5@gmail.com>:
> Hi,
>
> We've Ralink USB card owner on polish forum, he is using old 2.6.34
> kernel, but I think his card it not supported even in latest
> wireless-testing.
>
> Some provided data:
>
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 002: ID 1b75:2770 Ovislink Corp.
>
> 43: USB 00.0: 0000 Unclassified device
>  [Created at usb.122]
>  Unique ID: ADDn.SoYTWydfmC1
>  Parent ID: k4bc.3f5c44ENLJ9
>  SysFS ID: /devices/pci0000:00/0000:00:13.2/usb1/1-1/1-1:1.0
>  SysFS BusID: 1-1:1.0
>  Hardware Class: unknown
>  Model: "Ralink 802.11 n WLAN"
>  Hotplug: USB
>  Vendor: usb 0x1b75 "Ralink"
>  Device: usb 0x2770 "802.11 n WLAN"
>  Revision: "1.01"
>  Serial ID: "1.0"
>  Speed: 480 Mbps
>  Module Alias: "usb:v1B75p2770d0101dc00dsc00dp00icFFiscFFipFF"
>  Config Status: cfg=new, avail=yes, need=no, active=unknown
>  Attached to: #40 (Hub)
>
> Should this card be supported by just adding it's ID?
> Is there a way to add card's ID on the fly, without recompiling kernel?

Kind of, please try to get the compat-wireless package and work from there

It looks like an 'old' chipset, 2770, you can try to add it in the
relevant section (Ovislink) in rt2800.c

But there are no guarantees it will work :)

And don't forget, that card needs firmware (can't remember teh actual filename).






Luis Correia
rt2x00 project admin
