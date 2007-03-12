Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3175 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXCLSC0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 14:02:26 -0400
Date: Mon, 12 Mar 2007 13:46:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joseph Jezak <josejx@gentoo.org>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix typo in B5PHY init specifications
Message-ID: <20070312174656.GC8878@tuxdriver.com>
References: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net> <1173685989.3584.2.camel@shinybook.infradead.org> <45F55452.3000704@gentoo.org> <20070312145309.GB8878@tuxdriver.com> <1173712594.3584.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173712594.3584.6.camel@shinybook.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2007 at 04:16:34PM +0100, David Woodhouse wrote:
> On Mon, 2007-03-12 at 10:53 -0400, John W. Linville wrote:
> > 
> > FWIW, by inspection it looks like the mac80211-based driver is
> > (trying?) to implement this change.
> > 
> > David, have you tried the mac80211 version?  Does it still have the
> > same crash?
> 
> Should the one in 2.6.20-1.2982.fc7 be OK? I can try that relatively
> easily; anything else might need to wait till I get home.

Yes, I think that will do.  It certainly looks to be up-to-date.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
