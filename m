Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50409 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbcF2HKV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 03:10:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2016-06-29
Date: Wed, 29 Jun 2016 09:10:14 +0200
Message-Id: <1467184215-4598-1-git-send-email-johannes@sipsolutions.net> (sfid-20160629_091030_745623_EE23E06B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Another (pretty old) bug showed up, and I have a single fix for it
from Jouni; would be nice to still get it in, but it's in mesh which
seems to mostly have users who integrate everything themselves.

Let me know if there's any problem.

Thanks,
johannes



The following changes since commit 3d5fdff46c4b2b9534fa2f9fc78e90a48e0ff724:

  wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel (2016-06-09 09:56:11 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2016-06-29

for you to fetch changes up to 126e7557328a1cd576be4fca95b133a2695283ff:

  mac80211: Fix mesh estab_plinks counting in STA removal case (2016-06-28 12:39:50 +0200)

----------------------------------------------------------------
A single fix:
 * fix mesh peer link counter, decrement wasn't always done at all

----------------------------------------------------------------
Jouni Malinen (1):
      mac80211: Fix mesh estab_plinks counting in STA removal case

 net/mac80211/mesh.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
