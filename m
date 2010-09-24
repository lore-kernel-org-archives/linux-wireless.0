Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:44871 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab0IXUAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 16:00:35 -0400
Subject: Re: [PATCH v3] omap: beagle: add support for wl1271 on the board
 file
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Koen Kooi <koen@dominion.thruhere.net>
Cc: Tony Lindgren <tony@atomide.com>,
	"ext John W. Linville" <linville@tuxdriver.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <8004B807-6120-41C0-979B-214BFB75E5CA@dominion.thruhere.net>
References: <1285236215-21136-1-git-send-email-luciano.coelho@nokia.com>
	 <20100924180316.GE8077@tuxdriver.com> <1285354249.9779.3.camel@powerslave>
	 <20100924191139.GI4211@atomide.com>
	 <8004B807-6120-41C0-979B-214BFB75E5CA@dominion.thruhere.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 23:00:14 +0300
Message-ID: <1285358414.9779.28.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-24 at 21:42 +0200, ext Koen Kooi wrote:
> Op 24 sep 2010, om 21:11 heeft Tony Lindgren het volgende geschreven:
> 
> > * Luciano Coelho <luciano.coelho@nokia.com> [100924 11:42]:
> >> On Fri, 2010-09-24 at 20:03 +0200, ext John W. Linville wrote:
> >>> On Thu, Sep 23, 2010 at 01:03:35PM +0300, Luciano Coelho wrote:
> >>>> Add board configuration for the wl1271 daughter board.  This patch is based
> >>>> on Ohad Ben-Cohen's patches for Zoom boards.
> >>>> 
> >>>> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> >>>> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> >>>> ---
> >>>> from v2 to v3: removed accidental change to wl1271.h
> >>> 
> >>> I presume that this should come through my tree as well (since it
> >>> contains the move of wl12xx.h)?
> >> 
> >> Yes, this is based on your tree.  But please hold on, because there were
> >> some comments (namely, the expansion board should be detected, not
> >> configured for wl1271 by default), which I still have to fix.  I'm
> >> waiting for the manufacturer of the expansion board to provide me with
> >> some more info for proper detection.
> >> 
> >> Also, I know that there are some other work being done in the beagle
> >> board file, so we may need to rethink how to sync this.
> >> 
> >> So, for now, let's skip this patch and I'll provide another one when
> >> these issues are addressed.
> > 
> > You could also do it based on some kernel cmdline option. Of course
> > detection during the runtime would be better.
> 
> That's what we're currently doing in the beagle kernels: http://gitorious.org/beagleboard-validation/linux/commit/17c1b214b918c6f9efc5579134a7ff71d51b60bf
> 
> That needs forward porting to .37 before I can submit is as RFC here :)

Yes! I have seen that as pointed out by Robert.  It would be nice if you
could port this soon(ish) so that others can start using it (ok, maybe
not many people, but at least me :P)

What would you think about having the actual probing moved from u-boot
to the kernel? Do you think that would make sense or are there some
other reasons for having it in the bootloader?


-- 
Cheers,
Luca.

