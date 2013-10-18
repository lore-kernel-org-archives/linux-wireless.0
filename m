Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:63292 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab3JRKIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 06:08:09 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/2] ath10k: extend number of AP interfaces for 10.X firmware
Date: Fri, 18 Oct 2013 12:07:58 +0200
Message-ID: <1382090878-22216-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20131018_120814_000243_054067DD)
In-Reply-To: <1382090878-22216-1-git-send-email-bartosz.markowski@tieto.com>
References: <1382090878-22216-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This firmware can support up to 8 AP interfaces.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index af046c4..dc65dcd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3255,7 +3255,7 @@ static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
 	.types	= BIT(NL80211_IFTYPE_STATION)
 	},
 	{
-	.max	= 7,
+	.max	= 8,
 	.types	= BIT(NL80211_IFTYPE_AP)
 	},
 };
-- 
1.7.10

