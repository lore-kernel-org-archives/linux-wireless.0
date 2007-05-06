Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36310
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506AbXEFJpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2007 05:45:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Merging SSB upstream
Date: Sun, 6 May 2007 11:44:27 +0200
Cc: Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gary Zambrano <zambrano@broadcom.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, ralf@linux-mips.org
References: <200705060303.17594.mb@bu3sch.de> <20070506020051.GA30917@tuxdriver.com>
In-Reply-To: <20070506020051.GA30917@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705061144.27817.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 06 May 2007 04:00:51 John W. Linville wrote:
> On Sun, May 06, 2007 at 03:03:17AM +0200, Michael Buesch wrote:
> > So, now that mac80211 is merged upstream, I think it's
> > time to merge SSB and the b44-ssb port upstream.
> > Note that bcm43xx-mac80211 is _not_ ready for upstream, yet.
>  
> ACK, unfortunately.
> 
> > What do you think? I'd like to merge ssb as-is, although
> > the embedded-device parts are not quite finished, yet.
> > But they don't interfere with the non-embedded parts used
> > by b44 and the bcm43xx PCI cards.
> 
> How much testing have you (and others) done w/ b44?

Well, it works for me with my b44 card I got from broadcom.
There are really only 2 or 3 different b44 cards, so chances are damn
high it will work for all.

> I had to remove 
> the b44 ssb changes from fedora because a) users reported problems;

Which problems were that? The 2 compile issues?
Trivial to fix if that's the only issue. ;)

-- 
Greetings Michael.
