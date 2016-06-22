Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.riverbed.com ([208.70.196.45]:31662 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbcFVNeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 09:34:44 -0400
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com
From: Eduardo Abinader <eduardo.abinader@riverbed.com>
Subject: [PATCH] ath10k: remove extra space on ath10k_update_channel_list
Message-ID: <576A93E2.9050901@riverbed.com> (sfid-20160622_153503_086840_28D4CA13)
Date: Wed, 22 Jun 2016 15:34:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

just to comply to coding style.

Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d4b7a16..d5f8e95 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2939,7 +2939,7 @@ static int ath10k_update_channel_list(struct ath10k *ar)
 			if (channel->flags & IEEE80211_CHAN_DISABLED)
 				continue;
 
-			ch->allow_ht   = true;
+			ch->allow_ht = true;
 
 			/* FIXME: when should we really allow VHT? */
 			ch->allow_vht = true;
-- 
2.5.0
