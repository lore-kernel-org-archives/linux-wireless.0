Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:49298 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbYGXQXC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 12:23:02 -0400
From: Helmut Schaa <hschaa@suse.de>
To: linville@tuxdriver.com
Subject: [PATCH] ath5k: remove obsolete declaration of struct ieee80211_hw_mode
Date: Thu, 24 Jul 2008 18:22:55 +0200
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807241822.55692.hschaa@suse.de> (sfid-20080724_182307_066097_88071023)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Helmut Schaa <hschaa@suse.de>
---

diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
index 2cf8d18..ffc5293 100644
--- a/drivers/net/wireless/ath5k/debug.h
+++ b/drivers/net/wireless/ath5k/debug.h
@@ -63,7 +63,6 @@
 
 struct ath5k_softc;
 struct ath5k_hw;
-struct ieee80211_hw_mode;
 struct sk_buff;
 struct ath5k_buf;
 
