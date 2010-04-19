Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45931 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab0DSR5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 13:57:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 3/9] ath9k: update the MCS mask for MCS16 and above
Date: Mon, 19 Apr 2010 19:57:31 +0200
Message-Id: <1271699857-12366-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1271699857-12366-2-git-send-email-nbd@openwrt.org>
References: <1271699857-12366-1-git-send-email-nbd@openwrt.org>
 <1271699857-12366-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fcbb4a8..5d3d563 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -19,7 +19,7 @@
 
 #define BITS_PER_BYTE           8
 #define OFDM_PLCP_BITS          22
-#define HT_RC_2_MCS(_rc)        ((_rc) & 0x0f)
+#define HT_RC_2_MCS(_rc)        ((_rc) & 0x1f)
 #define HT_RC_2_STREAMS(_rc)    ((((_rc) & 0x78) >> 3) + 1)
 #define L_STF                   8
 #define L_LTF                   8
-- 
1.6.4.2

