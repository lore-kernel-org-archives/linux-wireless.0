Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21232 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbcCXOXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 10:23:49 -0400
Subject: [PATCH 2/4] ath10k: prefer kernel type 'u64' over 'u_int64_t'
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 24 Mar 2016 16:23:37 +0200
Message-ID: <20160324142337.15808.26266.stgit@potku.adurom.net> (sfid-20160324_152352_343660_743028F1)
In-Reply-To: <20160324142217.15808.22638.stgit@potku.adurom.net>
References: <20160324142217.15808.22638.stgit@potku.adurom.net>
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
index d196bcc50e50..71d69d0c1960 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1474,10 +1474,10 @@ union htt_rx_pn_t {
 	u32 pn24;
 
 	/* TKIP or CCMP: 48-bit PN */
-	u_int64_t pn48;
+	u64 pn48;
 
 	/* WAPI: 128-bit PN */
-	u_int64_t pn128[2];
+	u64 pn128[2];
 };
 
 struct htt_cmd {

