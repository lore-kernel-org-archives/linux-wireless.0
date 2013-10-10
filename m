Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42224 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3JJRpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 13:45:10 -0400
Date: Thu, 10 Oct 2013 13:41:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-10-07
Message-ID: <20131010174115.GD2691@tuxdriver.com> (sfid-20131010_194518_041308_EA8E3BB9)
References: <1381139513.13586.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381139513.13586.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 07, 2013 at 11:51:53AM +0200, Johannes Berg wrote:
> John,
> 
> First pull request for new features - sorry it's so late.
> 
> We have an assortment of cleanups and new features, of which the biggest
> one is probably the channel-switch support in IBSS. Nothing else really
> stands out much.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:
> 
>   Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 7578d57520f51093f590d68e16965e2714e69747:
> 
>   mac80211: implement STA CSA for drivers using channel contexts (2013-10-02 18:18:23 +0200)
> 
> ----------------------------------------------------------------
> Arik Nemtsov (1):
>       mac80211: implement STA CSA for drivers using channel contexts
> 
> Eliad Peller (2):
>       mac80211: fix some snprintf misuses
>       ieee80211: fix vht cap definitions
> 
> Fred Zhou (2):
>       mac80211: use exact-size allocation for authentication frame
>       mac80211: improve default WMM parameter setting
> 
> Janusz Dziedzic (1):
>       cfg80211: parse dfs region for internal regdb option
> 
> Johannes Berg (4):
>       mac80211: add ieee80211_iterate_active_interfaces_rtnl()
>       mac80211: use ERR_CAST()
>       mac80211: add explicit IBSS driver operations
>       regulatory: enable channels 52-64 and 100-144 for world roaming
> 
> Lorenzo Bianconi (2):
>       mac80211: add fixed_rate management to minstrel rc
>       mac80211: do not override fixed_rate_idx in minstrel_ht_update_stats
> 
> Michal Kazior (1):
>       mac80211: support reporting A-MSDU subframes individually
> 
> Sergey Ryazanov (1):
>       mac80211: Remove superfluous is_multicast_ether_addr() call
> 
> Simon Wunderlich (7):
>       cfg80211: export cfg80211_chandef_dfs_required
>       mac80211: split off channel switch parsing function
>       mac80211: split off ibss disconnect
>       mac80211: add support for CSA in IBSS mode
>       mac80211: send a CSA action frame when changing channel
>       nl80211: enable IBSS support for channel switch announcements
>       nl80211: allow CAC only if no operation is going on
> 
> Stanislaw Gruszka (1):
>       mac80211: change beacon/connection polling
> 
> cedric Voncken (1):
>       cfg80211: vlan priority handling in WMM

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
