Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45771 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932611AbbIUVB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:58 +0300
Message-Id: <1442869141-31637-18-git-send-email-luca@coelho.fi> (sfid-20150921_230134_059170_2FAEAF0D)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 18/21] iwlwifi: mvm: remove some unused defines from RX API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Remove some unused values from the RX API; these were used
with older firmware API that didn't have the RX energy API,
support for which was removed a long time ago.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index cd293d2..54db515 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1080,23 +1080,6 @@ struct iwl_hs20_roc_res {
 #define IWL_RX_INFO_ENERGY_ANT_B_POS 8
 #define IWL_RX_INFO_ENERGY_ANT_C_POS 16
 
-#define IWL_RX_INFO_AGC_IDX 1
-#define IWL_RX_INFO_RSSI_AB_IDX 2
-#define IWL_OFDM_AGC_A_MSK 0x0000007f
-#define IWL_OFDM_AGC_A_POS 0
-#define IWL_OFDM_AGC_B_MSK 0x00003f80
-#define IWL_OFDM_AGC_B_POS 7
-#define IWL_OFDM_AGC_CODE_MSK 0x3fe00000
-#define IWL_OFDM_AGC_CODE_POS 20
-#define IWL_OFDM_RSSI_INBAND_A_MSK 0x00ff
-#define IWL_OFDM_RSSI_A_POS 0
-#define IWL_OFDM_RSSI_ALLBAND_A_MSK 0xff00
-#define IWL_OFDM_RSSI_ALLBAND_A_POS 8
-#define IWL_OFDM_RSSI_INBAND_B_MSK 0xff0000
-#define IWL_OFDM_RSSI_B_POS 16
-#define IWL_OFDM_RSSI_ALLBAND_B_MSK 0xff000000
-#define IWL_OFDM_RSSI_ALLBAND_B_POS 24
-
 /**
  * struct iwl_rx_phy_info - phy info
  * (REPLY_RX_PHY_CMD = 0xc0)
-- 
2.5.1

