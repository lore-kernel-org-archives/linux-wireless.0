Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46045 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJ0RpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 13:45:09 -0400
Date: Mon, 27 Oct 2014 13:39:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-10-23
Message-ID: <20141027173945.GD28300@tuxdriver.com> (sfid-20141027_184518_873113_3E85A14A)
References: <1414089336.1926.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414089336.1926.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2014 at 08:35:36PM +0200, Johannes Berg wrote:
> John,
> 
> Please pull the below changes for the current 3.18 preparations. More
> details below.
> 
> Thanks,
> johannes
> 
> ---
> 
> The following changes since commit
> 35a9ad8af0bb0fa3525e6d0d20e32551d226f38e:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2014-10-08 21:40:54 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
> tags/mac80211-for-john-2014-10-23
> 
> for you to fetch changes up to 11b2357d5dbce999803e9055f8c09829a8a87db4:
> 
>   mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats
> (2014-10-20 16:37:01 +0200)
> 
> ----------------------------------------------------------------
> Here are a few fixes for the wireless stack: one fixes the
> RTS rate, one for a debugfs file, one to return the correct
> channel to userspace, a sanity check for a userspace value
> and the remaining two are just documentation fixes.
> 
> ----------------------------------------------------------------
> Fabian Frederick (1):
>       net: rfkill: kernel-doc warning fixes
> 
> Karl Beldan (2):
>       mac80211: fix typo in starting baserate for rts_cts_rate_idx
>       mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats
> 
> Liad Kaufman (1):
>       mac80211: fix warning on htmldocs for last_tdls_pkt_time
> 
> Luciano Coelho (2):
>       mac80211: return the vif's chandef in ieee80211_cfg_get_channel()
>       nl80211: sanity check the channel switch counter value
> 
>  net/mac80211/cfg.c                         |  2 +-
>  net/mac80211/rate.c                        |  2 +-
>  net/mac80211/rc80211_minstrel_debugfs.c    | 12 +++++++-----
>  net/mac80211/rc80211_minstrel_ht_debugfs.c | 13 ++++++++-----
>  net/mac80211/sta_info.h                    |  1 +
>  net/rfkill/core.c                          |  4 ++--
>  net/wireless/nl80211.c                     | 10 +++++++++-
>  7 files changed, 29 insertions(+), 15 deletions(-)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
