Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4549 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbXEFCdR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2007 22:33:17 -0400
Date: Sat, 5 May 2007 22:00:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gary Zambrano <zambrano@broadcom.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, ralf@linux-mips.org
Subject: Re: Merging SSB upstream
Message-ID: <20070506020051.GA30917@tuxdriver.com>
References: <200705060303.17594.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705060303.17594.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 06, 2007 at 03:03:17AM +0200, Michael Buesch wrote:
> So, now that mac80211 is merged upstream, I think it's
> time to merge SSB and the b44-ssb port upstream.
> Note that bcm43xx-mac80211 is _not_ ready for upstream, yet.
 
ACK, unfortunately.

> What do you think? I'd like to merge ssb as-is, although
> the embedded-device parts are not quite finished, yet.
> But they don't interfere with the non-embedded parts used
> by b44 and the bcm43xx PCI cards.

How much testing have you (and others) done w/ b44?  I had to remove
the b44 ssb changes from fedora because a) users reported problems;
and b) I was more worried about wireless than b44+ssb. (sorry!)

So, has anyone been using b44 in -mm?

> So we _could_ remove the ssb-mips code, but I don't like to
> do that for better maintainability. It doesn't hurt anyone IMO.

I guess I don't see a problem w/ merging the mips part, as long as the
b44 part has been thoroughly tested.  I wonder if Ralf has an opinion?

John
-- 
John W. Linville
linville@tuxdriver.com
