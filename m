Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60176 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdBBKsD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 05:48:03 -0500
Subject: [PATCH 1/3] ath10k: prefer unsigned int over just unsigned
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 2 Feb 2017 12:47:45 +0200
Message-ID: <148603246555.7275.3348416808167032391.stgit@potku.adurom.net> (sfid-20170202_114807_134990_7054C7AD)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes new checkpatch warnings:

drivers/net/wireless/ath/ath10k/htt.h:1639: Prefer 'unsigned int' to bare use of 'unsigned'
drivers/net/wireless/ath/ath10k/htt.h:1660: Prefer 'unsigned int' to bare use of 'unsigned'

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 44b25cf00553..dfe9627df7d0 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1636,7 +1636,7 @@ struct ath10k_htt {
 		int size;
 
 		/* size - 1 */
-		unsigned size_mask;
+		unsigned int size_mask;
 
 		/* how many rx buffers to keep in the ring */
 		int fill_level;
@@ -1657,7 +1657,7 @@ struct ath10k_htt {
 
 		/* where HTT SW has processed bufs filled by rx MAC DMA */
 		struct {
-			unsigned msdu_payld;
+			unsigned int msdu_payld;
 		} sw_rd_idx;
 
 		/*
