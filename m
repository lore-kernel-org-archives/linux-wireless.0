Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33388 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752512AbeDMHrA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 03:47:00 -0400
From: mkenna@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
Subject: [PATCH] ath10k: Fix a typo in ath10k_wmi_set_wmm_param()
Date: Fri, 13 Apr 2018 13:18:31 +0530
Message-Id: <1523605711-1874-1-git-send-email-mkenna@codeaurora.org> (sfid-20180413_094703_419516_946FA668)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maharaja Kennadyrajan <mkenna@codeaurora.org>

Fix a typo in the function ath10k_wmi_set_wmm_param().

Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c5e1ca5..727c965 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7648,7 +7648,7 @@ void ath10k_wmi_set_wmm_param(struct wmi_wmm_params *params,
 	cmd->param = __cpu_to_le32(param);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi pdev get tcp config param:%d\n", param);
+		   "wmi pdev get tpc config param %d\n", param);
 	return skb;
 }
 
-- 
1.7.9.5
