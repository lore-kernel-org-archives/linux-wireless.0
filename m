Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60497 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760591Ab3BHTaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 14:30:30 -0500
Date: Fri, 8 Feb 2013 14:25:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-02-04
Message-ID: <20130208192538.GG2116@tuxdriver.com> (sfid-20130208_203055_450301_04CC5D4A)
References: <1360001465.17993.30.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360001465.17993.30.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 04, 2013 at 07:11:05PM +0100, Johannes Berg wrote:
> John,
> 
> I've accumulated a bunch of patches again, so here's a new pull request
> for mac80211-next.
> 
> The biggest change I have is undoubtedly Marco's mesh powersave
> implementation. Beyond that, I have a patch from Emmanuel to modify the
> DTIM period API in mac80211, scan improvements and a removal of some
> previous workaround code from Stanislaw, dynamic short slot time from
> Thomas and 64-bit station byte counters from Vladimir. I also made a
> number of changes myself, some related to WoWLAN, some auth/deauth
> improvements and most of them BSS list cleanups.
> 
> Let me know if there are any problems.
> 
> Thanks,
> johannes
> 
> The following changes since commit 9ebea3829fac7505e0cd2642fbd13cfa9c038831:
> 
>   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless (2013-01-28 13:54:03 -0500)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 3f52b7e328c526fa7a592af9bf5772c591ed38a4:
> 
>   mac80211: mesh power save basics (2013-02-04 18:57:47 +0100)

Pulling now (and I'll take care of the mvm change for
IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC)...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
