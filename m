Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52326 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbeADO4i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 09:56:38 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-01-04
Date: Thu,  4 Jan 2018 15:56:31 +0100
Message-Id: <20180104145632.9866-1-johannes@sipsolutions.net> (sfid-20180104_155650_292414_B0948518)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

It's probably getting quite late for the current cycle, but
these fixes seemed important enough to send them to you
separately anyway.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 820d1d5eba5e0db88432f4b19149d87523ee193c:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue (2018-01-03 13:49:24 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-01-04

for you to fetch changes up to 736a80bbfda709fb3631f5f62056f250a38e5804:

  mac80211: mesh: drop frames appearing to be from us (2018-01-04 15:51:53 +0100)

----------------------------------------------------------------
Two fixes:
 * drop mesh frames appearing to be from ourselves
 * check another netlink attribute for existence

----------------------------------------------------------------
Hao Chen (1):
      nl80211: Check for the required netlink attribute presence

Johannes Berg (1):
      mac80211: mesh: drop frames appearing to be from us

 net/mac80211/rx.c      | 2 ++
 net/wireless/nl80211.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)
