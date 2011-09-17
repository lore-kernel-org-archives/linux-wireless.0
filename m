Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51913 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab1IQWXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 18:23:34 -0400
Date: Sun, 18 Sep 2011 00:23:20 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Manuel Munz <freifunk@somakoma.de>, linux-wireless@vger.kernel.org
Subject: Re: No beacons in ad-hoc mode with b43
Message-ID: <20110918002320.03f6a9fc@milhouse> (sfid-20110918_002341_933669_89BA70B9)
In-Reply-To: <CACna6rxN+9ZJVnt-WGpxvyUrnBO9gnVOcTeZD9=eJZOUjJcgww@mail.gmail.com>
References: <4E751496.30903@somakoma.de>
	<CACna6rxN+9ZJVnt-WGpxvyUrnBO9gnVOcTeZD9=eJZOUjJcgww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 18 Sep 2011 00:13:32 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> 2011/9/17 Manuel Munz <freifunk@somakoma.de>:
> > i want to use b43 on older broadcom wireless routers with openwrt, but
> > there seems to be a problem: The router doesn't send beacons in adhoc
> > mode (verified with wireshark), which means users can't see the network
> > in a network scan. So is there a problem in the adhoc implementation
> > with b43? Could someone please have a look at this? It is preventing us
> > from using b43 in our mesh for too long now.

adhoc is not tested a lot with b43 and nobody is really interested in it.
I _think_ it used to work, however.
You should probably compare AP vs adhoc codepaths. AP mode an adhoc are very
similar with only tiny differences in the driver.

> > Router:
> > Siemens SE505 (very similar to wrt54g), Broadcom 4712 WLAN (core revision 7)
> 
> Please give us at least
> lspci -nn | grep 14e4

This is an embedded device.

-- 
Greetings, Michael.
