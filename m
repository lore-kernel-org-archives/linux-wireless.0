Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41357
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422861AbXCOPLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2007 11:11:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Please pull http://bu3sch.de/git/wireless-dev.git for-linville
Date: Thu, 15 Mar 2007 16:08:18 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703151608.19112.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 4533da881f2d8c3e0dbb5b3dbc7a919e12438a8a:
  Andrew Morton:
        b44 warning fixes

are found in the git repository at:

  http://bu3sch.de/git/wireless-dev.git for-linville

Michael Buesch:
      ssb-ohci: Completely disable the driver on non-embedded systems
      ssb: Move and rename some files.
      ssb: Don't freeze unregistered devices.
      bcm43xx-mac80211: Rewrite of the LO feedthrough measuring statemachine.
      bcm43xx-mac80211: More LO fixes.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      bcm43xx-mac80211: Select SSB_DEBUG if bcm43xx debugging is enabled.

 drivers/net/wireless/mac80211/bcm43xx/Kconfig      |    1 
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx.h    |    5 
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_lo.c |  702 +++++++------
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_lo.h |   29 -
 .../net/wireless/mac80211/bcm43xx/bcm43xx_main.c   |    9 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.c    |  107 +-
 .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.h    |    6 
 drivers/ssb/Makefile                               |   17 
 drivers/ssb/core.c                                 | 1038 --------------------
 drivers/ssb/driver_chipcommon.c                    |  402 ++++++++
 drivers/ssb/driver_chipcommon/chipcommon.c         |  402 --------
 drivers/ssb/driver_mips/mips.c                     |  258 -----
 drivers/ssb/driver_mipscore.c                      |  258 +++++
 drivers/ssb/driver_pci/pcicore.c                   |  556 -----------
 drivers/ssb/driver_pcicore.c                       |  556 +++++++++++
 drivers/ssb/main.c                                 | 1042 ++++++++++++++++++++
 drivers/usb/host/Kconfig                           |   11 
 drivers/usb/host/ohci-ssb.c                        |    9 
 18 files changed, 2731 insertions(+), 2677 deletions(-)
 delete mode 100644 drivers/ssb/core.c
 create mode 100644 drivers/ssb/driver_chipcommon.c
 delete mode 100644 drivers/ssb/driver_chipcommon/chipcommon.c
 delete mode 100644 drivers/ssb/driver_mips/mips.c
 create mode 100644 drivers/ssb/driver_mipscore.c
 delete mode 100644 drivers/ssb/driver_pci/pcicore.c
 create mode 100644 drivers/ssb/driver_pcicore.c
 create mode 100644 drivers/ssb/main.c

-- 
Greetings Michael.
