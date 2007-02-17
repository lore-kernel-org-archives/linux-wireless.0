Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:45776 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992997AbXBQRv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 12:51:28 -0500
Message-ID: <20070217125127.hfrlkwkgo884sos8@webmail.spamcop.net>
Date: Sat, 17 Feb 2007 12:51:27 -0500
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: More breakage in wireless-dev.git
References: <1171690868.31103.17.camel@dv>
	<20070217114436.jhcgs4soo4sgo8sk@webmail.spamcop.net>
	<200702171755.36291.mb@bu3sch.de> <200702171830.38104.mb@bu3sch.de>
In-Reply-To: <200702171830.38104.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Michael Buesch <mb@bu3sch.de>:

> On Saturday 17 February 2007 17:55, Michael Buesch wrote:
> > > wlan0: starting scan
> > > bcm43xx_d80211: Reconfiguring PHYmode to A-PHY
> >
> > Oh, heh. Well. Does your device have an A-PHY?
> > If not, it's related to a bug I am fixing at the moment. ;)
>
> Well, anyway, this should be fixed in my tree now by
> ignoring A-PHYs, as we don't support them, yet.

Actually, my card supports 802.11a.  The card is marked as 1490, and Dell
advertises such cards as 802.11a/b/g.

But it would be fine if it supports 802.11b/g for now.

> The slab error on the end of your dmesg is interresting, though.

I'll have a closer look.

--
Regards,
Pavel Roskin
