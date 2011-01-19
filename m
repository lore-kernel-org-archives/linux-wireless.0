Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:40702 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753883Ab1ASJUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:20:10 -0500
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0117728805
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:20:06 +0900 (JST)
Subject: [PATCH 0/8] ath5k 802.11j preparation and cleanup
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jan 2011 18:20:31 +0900
Message-ID: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series prepares ath5k for 802.11j (4.9GHz) support but most of the patches
are just cleaning up things i found in the process. 802.11j is still not
enabled.

bruno

---

Bruno Randolf (8):
      ath5k: Use mac80211 channel mapping function
      ath5k: Simplify loop when setting up channels
      ath5k: Rename ath5k_copy_channels
      ath5k: ath5k_setup_channels cleanup and whitespace
      ath5k: Add 802.11j 4.9GHz channels to allowed channels
      ath5: Remove unused CTL definitions
      ath5k: Remove unused sc->curmode
      ath5k: Remove redundant sc->curband


 drivers/net/wireless/ath/ath5k/base.c   |   95 +++++++++++--------------------
 drivers/net/wireless/ath/ath5k/base.h   |    3 -
 drivers/net/wireless/ath/ath5k/eeprom.h |   23 --------
 3 files changed, 34 insertions(+), 87 deletions(-)

-- 
Signature
