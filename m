Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1GVFn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 22/31] ath6kl: Remove unused struct ath6kl_async_reg_io_buffer
Date: Fri, 22 Jul 2011 08:41:55 +0300
Message-ID: <1311313324-6766-24-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074331_604740_1A7CC08D)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_hif.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index 498701f..171ad63 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -63,15 +63,6 @@ struct ath6kl_irq_enable_reg {
 	u8 cntr_int_status_en;
 } __packed;
 
-/* buffers for ASYNC I/O */
-struct ath6kl_async_reg_io_buffer {
-	struct htc_packet packet;
-	u8 pad1[A_CACHE_LINE_PAD];
-	/* cache-line safe with pads around */
-	u8 buf[ATH6KL_REG_IO_BUFFER_SIZE];
-	u8 pad2[A_CACHE_LINE_PAD];
-};
-
 struct ath6kl_device {
 	spinlock_t lock;
 	u8 pad1[A_CACHE_LINE_PAD];
-- 
1.7.1

