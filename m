Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:4607 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752024AbdLULPG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 06:15:06 -0500
From: Rakesh Pillai <pillair@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>,
        Rakesh Pillai <pillair@qti.qualcomm.com>
Subject: [PATCH 2/3] ath10k: Add debug mask for SNOC bus type
Date: Thu, 21 Dec 2017 16:44:46 +0530
Message-Id: <1513854887-10759-3-git-send-email-pillair@qti.qualcomm.com> (sfid-20171221_121523_313435_307D0C7C)
In-Reply-To: <1513854887-10759-1-git-send-email-pillair@qti.qualcomm.com>
References: <1513854887-10759-1-git-send-email-pillair@qti.qualcomm.com>
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
index 548ad5483a4a..fc983fdcaee3 100644
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
