Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40612 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab3CYTAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 15:00:44 -0400
Date: Mon, 25 Mar 2013 14:50:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-03-22
Message-ID: <20130325185035.GA17454@tuxdriver.com> (sfid-20130325_200109_131685_9C718AA8)
References: <1363723052.8336.6.camel@jlt4.sipsolutions.net>
 <1363947571.8238.4.camel@jlt4.sipsolutions.net>
 <1364120480.9224.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364120480.9224.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 24, 2013 at 11:21:20AM +0100, Johannes Berg wrote:
> *sigh*
> 
> 
> Testing found another issue. I'm not going to resend this, just give you
> a new commit ID.
> 
> > I have two tracing fixes (one from Vladimir), two fixes for P2P device
> > crashes, a fix for a BSS memory leak/lost update problem and a fix from
> > Ben for a scanning issue in mac80211. It's a little on the large side
> > because one of the P2P device problems required a bit much locking work,
> > but I've run through all the different scenarios (wext/nl80211,
> > p2p-device/station interface, ifdown/rfkill) to verify locking with
> > lockdep.
> 
> 
> 
> > The following changes since commit 801d929ca7d935ee199fd61d8ef914f51e892270:
> > 
> >   mac80211: another fix for idle handling in monitor mode (2013-03-02 21:24:42 +0100)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> > 
> > for you to fetch changes up to 9e68a67a888d98bda8393c29dde12fb4f0b42a19:
> 
> Really 370bd005937c0e00f9104a602f9fe1dd6b21b54b now.

Pulling now (before you repost again!)...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
