Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20060 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbcDMLOC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 07:14:02 -0400
Subject: [PATCH v2 2/5] ath10k: prefer kernel type 'u64' over 'u_int64_t'
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 13 Apr 2016 14:13:35 +0300
Message-ID: <20160413111335.18823.58746.stgit@potku.adurom.net> (sfid-20160413_131405_905468_8197AD24)
In-Reply-To: <20160413111247.18823.15952.stgit@potku.adurom.net>
References: <20160413111247.18823.15952.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warnings:

drivers/net/wireless/ath/ath10k/htt.h:1477: Prefer kernel type 'u64' over 'u_int64_t'
drivers/net/wireless/ath/ath10k/htt.h:1480: Prefer kernel type 'u64' over 'u_int64_t'

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 60bd9fe4b2d9..ee7c8f8f8073 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1475,10 +1475,10 @@ union htt_rx_pn_t {
 	u32 pn24;
 
 	/* TKIP or CCMP: 48-bit PN */
-	u_int64_t pn48;
+	u64 pn48;
 
 	/* WAPI: 128-bit PN */
-	u_int64_t pn128[2];
+	u64 pn128[2];
 };
 
 struct htt_cmd {

