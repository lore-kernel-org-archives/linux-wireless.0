Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56510 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932910AbeCSKk7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 06:40:59 -0400
From: Colin King <colin.king@canonical.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tsang-Shian Lin <thlin@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8821ae: fix spelling mistake: "Aboslute" -> "Absolute"
Date: Mon, 19 Mar 2018 10:40:54 +0000
Message-Id: <20180319104054.32564-1-colin.king@canonical.com> (sfid-20180319_114120_305879_90E0B509)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in RT_TRACE message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index b11365a5ee1f..9111ba7ff0a1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -1475,7 +1475,7 @@ void rtl8812ae_dm_txpwr_track_set_pwr(struct ieee80211_hw *hw,
 		}
 	} else if (method == MIX_MODE) {
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-			 "pDM_Odm->DefaultOfdmIndex=%d, pDM_Odm->Aboslute_OFDMSwingIdx[RFPath]=%d, RF_Path = %d\n",
+			 "pDM_Odm->DefaultOfdmIndex=%d, pDM_Odm->Absolute_OFDMSwingIdx[RFPath]=%d, RF_Path = %d\n",
 			 rtldm->default_ofdm_index,
 			 rtldm->absolute_ofdm_swing_idx[rf_path],
 			 rf_path);
@@ -1750,7 +1750,7 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 			/*Record delta swing for mix mode power tracking*/
 
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-				 "******Temp is higher and pDM_Odm->Aboslute_OFDMSwingIdx[ODM_RF_PATH_A] = %d\n",
+				 "******Temp is higher and pDM_Odm->Absolute_OFDMSwingIdx[ODM_RF_PATH_A] = %d\n",
 			rtldm->absolute_ofdm_swing_idx[RF90_PATH_A]);
 
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
@@ -1766,7 +1766,7 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 			/*Record delta swing for mix mode power tracking*/
 
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-				 "******Temp is higher and pDM_Odm->Aboslute_OFDMSwingIdx[ODM_RF_PATH_B] = %d\n",
+				 "******Temp is higher and pDM_Odm->Absolute_OFDMSwingIdx[ODM_RF_PATH_B] = %d\n",
 				 rtldm->absolute_ofdm_swing_idx[RF90_PATH_B]);
 		} else {
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
@@ -1782,7 +1782,7 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 				-1 * delta_swing_table_idx_tdown_a[delta];
 			/* Record delta swing for mix mode power tracking*/
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-				 "******Temp is lower and pDM_Odm->Aboslute_OFDMSwingIdx[ODM_RF_PATH_A] = %d\n",
+				 "******Temp is lower and pDM_Odm->Absolute_OFDMSwingIdx[ODM_RF_PATH_A] = %d\n",
 				 rtldm->absolute_ofdm_swing_idx[RF90_PATH_A]);
 
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
@@ -1799,7 +1799,7 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 			/*Record delta swing for mix mode power tracking*/
 
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-				 "******Temp is lower and pDM_Odm->Aboslute_OFDMSwingIdx[ODM_RF_PATH_B] = %d\n",
+				 "******Temp is lower and pDM_Odm->Absolute_OFDMSwingIdx[ODM_RF_PATH_B] = %d\n",
 				 rtldm->absolute_ofdm_swing_idx[RF90_PATH_B]);
 		}
 
@@ -2115,7 +2115,7 @@ void rtl8821ae_dm_txpwr_track_set_pwr(struct ieee80211_hw *hw,
 		}
 	} else if (method == MIX_MODE) {
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-			 "pDM_Odm->DefaultOfdmIndex=%d,pDM_Odm->Aboslute_OFDMSwingIdx[RFPath]=%d, RF_Path = %d\n",
+			 "pDM_Odm->DefaultOfdmIndex=%d,pDM_Odm->Absolute_OFDMSwingIdx[RFPath]=%d, RF_Path = %d\n",
 			 rtldm->default_ofdm_index,
 			 rtldm->absolute_ofdm_swing_idx[rf_path],
 			 rf_path);
@@ -2329,7 +2329,7 @@ void rtl8821ae_dm_txpower_tracking_callback_thermalmeter(
 			/*Record delta swing for mix mode power tracking*/
 
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-				 "******Temp is higher and pDM_Odm->Aboslute_OFDMSwingIdx[ODM_RF_PATH_A] = %d\n",
+				 "******Temp is higher and pDM_Odm->Absolute_OFDMSwingIdx[ODM_RF_PATH_A] = %d\n",
 				 rtldm->absolute_ofdm_swing_idx[RF90_PATH_A]);
 		} else {
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
@@ -2345,7 +2345,7 @@ void rtl8821ae_dm_txpower_tracking_callback_thermalmeter(
 				-1 * delta_swing_table_idx_tdown_a[delta];
 			/* Record delta swing for mix mode power tracking*/
 			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-				 "******Temp is lower and pDM_Odm->Aboslute_OFDMSwingIdx[ODM_RF_PATH_A] = %d\n",
+				 "******Temp is lower and pDM_Odm->Absolute_OFDMSwingIdx[ODM_RF_PATH_A] = %d\n",
 				 rtldm->absolute_ofdm_swing_idx[RF90_PATH_A]);
 		}
 
-- 
2.15.1
