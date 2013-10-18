Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42056 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab3JRSAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 14:00:09 -0400
Date: Fri, 18 Oct 2013 13:58:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-10-18
Message-ID: <20131018175835.GE28130@tuxdriver.com> (sfid-20131018_200015_445812_1B6502AE)
References: <1382106086.14393.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382106086.14393.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 18, 2013 at 04:21:26PM +0200, Johannes Berg wrote:
> John,
> 
> And for iwlwifi-next ... This is bigger. I guess -next stuff can wait
> until after KS though. Also, I think there might be a merge conflict
> hidden here, don't really remember.
> 
> For this round, I have a lot of changes:
>  * power management improvements
>  * BT coexistence improvements/updates
>  * new device support
>  * VHT support
>  * IBSS support (though due to a small bug it requires new firmware)
>  * various other fixes/improvements.
> 
> Sorry to concentrate it all into one pull request, I was holding for a
> small bugfix that turned out to be much more difficult than I expected,
> but also not needed yet (so this code has a known bug with -8 firmware,
> but we'll fix it before the driver gets updated to use that firmware.)
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit e25aa82a89db9e3b09d02b5481aa375c7712a10d:
> 
>   rt2x00: rt2800lib: fix VGC adjustment for RT3572 and RT3593 (2013-10-10 13:53:07 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 246dd9922e859768aa522daa6c1c601785e57e0c:
> 
>   iwlwifi: mvm: fix operator precedence (2013-10-18 16:02:38 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
