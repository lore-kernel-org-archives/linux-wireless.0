Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58150 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753433AbdLUQFm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 11:05:42 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>,
        Rakesh Pillai <pillair@qti.qualcomm.com>
Subject: [PATCH v2 2/3] ath10k: Add debug mask for SNOC bus type
Date: Thu, 21 Dec 2017 21:35:21 +0530
Message-Id: <1513872322-26636-3-git-send-email-pillair@qti.qualcomm.com> (sfid-20171221_170547_434295_B0A6B141)
In-Reply-To: <1513872322-26636-1-git-send-email-pillair@qti.qualcomm.com>
References: <1513872322-26636-1-git-send-email-pillair@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Govind Singh <govinds@qti.qualcomm.com>

WCN3990 target uses SNOC bus.
Add debug mask for SNOC bus type.

Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 5e662994c49a..134fb68ae546 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -42,6 +42,7 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_SDIO_DUMP	= 0x00020000,
 	ATH10K_DBG_USB		= 0x00040000,
 	ATH10K_DBG_USB_BULK	= 0x00080000,
+	ATH10K_DBG_SNOC		= 0x00100000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
-- 
2.11.0
