Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42657
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbXDWT7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 15:59:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Linville, John" <linville@tuxdriver.com>
Subject: Please pull from http://bu3sch.de/git/wireless-dev.git/ for-linville
Date: Mon, 23 Apr 2007 21:58:31 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200704232158.31599.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 45dd8a7fad4145243dcc4391e80c73c21623ed91:
  Michael Wu:
        mac80211: remove ieee80211_netif_oper from mac80211.h

are found in the git repository at:

  http://bu3sch.de/git/wireless-dev.git/ for-linville

Larry Finger:
      bcm43xx-mac80211: Fix error in initiallizing max RSSI and max signal
      bcm43xx-mac80211: Fix machine checks on PPC with rev 1 PHYs
      bcm43xx-mac80211: Fix machine check on PPC for phy->rev == 1
      bcm43xx-mac80211: Fix machine check on PPC for phy->rev == 1
      bcm43xx-mac80211: Fix machine check on PPC for phy->rev == 1

Michael Buesch:
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      bcm43xx-mac80211: Use fallback rate from mac80211
      ssb: Fix some error path cleanup bugs.
      ssb: Code cleanup: Move printk to the specific register funcs.
      bcm43xx-mac80211: Setting phy->gmode in wireless_core_reset is redundant.
      bcm43xx-mac80211: Add parenthesis around bitwise ops.
      bcm43xx-mac80211: Add HW-RNG support.
      bcm43xx-mac80211: Workaround: Disable gmode in early PHY init for PHY rev == 1
      bcm43xx-mac80211: Fix typo in agcsetup
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev

Will Dyson:
      bcm43xx-mac80211: Catch dma mapping failures.
      bcm43xx-mac80211: Fix error path memory leak
      bcm43xx-mac80211: Work around 30bit DMA limitation

 drivers/net/wireless/mac80211/bcm43xx/Kconfig      |    1 
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx.h    |   14 ++
 .../net/wireless/mac80211/bcm43xx/bcm43xx_dma.c    |  106 ++++++++++++++++--
 .../net/wireless/mac80211/bcm43xx/bcm43xx_main.c   |   61 +++++++++-
 .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.c    |  136 ++++++++++++++---------
 .../net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c   |   40 +++----
 drivers/ssb/main.c                                 |   35 ++---
 drivers/ssb/pci.c                                  |    7 +
 8 files changed, 280 insertions(+), 120 deletions(-)

-- 
Greetings Michael.
