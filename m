Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from llsb708-a03.servidoresdns.net ([82.223.190.29]:46559 "EHLO
	llsb708-a03.servidoresdns.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712Ab0ANTEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 14:04:46 -0500
Subject: Re: ath9k/AR9285 - incompatibility with bluetooth
From: Alberto =?ISO-8859-1?Q?Jos=E9_Rodr=EDguez_?=
	 =?ISO-8859-1?Q?Rodr=EDguez?= <ajrodriguez@blulabs.es>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1263492165.31774.13.camel@localhost.localdomain>
References: <1263494975.4643.15.camel@eclipse>
	 <1263492165.31774.13.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 19:56:15 +0000
Message-Id: <1263498975.4643.61.camel@eclipse>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your response. I made this question because
while this device loses the connection, on my laptop, with the same
bluetooth device, the connection is not affected.



 03:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100


El jue, 14-01-2010 a las 10:02 -0800, Dan Williams escribió:
> On Thu, 2010-01-14 at 18:49 +0000, Alberto José Rodríguez Rodríguez
> wrote:
> > Hellow,
> > 	I have a ZOTAC MAG ION and I'm having problems with wireless
> > connections
> > 
> > Distribution: Ubuntu 9.10
> > Kernel version: 2.6.31-16
> > Device: 04:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
> > Problem Description:
> >     - Low signal strength
> >     - Cannot connect to wireless networks
> > Using linux-backports-modules-karmic:
> >     - Low signal strength persists
> >     - Can connect to WPA networks but signal strengh is low and unstable, also when using at the same time a Bluetooth USB dongle (continuously inquiring) the wireless connection is lost.
> >     - Cannot connect to WEP networks, although the WEP key is set correctly and the device is associated to the AP
> > Using latest linux-wireless snapshot (20100113):
> >     - Can connect to WEP networks but when I use at the same time a Bluetooth USB dongle (continuously inquiring) the speed of the wireless connection becomes very slow.
> >     - Can connect to WPA networks but when I use at the same time a Bluetooth USB dongle (continuously inquiring) the wireless connection is lost.
> 
> This isn't unexpected; Bluetooth and WiFi interfere with each other
> because they both use 2.4GHz.  So don't expect great performance out of
> either BT or WiFi when you're using both at the same time.  Many
> built-in chips have BT co-existence capability, but that only works if
> both the WiFi and BT chips are built into your computer and are wired up
> to talk to each other.  External USB BT or WiFi dongles almost certainly
> will not have working coexistence support.
> 
> Dan
> 
> 
-- 
Alberto José Rodríguez Rodríguez <ajrodriguez@blulabs.es>
BluLabs, S.L.

