Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sysgo.com ([195.145.229.155]:40848 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab0KHHT3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 02:19:29 -0500
Date: Mon, 8 Nov 2010 08:19:37 +0100
From: Pavel Machek <pma@sysgo.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Josh Lehan <krellan@krellan.com>
Subject: Re: working usb wifi card, that is still possible to buy
Message-ID: <20101108071937.GA13817@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
 <ff5cf9bdd23aa256b379521d4c4263d8@localhost>
 <4CD46524.5010100@lwfinger.net>
 <201011061143.12038.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201011061143.12038.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> > >> The Realtek RTL8712 (aka RTL8192U) and found in the D-Link DWA 130, has
> > > a
> > >> driver
> > >> in 2.6.37 (r8712u). Although not based on mac80211, thus found in
> > > staging,
> > >> the
> > >> driver is extremely stable - my connection never drops out. With an
> > > 802.11n
> > >> router, I get transmission throughput of up to 70 Mb/s.
> > > 
> > > That definitely requires USB 2 though, and I suspect that
> > > nobody actually ever tests their devices on a 1.1 only
> > > controller like Pavel was asking for.
> > 
> > I have tested on 1.1 and it works. The rate mechanism of that non-mac80211
> > driver ends up at 54M with a maximum transmission rate of 7.1 Mb/s. That must be
> > the maximum that USB 1.1 can handle.
> 
> heh, be careful with what you're saying. He has problems
> with not just one, but two completely different devices.
> So r8712u might work perfectly well for you and your 1.1
> USB hcd. But from the logs he posted I think it's not
> just a wacky driver or firmware "problem".

Okay, so in the meantime, I found a reason why AirLive card did not
work properly. Cable supplied with DLink card had borderline connector
:-(.

AirLive (rt2800) card is actually stable, even on USB 1.1 -- it
survived overnight testing.

I still got around 5% packet loss -- it seems every minute or so
connection fails for few seconds -- but TCP connection survived
overnight, doing ~1MB/sec all the time.

So AirLive card works here.
							Pavel
