Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbeFEMg6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 08:36:58 -0400
From: Govind Singh <govinds@codeaurora.org>
To: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 4/6] ath10k: Add debug mask for QMI layer
Date: Tue,  5 Jun 2018 18:06:51 +0530
Message-Id: <20180605123651.1589-1-govinds@codeaurora.org> (sfid-20180605_143701_924148_DC917282)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add debug mask to control debug info of ath10k qmi
messaging layer.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 0afca5c106b6..a2f84fdb9131 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -44,6 +44,7 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_USB		= 0x00040000,
 	ATH10K_DBG_USB_BULK	= 0x00080000,
 	ATH10K_DBG_SNOC		= 0x00100000,
+	ATH10K_DBG_QMI		= 0x00200000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
-- 
2.17.0
