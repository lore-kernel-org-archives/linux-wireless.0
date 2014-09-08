Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40003 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaIHOvo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 10:51:44 -0400
Message-ID: <1410187894.7983.15.camel@jlt4.sipsolutions.net> (sfid-20140908_165202_201645_9230E2FF)
Subject: pull-request: mac80211 2014-09-08
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 08 Sep 2014 16:51:34 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

One more for mac80211, hopefully that should be it. If anyone thinks I
missed anything please holler. I'll have one more for mac80211-next
later this week.

Note I'm going to be on vacation soon (EOW) until early October, so if
anything super urgent shows up I'd appreciate if you could merge it for
me.

Thanks,
johannes


The following changes since commit 14b058bbce9279ee432f0944ca14df69f4a0d170:

  mac80211: fix agg_status debugfs file alignment (2014-08-26 11:13:37 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-john-2014-09-08

for you to fetch changes up to 785e21a89d77923852869f83ebd2689ec4d5ce54:

  mac80211: use bss_conf->dtim_period instead of conf.ps_dtim_period (2014-09-05 13:41:08 +0200)

----------------------------------------------------------------
Two more fixes for mac80211 - one of them addresses a long-standing
issue that we only found when using vendor events more frequently;
the other addresses some bad information being reported in userspace
that people were starting to actually look at.

----------------------------------------------------------------
Emmanuel Grumbach (1):
      mac80211: use bss_conf->dtim_period instead of conf.ps_dtim_period

Johannes Berg (1):
      nl80211: clear skb cb before passing to netlink

 net/mac80211/sta_info.c | 2 +-
 net/wireless/nl80211.c  | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)


