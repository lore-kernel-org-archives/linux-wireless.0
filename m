Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44221 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdCNLca (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 07:32:30 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix typo in wmi header file
Date: Tue, 14 Mar 2017 17:03:24 +0530
Message-ID: <1489491204-20855-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170314_123233_440540_73FCBD1B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Fix typo(spelling mistake) in wmi.h

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 386aa51..ddbd541 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3182,7 +3182,7 @@ struct wmi_10_4_phyerr_event {
 
 struct phyerr_radar_report {
 	__le32 reg0; /* RADAR_REPORT_REG0_* */
-	__le32 reg1; /* REDAR_REPORT_REG1_* */
+	__le32 reg1; /* RADAR_REPORT_REG1_* */
 } __packed;
 
 #define RADAR_REPORT_REG0_PULSE_IS_CHIRP_MASK		0x80000000
-- 
1.9.1
