Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38109 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab2FYUXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 16:23:03 -0400
Message-ID: <4FE8C89E.8040607@hauke-m.de> (sfid-20120625_222307_796830_96E029B2)
Date: Mon, 25 Jun 2012 22:22:54 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: Question about BCM43228 and outdated description in MAINTAINERS
References: <4FE886B3.7020202@lwfinger.net> <4FE88E1A.9050202@hauke-m.de> <1340654635.3413.19.camel@gnutoo-hplaptop>
In-Reply-To: <1340654635.3413.19.camel@gnutoo-hplaptop>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/25/2012 10:03 PM, Denis 'GNUtoo' Carikli wrote:
> On Mon, 2012-06-25 at 18:13 +0200, Hauke Mehrtens wrote:
>> Add support for more chips, including (near term) BCM43227, BCM43228,
>> and BCM4331. Support for additional new chips to follow. 
> What about the BCM43231?
> There was some plans about it:
> http://lists.infradead.org/pipermail/b43-dev/2012-January/002297.html
> 
> But the thread ends and then it seem that nothing was achieved.
> 
> I've a BCM43231:
> Bus 001 Device 008: ID 0846:9020 NetGear, Inc. WNA3100(v1) Wireless-N
> 300 [Broadcom BCM43231]
> 
> Are there some wireless kernels developers in Italy or in France that
> would accept a bcm43231 card in exchange of working on a driver?
> 
> Denis.

I just found a driver for "Dongle BUS interface for USB, SDIO, SPI,
etc." which seams to also support the BCM43231 licensed under a
permissive license in the GPL source tar of the ASUS RT-AC66U. [0] I
haven't found the firmware for that specific device, but someone could
try to get that driver running with a normal Linux kernel. I am also
interested in that as I have a USB device in my router not supported by
brcmfmac.
Currently I do not have time for that, but I will probably have a closer
look into that driver soon.

Hauke

[0] asuswrt/release/src-rt-6.x/shared/dbus*
