Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37761
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbXERQP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 12:15:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Please pull http://bu3sch.de/git/wireless-dev.git/ for-linville
Date: Fri, 18 May 2007 18:14:00 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200705181814.00361.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 0d2d5f7a247d3d734d68f19fd0a7222807cd2b5c:
  Hong Liu:
        mac80211: fix memory leak when defrag fragments

are found in the git repository at:

  http://bu3sch.de/git/wireless-dev.git/ for-linville

Michael Buesch:
      bcm43xx-mac80211: Various PHY fixes.
      bcm43xx-mac80211: Rewrite baseband and radio attenuation adjustment.
      ssb: Set sdev->dev before registering dev
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      bcm43xx-mac80211: Rename all GPHY LO functions to avoid namespace collisions with APHY
      ssb: Fix NULL pointer dereferences in init paths.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      bcm43xx-mac80211: Enable hardware MAC-address filters.
      bcm43xx-mac80211: Read and check PHY versioning information in attach stage.

 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_lo.c |   43 ++++----
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_lo.h |   20 ++--
 .../net/wireless/mac80211/bcm43xx/bcm43xx_main.c   |   17 +--
 .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.c    |  114 +++++++++++++++--------
 drivers/ssb/main.c                                 |   27 +++--
 5 files changed, 129 insertions(+), 92 deletions(-)

-- 
Greetings Michael.
