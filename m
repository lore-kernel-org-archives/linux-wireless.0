Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37994 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbcDVNGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 09:06:42 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>, <kvalo@codeaurora.org>,
	<mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix a typo in ath10k_start()
Date: Fri, 22 Apr 2016 18:36:13 +0530
Message-ID: <1461330373-14847-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160422_150645_852841_1F26626E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

fix a typo (spelling mistake) in 'ath10k_start'

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 02edeff..20bd317 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4324,7 +4324,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	/*
 	 * This makes sense only when restarting hw. It is harmless to call
-	 * uncoditionally. This is necessary to make sure no HTT/WMI tx
+	 * unconditionally. This is necessary to make sure no HTT/WMI tx
 	 * commands will be submitted while restarting.
 	 */
 	ath10k_drain_tx(ar);
-- 
1.7.9.5

