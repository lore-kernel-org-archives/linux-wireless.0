Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 20/28] rtl8xxxu: Fix 80 character per line issue
Date: Wed,  3 Feb 2016 13:39:54 -0500
Message-Id: <1454524802-26763-21-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194804_046149_2A787271)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 78683b5..9f89f62 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5355,8 +5355,9 @@ static void rtl8xxxu_configure_filter(struct ieee80211_hw *hw,
 
 	rtl8xxxu_write32(priv, REG_RCR, rcr);
 
-	*total_flags &= (FIF_ALLMULTI | FIF_FCSFAIL | FIF_BCN_PRBRESP_PROMISC | \
-			 FIF_CONTROL | FIF_OTHER_BSS | FIF_PSPOLL | FIF_PROBE_REQ);
+	*total_flags &= (FIF_ALLMULTI | FIF_FCSFAIL | FIF_BCN_PRBRESP_PROMISC |
+			 FIF_CONTROL | FIF_OTHER_BSS | FIF_PSPOLL |
+			 FIF_PROBE_REQ);
 }
 
 static int rtl8xxxu_set_rts_threshold(struct ieee80211_hw *hw, u32 rts)
-- 
2.5.0

