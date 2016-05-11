Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53941 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbcEKRCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:42 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 02/21] ath10k: fix typo in logging message
Date: Wed, 11 May 2016 10:02:14 -0700
Message-Id: <1462986153-16318-3-git-send-email-greearb@candelatech.com> (sfid-20160511_190246_182321_8BF97648)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0e24f9e..cd3016d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2747,7 +2747,7 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 
 	ret = ath10k_wmi_vdev_down(ar, arvif->vdev_id);
 	if (ret)
-		ath10k_warn(ar, "faield to down vdev %i: %d\n",
+		ath10k_warn(ar, "failed to down vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
 	arvif->def_wep_key_idx = -1;
-- 
2.4.3

