Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 42.248.sfcn.org ([160.7.248.42]:39352 "HELO mail.mypals.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754895AbZEBVx4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 17:53:56 -0400
From: Alf <alf@mypals.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ath5k in 2.6.29.1 won't associate with AP
Date: Sat, 2 May 2009 15:53:54 -0600
Cc: linux-wireless@vger.kernel.org
References: <200905021218.23747.alf@mypals.org> <1241298894.13562.28.camel@johannes.local>
In-Reply-To: <1241298894.13562.28.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200905021553.55173.alf@mypals.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 May 2009 03:14:54 pm Johannes Berg wrote:
> On Sat, 2009-05-02 at 12:18 -0600, Alf wrote:
> > It seems I am able to associate with an AP (not just my AP)
> > sporadically. It seems that when it works, it works reliably, but
> > that's only 10% of the time, if that.  I have turned on debugging on
> > ath5 and on mac80211 but the debug messages don't offer anything
> > useful.  The only thing I get is this:
> >
> > May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
> > May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
> > May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
> > May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
> > May  2 12:08:28 wlan0 direct probe responded
>
> What kernel are you using?

I did see your next message, but just to be sure:

2.6.29.1

Also, this is what lspci reports:
00:07.0 Ethernet controller: Atheros Communications Inc. AR2413 802.11bg NIC 
(rev 01)
        Subsystem: D-Link System Inc D-Link AirPlus G DWL-G510 Wireless PCI 
Adapter(rev.B)
        Flags: bus master, medium devsel, latency 96, IRQ 18
        Memory at e0120000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2

Some Google searches in other lists said this card didn't work in Linux and 
that I should use madwifi.  I patched my kernel with the latest madwifi 
snapshot but that didn't work either.  I was able to associate with the the 
AP, but I could never get a DHCP response.  I also just tried the wireless-
testing tree and it didn't associate.

Does anyone know if this card is supported?  Anybody know why this card 
works sometimes but most of the time it can't associate with the AP?

Any help would be appreciated.

-- 
Alf
@
