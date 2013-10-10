Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42028 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab3JJRaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 13:30:15 -0400
Date: Thu, 10 Oct 2013 13:20:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-10-09
Message-ID: <20131010172006.GB2691@tuxdriver.com> (sfid-20131010_193020_199288_EF93DF52)
References: <1381302673.14186.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381302673.14186.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 09, 2013 at 09:11:13AM +0200, Johannes Berg wrote:
> John,
> 
> Another pull request for mac80211 fixes ...
> 
> Jouni fixes a remain-on-channel vs. scan bug, and Felix fixes client TX
> probing on VLANs.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit aa5f66d5a1df1c2b04bccdcb19711675c765d7c4:
> 
>   cfg80211: fix sysfs registration race (2013-09-26 20:03:45 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 22c4ceed0184318ec5a6182c6d75d398452c2e39:
> 
>   mac80211: Run deferred scan if last roc_list item is not started (2013-09-30 12:36:56 +0200)
> 
> ----------------------------------------------------------------
> Felix Fietkau (2):
>       mac80211: use sta_info_get_bss() for nl80211 tx and client probing
>       mac80211: update sta->last_rx on acked tx frames
> 
> Jouni Malinen (1):
>       mac80211: Run deferred scan if last roc_list item is not started
> 
>  net/mac80211/cfg.c        | 2 +-
>  net/mac80211/offchannel.c | 2 ++
>  net/mac80211/status.c     | 3 +++
>  net/mac80211/tx.c         | 3 ++-
>  4 files changed, 8 insertions(+), 2 deletions(-)
> 

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
