Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728533AbeIFNzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:55:12 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 40/42] mt76x0: remove unused mt76x0_wcid
Date: Thu,  6 Sep 2018 11:18:56 +0200
Message-Id: <1536225538-16454-41-git-send-email-sgruszka@redhat.com> (sfid-20180906_112051_542138_553E2CF9)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not use mt76x0_wcid any longer.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index d775d9951695..31267a180573 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -112,15 +112,6 @@ struct mt76x0_dev {
 	struct mac_stats stats;
 };
 
-struct mt76x0_wcid {
-	u8 idx;
-	u8 hw_key_idx;
-
-	u16 tx_rate;
-	bool tx_rate_set;
-	u8 tx_rate_nss;
-};
-
 extern const struct ieee80211_ops mt76x0_ops;
 
 static inline bool is_mt7610e(struct mt76x0_dev *dev)
-- 
2.7.5
