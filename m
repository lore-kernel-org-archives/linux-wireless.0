Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51274 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaIITAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 15:00:09 -0400
Date: Tue, 9 Sep 2014 14:46:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-09-08
Message-ID: <20140909184604.GK29412@tuxdriver.com> (sfid-20140909_210017_151631_F4F4D929)
References: <1410187894.7983.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1410187894.7983.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:51:34PM +0200, Johannes Berg wrote:
> Hi John,
> 
> One more for mac80211, hopefully that should be it. If anyone thinks I
> missed anything please holler. I'll have one more for mac80211-next
> later this week.
> 
> Note I'm going to be on vacation soon (EOW) until early October, so if
> anything super urgent shows up I'd appreciate if you could merge it for
> me.
> 
> Thanks,
> johannes
> 
> 
> The following changes since commit 14b058bbce9279ee432f0944ca14df69f4a0d170:
> 
>   mac80211: fix agg_status debugfs file alignment (2014-08-26 11:13:37 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-john-2014-09-08
> 
> for you to fetch changes up to 785e21a89d77923852869f83ebd2689ec4d5ce54:
> 
>   mac80211: use bss_conf->dtim_period instead of conf.ps_dtim_period (2014-09-05 13:41:08 +0200)
> 
> ----------------------------------------------------------------
> Two more fixes for mac80211 - one of them addresses a long-standing
> issue that we only found when using vendor events more frequently;
> the other addresses some bad information being reported in userspace
> that people were starting to actually look at.
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       mac80211: use bss_conf->dtim_period instead of conf.ps_dtim_period
> 
> Johannes Berg (1):
>       nl80211: clear skb cb before passing to netlink

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
