Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6010 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbbC3I3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:29:20 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5/5] wil6210: update FW file name
Date: Mon, 30 Mar 2015 11:28:54 +0300
Message-Id: <1427704134-30699-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150330_102930_219929_FAC6CAAE)
In-Reply-To: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware "board" file name has changed from wil6210.board
to wil6210.brd by the FW generation tools.

Reflect this in the driver.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f4681e3..abb2080 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -33,7 +33,7 @@ extern bool debug_fw;
 
 #define WIL_NAME "wil6210"
 #define WIL_FW_NAME "wil6210.fw" /* code */
-#define WIL_FW2_NAME "wil6210.board" /* board & radio parameters */
+#define WIL_FW2_NAME "wil6210.brd" /* board & radio parameters */
 
 #define WIL_MAX_BUS_REQUEST_KBPS 800000 /* ~6.1Gbps */
 
-- 
2.1.0

