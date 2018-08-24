Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbeHXOtz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:49:55 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/17] mt76: fix mt76xx-lib module license
Date: Fri, 24 Aug 2018 13:15:09 +0200
Message-Id: <1535109321-17126-6-git-send-email-sgruszka@redhat.com> (sfid-20180824_131550_231264_841EAC89)
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add module license.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76xx_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76xx_util.c b/drivers/net/wireless/mediatek/mt76/mt76xx_util.c
index 3b0f9006eaa2..82a647d8398b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76xx_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76xx_util.c
@@ -51,3 +51,5 @@ void mt76xx_configure_filter(struct ieee80211_hw *hw,
 	mutex_unlock(&dev->mutex);
 }
 EXPORT_SYMBOL_GPL(mt76xx_configure_filter);
+
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.9.3
