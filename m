Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39536 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753741AbeASGqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 01:46:24 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/10] rtlwifi: Add ratr_table for newer IC
Date: Fri, 19 Jan 2018 14:45:50 +0800
Message-ID: <20180119064551.10084-10-pkshih@realtek.com> (sfid-20180119_074640_599442_21FF35C0)
In-Reply-To: <20180119064551.10084-1-pkshih@realtek.com>
References: <20180119064551.10084-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

New generation ICs will support 11ac, 5G, n-NSS, etc, so we define a set of
rate ID.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 111f81b44c1b..2d8e96896f49 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -873,6 +873,24 @@ enum ratr_table_mode {
 	RATR_INX_WIRELESS_AC_24N = 9,
 };
 
+enum ratr_table_mode_new {
+	RATEID_IDX_BGN_40M_2SS = 0,
+	RATEID_IDX_BGN_40M_1SS = 1,
+	RATEID_IDX_BGN_20M_2SS_BN = 2,
+	RATEID_IDX_BGN_20M_1SS_BN = 3,
+	RATEID_IDX_GN_N2SS = 4,
+	RATEID_IDX_GN_N1SS = 5,
+	RATEID_IDX_BG = 6,
+	RATEID_IDX_G = 7,
+	RATEID_IDX_B = 8,
+	RATEID_IDX_VHT_2SS = 9,
+	RATEID_IDX_VHT_1SS = 10,
+	RATEID_IDX_MIX1 = 11,
+	RATEID_IDX_MIX2 = 12,
+	RATEID_IDX_VHT_3SS = 13,
+	RATEID_IDX_BGN_3SS = 14,
+};
+
 enum rtl_link_state {
 	MAC80211_NOLINK = 0,
 	MAC80211_LINKING = 1,
-- 
2.15.1
