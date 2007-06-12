Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4164 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbXFLByk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 21:54:40 -0400
Date: Mon, 11 Jun 2007 21:22:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: mac80211 patches for 2.6.23
Message-ID: <20070612012228.GG20422@tuxdriver.com>
References: <20070610.181704.73383002.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070610.181704.73383002.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

Here are a few mac80211 patches appropriate for 2.6.23.

Individual patches to follow, or you can pull at your leisure...

John

---

The following changes since commit 5ecd3100e695228ac5e0ce0e325e252c0f11806f:
  Linus Torvalds (1):
        Linux 2.6.22-rc4

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git mac80211-upstream

Larry Finger (2):
      mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
      mac80211: Set low initial rate in rc80211_simple

 net/mac80211/ieee80211_ioctl.c |   25 ++++++++++++++++++++++++-
 net/mac80211/rc80211_simple.c  |   12 +++++++-----
 2 files changed, 31 insertions(+), 6 deletions(-)

-- 
John W. Linville
linville@tuxdriver.com
