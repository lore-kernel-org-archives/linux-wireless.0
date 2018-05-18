Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:45382 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753318AbeERJai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:30:38 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/14] rtlwifi: remove unused fw C2H command ID
Date: Fri, 18 May 2018 17:29:59 +0800
Message-ID: <20180518093007.23594-7-pkshih@realtek.com> (sfid-20180518_113126_521814_C5BD51CB)
In-Reply-To: <20180518093007.23594-1-pkshih@realtek.com>
References: <20180518093007.23594-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The IDs are defined by driver and map to the fw C2H IDs, but they aren't
used now result in removal.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8188ee/def.h   | 25 ----------------------
 .../net/wireless/realtek/rtlwifi/rtl8192ce/def.h   | 25 ----------------------
 .../net/wireless/realtek/rtlwifi/rtl8723ae/def.h   | 25 ----------------------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/def.h   | 25 ----------------------
 4 files changed, 100 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
index 32492d64d685..45c866d3ca88 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
@@ -176,31 +176,6 @@ enum interface_select_pci {
 	INTF_SEL3_RSV = 3,
 };
 
-enum hal_fw_c2h_cmd_id {
-	HAL_FW_C2H_CMD_READ_MACREG = 0,
-	HAL_FW_C2H_CMD_READ_BBREG = 1,
-	HAL_FW_C2H_CMD_READ_RFREG = 2,
-	HAL_FW_C2H_CMD_READ_EEPROM = 3,
-	HAL_FW_C2H_CMD_READ_EFUSE = 4,
-	HAL_FW_C2H_CMD_READ_CAM = 5,
-	HAL_FW_C2H_CMD_GET_BASICRATE = 6,
-	HAL_FW_C2H_CMD_GET_DATARATE = 7,
-	HAL_FW_C2H_CMD_SURVEY = 8,
-	HAL_FW_C2H_CMD_SURVEYDONE = 9,
-	HAL_FW_C2H_CMD_JOINBSS = 10,
-	HAL_FW_C2H_CMD_ADDSTA = 11,
-	HAL_FW_C2H_CMD_DELSTA = 12,
-	HAL_FW_C2H_CMD_ATIMDONE = 13,
-	HAL_FW_C2H_CMD_TX_REPORT = 14,
-	HAL_FW_C2H_CMD_CCX_REPORT = 15,
-	HAL_FW_C2H_CMD_DTM_REPORT = 16,
-	HAL_FW_C2H_CMD_TX_RATE_STATISTICS = 17,
-	HAL_FW_C2H_CMD_C2HLBK = 18,
-	HAL_FW_C2H_CMD_C2HDBG = 19,
-	HAL_FW_C2H_CMD_C2HFEEDBACK = 20,
-	HAL_FW_C2H_CMD_MAX
-};
-
 enum rtl_desc_qsel {
 	QSLT_BK = 0x2,
 	QSLT_BE = 0x0,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h
index b90aaf128072..d2005d7e9ad2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h
@@ -142,31 +142,6 @@ enum interface_select_pci {
 	INTF_SEL3_RSV = 3,
 };
 
-enum hal_fw_c2h_cmd_id {
-	HAL_FW_C2H_CMD_Read_MACREG = 0,
-	HAL_FW_C2H_CMD_Read_BBREG = 1,
-	HAL_FW_C2H_CMD_Read_RFREG = 2,
-	HAL_FW_C2H_CMD_Read_EEPROM = 3,
-	HAL_FW_C2H_CMD_Read_EFUSE = 4,
-	HAL_FW_C2H_CMD_Read_CAM = 5,
-	HAL_FW_C2H_CMD_Get_BasicRate = 6,
-	HAL_FW_C2H_CMD_Get_DataRate = 7,
-	HAL_FW_C2H_CMD_Survey = 8,
-	HAL_FW_C2H_CMD_SurveyDone = 9,
-	HAL_FW_C2H_CMD_JoinBss = 10,
-	HAL_FW_C2H_CMD_AddSTA = 11,
-	HAL_FW_C2H_CMD_DelSTA = 12,
-	HAL_FW_C2H_CMD_AtimDone = 13,
-	HAL_FW_C2H_CMD_TX_Report = 14,
-	HAL_FW_C2H_CMD_CCX_Report = 15,
-	HAL_FW_C2H_CMD_DTM_Report = 16,
-	HAL_FW_C2H_CMD_TX_Rate_Statistics = 17,
-	HAL_FW_C2H_CMD_C2HLBK = 18,
-	HAL_FW_C2H_CMD_C2HDBG = 19,
-	HAL_FW_C2H_CMD_C2HFEEDBACK = 20,
-	HAL_FW_C2H_CMD_MAX
-};
-
 enum rtl_desc_qsel {
 	QSLT_BK = 0x2,
 	QSLT_BE = 0x0,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
index bcdf2273688e..847544817549 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
@@ -152,31 +152,6 @@ enum interface_select_pci {
 	INTF_SEL3_RSV = 3,
 };
 
-enum hal_fw_c2h_cmd_id {
-	HAL_FW_C2H_CMD_Read_MACREG = 0,
-	HAL_FW_C2H_CMD_Read_BBREG = 1,
-	HAL_FW_C2H_CMD_Read_RFREG = 2,
-	HAL_FW_C2H_CMD_Read_EEPROM = 3,
-	HAL_FW_C2H_CMD_Read_EFUSE = 4,
-	HAL_FW_C2H_CMD_Read_CAM = 5,
-	HAL_FW_C2H_CMD_Get_BasicRate = 6,
-	HAL_FW_C2H_CMD_Get_DataRate = 7,
-	HAL_FW_C2H_CMD_Survey = 8,
-	HAL_FW_C2H_CMD_SurveyDone = 9,
-	HAL_FW_C2H_CMD_JoinBss = 10,
-	HAL_FW_C2H_CMD_AddSTA = 11,
-	HAL_FW_C2H_CMD_DelSTA = 12,
-	HAL_FW_C2H_CMD_AtimDone = 13,
-	HAL_FW_C2H_CMD_TX_Report = 14,
-	HAL_FW_C2H_CMD_CCX_Report = 15,
-	HAL_FW_C2H_CMD_DTM_Report = 16,
-	HAL_FW_C2H_CMD_TX_Rate_Statistics = 17,
-	HAL_FW_C2H_CMD_C2HLBK = 18,
-	HAL_FW_C2H_CMD_C2HDBG = 19,
-	HAL_FW_C2H_CMD_C2HFEEDBACK = 20,
-	HAL_FW_C2H_CMD_MAX
-};
-
 enum rtl_desc_qsel {
 	QSLT_BK = 0x2,
 	QSLT_BE = 0x0,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h
index 498f716bfc73..3fe3aaa5fe3c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h
@@ -296,31 +296,6 @@ enum interface_select_pci {
 	INTF_SEL3_RSV = 3,
 };
 
-enum hal_fw_c2h_cmd_id {
-	HAL_FW_C2H_CMD_READ_MACREG = 0,
-	HAL_FW_C2H_CMD_READ_BBREG = 1,
-	HAL_FW_C2H_CMD_READ_RFREG = 2,
-	HAL_FW_C2H_CMD_READ_EEPROM = 3,
-	HAL_FW_C2H_CMD_READ_EFUSE = 4,
-	HAL_FW_C2H_CMD_READ_CAM = 5,
-	HAL_FW_C2H_CMD_GET_BASICRATE = 6,
-	HAL_FW_C2H_CMD_GET_DATARATE = 7,
-	HAL_FW_C2H_CMD_SURVEY = 8,
-	HAL_FW_C2H_CMD_SURVEYDONE = 9,
-	HAL_FW_C2H_CMD_JOINBSS = 10,
-	HAL_FW_C2H_CMD_ADDSTA = 11,
-	HAL_FW_C2H_CMD_DELSTA = 12,
-	HAL_FW_C2H_CMD_ATIMDONE = 13,
-	HAL_FW_C2H_CMD_TX_REPORT = 14,
-	HAL_FW_C2H_CMD_CCX_REPORT = 15,
-	HAL_FW_C2H_CMD_DTM_REPORT = 16,
-	HAL_FW_C2H_CMD_TX_RATE_STATISTICS = 17,
-	HAL_FW_C2H_CMD_C2HLBK = 18,
-	HAL_FW_C2H_CMD_C2HDBG = 19,
-	HAL_FW_C2H_CMD_C2HFEEDBACK = 20,
-	HAL_FW_C2H_CMD_MAX
-};
-
 enum rtl_desc_qsel {
 	QSLT_BK = 0x2,
 	QSLT_BE = 0x0,
-- 
2.15.1
