Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:36354 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbbBPFRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 00:17:20 -0500
Received: from [117.222.159.239] (port=14037 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YNE3b-000EUz-Ce
	for linux-wireless@vger.kernel.org; Mon, 16 Feb 2015 00:17:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/9] ath9k: Add new MCI configuration parameters
Date: Mon, 16 Feb 2015 10:49:55 +0530
Message-Id: <1424064001-7009-4-git-send-email-sujith@msujith.org> (sfid-20150216_061725_465312_5D4211AC)
In-Reply-To: <1424064001-7009-1-git-send-email-sujith@msujith.org>
References: <1424064001-7009-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Several new MCI parameters need to be handled for
new chips, add them.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index cef2010..e8b1914 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -92,6 +92,17 @@ enum mci_gpm_coex_bt_update_flags_op {
 #define ATH_MCI_CONFIG_CLK_DIV              0x00003000
 #define ATH_MCI_CONFIG_CLK_DIV_S            12
 #define ATH_MCI_CONFIG_DISABLE_TUNING       0x00004000
+#define ATH_MCI_CONFIG_DISABLE_AIC          0x00008000
+#define ATH_MCI_CONFIG_AIC_CAL_NUM_CHAN     0x007f0000
+#define ATH_MCI_CONFIG_AIC_CAL_NUM_CHAN_S   16
+#define ATH_MCI_CONFIG_NO_QUIET_ACK         0x00800000
+#define ATH_MCI_CONFIG_NO_QUIET_ACK_S       23
+#define ATH_MCI_CONFIG_ANT_ARCH             0x07000000
+#define ATH_MCI_CONFIG_ANT_ARCH_S           24
+#define ATH_MCI_CONFIG_FORCE_QUIET_ACK      0x08000000
+#define ATH_MCI_CONFIG_FORCE_QUIET_ACK_S    27
+#define ATH_MCI_CONFIG_FORCE_2CHAIN_ACK     0x10000000
+#define ATH_MCI_CONFIG_MCI_STAT_DBG         0x20000000
 #define ATH_MCI_CONFIG_MCI_WEIGHT_DBG       0x40000000
 #define ATH_MCI_CONFIG_DISABLE_MCI          0x80000000
 
-- 
2.3.0

