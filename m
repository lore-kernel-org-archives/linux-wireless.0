Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52763
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbXBOP0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 10:26:52 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Linville, John" <linville@tuxdriver.com>
Subject: Please pull from http://bu3sch.de/git/wireless-dev.git master
Date: Thu, 15 Feb 2007 16:26:35 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702151626.35504.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit f962aa6758ad1b3df8315bb4d203947d3e638cf9:
  Johannes Berg:
        maintainers: update all wireless entries

are found in the git repository at:

  http://bu3sch.de/git/wireless-dev.git

Michael Buesch:
      bcm43xx-d80211: Fix rmmod crash. Call unregister_hw early.
      bcm43xx-d80211: Do all init work in wireless_core_init().
      ssb: Add API to properly handle bus powercontrol.
      bcm43xx-d80211: Powerdown bus after attach step to save power.
      bcm43xx-d80211: Implement card reset routine
      bcm43xx-d80211: Fix stupid locking bug on error in chip_reset.
      bcm43xx-d80211: Fix locking info text.
      Merge branch 'master' of git://zeus2.kernel.org/.../linville/wireless-dev

 drivers/net/wireless/d80211/bcm43xx/bcm43xx.h      |   15 +-
 drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c |  146 +++++++++++++-------
 drivers/ssb/core.c                                 |   44 ++++++
 drivers/ssb/driver_chipcommon/chipcommon.c         |    1 
 include/linux/ssb/ssb.h                            |    5 +
 5 files changed, 146 insertions(+), 65 deletions(-)

-- 
Greetings Michael.
