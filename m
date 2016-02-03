Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933800AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 16/28] rtl8xxxu: Fix cosmetics to quiet down checkpatch police
Date: Wed,  3 Feb 2016 13:39:50 -0500
Message-Id: <1454524802-26763-17-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194138_794059_21E5A4C9)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 94d3d84..ac4c211 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4415,7 +4415,7 @@ static void rtl8xxxu_cam_write(struct rtl8xxxu_priv *priv,
 }
 
 static void rtl8xxxu_sw_scan_start(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif, const u8* mac)
+				   struct ieee80211_vif *vif, const u8 *mac)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	u8 val8;
-- 
2.5.0

