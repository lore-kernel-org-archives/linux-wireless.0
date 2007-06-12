Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4161 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695AbXFLByh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 21:54:37 -0400
Date: Mon, 11 Jun 2007 21:16:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: mac80211 fixes for 2.6.22
Message-ID: <20070612011616.GC20422@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

Here are a few mac80211 patches appropriate for 2.6.22.

Individual patches to follow, or you can pull at your leisure...

John

---

The following changes since commit 5ecd3100e695228ac5e0ce0e325e252c0f11806f:
  Linus Torvalds (1):
        Linux 2.6.22-rc4

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git mac80211-fixes

David Lamparter (1):
      cfg80211: fix signed macaddress in sysfs

Johannes Berg (1):
      mac80211: fix debugfs tx power reduction output

Mattias Nissler (1):
      mac80211: Don't stop tx queue on master device while scanning.

 net/mac80211/debugfs.c       |    2 +-
 net/mac80211/ieee80211_sta.c |   12 ++++++++++++
 net/wireless/sysfs.c         |    2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

-- 
John W. Linville
linville@tuxdriver.com
