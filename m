Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55161 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384Ab0LCELJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 23:11:09 -0500
Received: by eye27 with SMTP id 27so4779975eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 20:11:08 -0800 (PST)
Date: Fri, 3 Dec 2010 06:11:09 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Subject: [PATCH 5/6] ath5k: Update version string
Message-ID: <20101203041109.GE2988@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Change version number, we've added various new features lately.
 We need to find a way to maintain this, maybe on each kernel release
 or something. Also remove "EXPERIMENTAL", we aren't experimental any
 more I think ;-)

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6edfa9f..835ab3a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -78,7 +78,7 @@ MODULE_AUTHOR("Nick Kossifidis");
 MODULE_DESCRIPTION("Support for 5xxx series of Atheros 802.11 wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
+MODULE_VERSION("0.7.0");
 
 static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 								bool skip_pcu);
