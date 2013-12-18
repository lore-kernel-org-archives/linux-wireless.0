Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46478 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3LRUPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 15:15:17 -0500
Date: Wed, 18 Dec 2013 15:09:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2013-12-16
Message-ID: <20131218200925.GE3096@tuxdriver.com> (sfid-20131218_211522_061344_2BE2A783)
References: <1387206978.2057.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387206978.2057.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 16, 2013 at 04:16:18PM +0100, Johannes Berg wrote:
> John,
> 
> And another set for -next ...
> 
> Here I just have a collection of fixes/improvements/cleanups, very
> little really stands out apart from CSA fixes, vendor command support
> and the RCU speedups.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit 55957fb7a0b61d8ab6ff3f04e279b8fc22b738fa:
> 
>   ath9k: initialize retry chain flags in tx99 code (2013-12-11 10:56:22 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 204e35a91c4b3327b7239d7687fbd4923edbbf08:
> 
>   nl80211: add VHT support for set_bitrate_mask (2013-12-16 16:05:17 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
