Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:38098 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759290AbZKKWFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 17:05:04 -0500
Received: by fxm21 with SMTP id 21so1549392fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 14:05:08 -0800 (PST)
Message-ID: <4AFB350F.7010207@lwfinger.net>
Date: Wed, 11 Nov 2009 16:05:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please share info about power consumption characteristics of
 your USB adapter
References: <200911112219.08814.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200911112219.08814.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2009 03:19 PM, Janusz Krzysztofik wrote:
> Hi,
> 
> Please anyone owning one of adapters listed below: if the adapter is supported 
> by linux-wireless, please check for MaxPower with lsusb -v and give me the 
> result. I am looking for an adapter with MaxPower less than 300mA and would 
> rather not buy them all to learn they all do not fit :-).
> 
> Once again, sorry for abusing a devel list for this.
> 
> Thanks,
> Janusz
> 
> Asus WL-167g V2 (90-I8N2E0-0UAZ)
> D-Link DWA-125
> D-Link DWA-140
> D-Link DWL-G122
> Intellinet 503457
> Linksys WUSB100-EU
> Linksys WUSB54GC-EU
> Modecom WIFI-CARD-USB-MC-0105
> Modecom WIFI-CARD-USB-MC-0106
> Netgear WG111TEE
> Netgear WPN111EE
> OvisLink WL-1600USB
> Pentagram P 6132-08
> TP-Link TL-WN422G
> TP-Link TL-WN721N
> TP-Link TL-WN821N

I do not have any of the specific models you mention, but here are the 3 that I
have:

Netgear WG111v2    [Realtek RTL8187L] USB ID 0846:6a00 MaxPower 500mA
Level One 0301USB  [Realtek RTL8187B] USB ID 0bda:8187 MaxPower 500mA
Dell 1450 USB      [uses p54usb]      USB ID 413c:8104 MaxPower 500mA

There seems to be a pattern!

Larry
