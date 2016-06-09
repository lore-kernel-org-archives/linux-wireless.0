Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59669 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbcFIMsH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 08:48:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2016-06-09
Date: Thu,  9 Jun 2016 14:47:57 +0200
Message-Id: <1465476478-23080-1-git-send-email-johannes@sipsolutions.net> (sfid-20160609_144817_134684_45B12F9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Here are two more fixes for the current cycle, please pull.

Let me know if there's any problem.

Thanks,
johannes



The following changes since commit 6fe04128f158c5ad27e7504bfdf1b12e63331bc9:

  mac80211: fix fast_tx header alignment (2016-05-31 12:14:04 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2016-06-09

for you to fetch changes up to 3d5fdff46c4b2b9534fa2f9fc78e90a48e0ff724:

  wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel (2016-06-09 09:56:11 +0200)

----------------------------------------------------------------
Two more fixes for now:
 * a fix for a long-standing iwpriv 32/64 compat issue
 * two fairly recently introduced (4.6) warning asking for
   symmetric operations are erroneous and I remove them

----------------------------------------------------------------
Johannes Berg (1):
      cfg80211: remove get/set antenna and tx power warnings

Prasun Maiti (1):
      wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel

 net/wireless/core.c      |  2 --
 net/wireless/wext-core.c | 25 +++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 4 deletions(-)
