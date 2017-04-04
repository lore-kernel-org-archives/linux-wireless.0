Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35556 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932072AbdDDQuZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:25 -0400
Received: by mail-oi0-f65.google.com with SMTP id d2so18372863oig.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:24 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/13] rtlwifi: btcoex: 23b 2ant: rename tdma_adj_type to ps_tdma_du_adj_type
Date: Tue,  4 Apr 2017 11:49:55 -0500
Message-Id: <20170404165006.14329-3-Larry.Finger@lwfinger.net> (sfid-20170404_185028_760429_8D43B6E6)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The variable is for PS tdma duration adjust, so rename it to clearly
to specify its usage.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 30 +++++++++++-----------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  2 +-
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 6f00b7e..d4bac17 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1632,34 +1632,34 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 13);
-					coex_dm->tdma_adj_type = 13;
+					coex_dm->ps_tdma_du_adj_type = 13;
 				} else if (max_interval == 2) {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 14);
-					coex_dm->tdma_adj_type = 14;
+					coex_dm->ps_tdma_du_adj_type = 14;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 15);
-					coex_dm->tdma_adj_type = 15;
+					coex_dm->ps_tdma_du_adj_type = 15;
 				}
 			} else {
 				if (max_interval == 1) {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 9);
-					coex_dm->tdma_adj_type = 9;
+					coex_dm->ps_tdma_du_adj_type = 9;
 				} else if (max_interval == 2) {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 10);
-					coex_dm->tdma_adj_type = 10;
+					coex_dm->ps_tdma_du_adj_type = 10;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 11);
-					coex_dm->tdma_adj_type = 11;
+					coex_dm->ps_tdma_du_adj_type = 11;
 				}
 			}
 		} else {
@@ -1668,34 +1668,34 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 5);
-					coex_dm->tdma_adj_type = 5;
+					coex_dm->ps_tdma_du_adj_type = 5;
 				} else if (max_interval == 2) {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 6);
-					coex_dm->tdma_adj_type = 6;
+					coex_dm->ps_tdma_du_adj_type = 6;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 7);
-					coex_dm->tdma_adj_type = 7;
+					coex_dm->ps_tdma_du_adj_type = 7;
 				}
 			} else {
 				if (max_interval == 1) {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 1);
-					coex_dm->tdma_adj_type = 1;
+					coex_dm->ps_tdma_du_adj_type = 1;
 				} else if (max_interval == 2) {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 2);
-					coex_dm->tdma_adj_type = 2;
+					coex_dm->ps_tdma_du_adj_type = 2;
 				} else {
 					btc8723b2ant_ps_tdma(btcoexist,
 							     NORMAL_EXEC,
 							     true, 3);
-					coex_dm->tdma_adj_type = 3;
+					coex_dm->ps_tdma_du_adj_type = 3;
 				}
 			}
 		}
@@ -1804,11 +1804,11 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 	/* if current PsTdma not match with the recorded one (scan, dhcp, ...),
 	 * then we have to adjust it back to the previous recorded one.
 	 */
-	if (coex_dm->cur_ps_tdma != coex_dm->tdma_adj_type) {
+	if (coex_dm->cur_ps_tdma != coex_dm->ps_tdma_du_adj_type) {
 		bool scan = false, link = false, roam = false;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], PsTdma type dismatch!!!, curPsTdma=%d, recordPsTdma=%d\n",
-			 coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
+			 coex_dm->cur_ps_tdma, coex_dm->ps_tdma_du_adj_type);
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
@@ -1816,7 +1816,7 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 
 		if (!scan && !link && !roam)
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
-					     coex_dm->tdma_adj_type);
+					     coex_dm->ps_tdma_du_adj_type);
 		else
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 5bcaece..9f41206 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -84,7 +84,7 @@ struct coex_dm_8723b_2ant {
 	u8 pre_ps_tdma;
 	u8 cur_ps_tdma;
 	u8 ps_tdma_para[5];
-	u8 tdma_adj_type;
+	u8 ps_tdma_du_adj_type;
 	bool reset_tdma_adjust;
 	bool auto_tdma_adjust;
 	bool pre_ps_tdma_on;
-- 
2.10.2
