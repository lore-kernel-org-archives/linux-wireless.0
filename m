Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35977
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161322AbXBUQD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 11:03:57 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Please pull http://bu3sch.de/git/wireless-dev.git for-linville
Date: Wed, 21 Feb 2007 17:00:36 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702211700.36555.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 17e0264113fcf465d0712ce492c6a546d207d786:
  Michael Wu:
        d80211: Fix ieee80211_ptr check

are found in the git repository at:

  git pull http://bu3sch.de/git/wireless-dev.git for-linville

Michael Buesch:
      ssb: Add sysfs file to read/write the SPROM on PCI devices.
      ssb: Ignore additional 802.11 cores on devices with dangling pins on those cores.
      bcm43xx-d80211: Ignore any A-PHY, as we don't support it, yet.
      bcm43xx-d80211: Add "is-running" checks on core_stop and core_exit.
      bcm43xx-d80211: Remove unneeded SHUTTINGDOWN and RESTARTING flags.
      bcm43xx-d80211: Hold firmware in memory until we rmmod the module.
      bcm43xx-d80211: Move firmware pointers to bcm43xx_wldev, where they belong.
      ssb: Also check for PCI vendor ID, not just PCI device ID.
      bcm43xx-d80211: Add modparam to keep bad frames in monitor mode.
      ssb: Take care of changed REJECT bit in new backplane revisions.
      bcm43xx-d80211: Turn the Radio and Analog off on core-exit and attach-finish.
      bcm43xx-d80211: Set GMODE-MACCTL, if we are operating in GMODE.
      bcm43xx-d80211: Fix register write for !GPHY.
      Merge branch 'master' of git://zeus2.kernel.org/.../linville/wireless-dev
      Merge branch 'master' of git://zeus2.kernel.org/.../linville/wireless-dev

 drivers/net/wireless/d80211/bcm43xx/bcm43xx.h      |   19 +-
 drivers/net/wireless/d80211/bcm43xx/bcm43xx_lo.c   |    2 
 drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c |  179 ++++++++++---------
 drivers/ssb/core.c                                 |  118 +++++++++++-
 drivers/ssb/pci.c                                  |  189 ++++++++++++++++++++
 drivers/ssb/scan.c                                 |   38 ++++
 drivers/ssb/ssb_private.h                          |    9 +
 include/linux/ssb/ssb.h                            |    4 
 include/linux/ssb/ssb_regs.h                       |    3 
 9 files changed, 449 insertions(+), 112 deletions(-)

-- 
Greetings Michael.
