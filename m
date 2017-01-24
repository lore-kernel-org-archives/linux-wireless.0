Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53612 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbdAXPfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 10:35:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2017-01-24
Date: Tue, 24 Jan 2017 16:34:52 +0100
Message-Id: <20170124153453.15776-1-johannes@sipsolutions.net> (sfid-20170124_163512_028244_E6072745)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

LTP found a problem last week, but I couldn't fix it since I
was travelling, so here's the fix now.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 4078b76cac68e50ccf1f76a74e7d3d5788aec3fe:

  net: dsa: Check return value of phy_connect_direct() (2017-01-23 15:43:35 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-01-24

for you to fetch changes up to 115865fa0826ed18ca04717cf72d0fe874c0fe7f:

  mac80211: don't try to sleep in rate_control_rate_init() (2017-01-24 16:31:54 +0100)

----------------------------------------------------------------
A single fix, for a sleeping context problem found by LTP.

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: don't try to sleep in rate_control_rate_init()

 net/mac80211/rate.c | 2 --
 1 file changed, 2 deletions(-)
