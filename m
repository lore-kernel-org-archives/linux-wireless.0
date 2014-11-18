Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34947 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbaKRVvL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 16:51:11 -0500
Message-ID: <1416347463.1939.9.camel@sipsolutions.net> (sfid-20141118_225117_221358_D8E42AB8)
Subject: pull-request: mac80211 2014-11-18
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 18 Nov 2014 22:51:03 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

And another patch, I'm a bit surprised nobody found this issue before.

johannes

The following changes since commit 4f031fa9f188b2b0641ac20087d9e16bcfb4e49d:

  mac80211: Fix regression that triggers a kernel BUG with CCMP (2014-11-06 12:42:22 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-john-2014-11-18

for you to fetch changes up to 280ba51d60be6f4ca3347eaa60783314f38df72e:

  mac80211: minstrel_ht: fix a crash in rate sorting (2014-11-18 22:39:16 +0100)

----------------------------------------------------------------
Here's another last minute fix, for minstrel HT crashing
depending on the value of some uninitialised stack.

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: minstrel_ht: fix a crash in rate sorting

 net/mac80211/rc80211_minstrel_ht.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)


