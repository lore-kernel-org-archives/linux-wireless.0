Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2477 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965700AbcDMLOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 07:14:40 -0400
Subject: [PATCH v2 5/5] ath10k: fix parenthesis alignment
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 13 Apr 2016 14:14:16 +0300
Message-ID: <20160413111416.18823.63753.stgit@potku.adurom.net> (sfid-20160413_131454_901443_638E2E23)
In-Reply-To: <20160413111247.18823.15952.stgit@potku.adurom.net>
References: <20160413111247.18823.15952.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Found by checkpatch:

drivers/net/wireless/ath/ath10k/mac.c:6800: Alignment should match open parent

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9c848eb09d2e..59ed30cab681 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6797,7 +6797,7 @@ static u64 ath10k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 }
 
 static void ath10k_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		    u64 tsf)
+			   u64 tsf)
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);

