Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36170 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752223AbdI2Qog (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:44:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:07 +0300
Message-Id: <20170929164423.23666-3-luca@coelho.fi> (sfid-20170929_200759_181614_4B195C98)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
Subject: [PATCH 02/18] iwlwifi: fw: api: remove excess enum value documentation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These enum values don't exist, so remove their documentation as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h b/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
index af369eba3795..dc40cbd52f92 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/sta.h
@@ -68,9 +68,6 @@
  * @STA_FLG_REDUCED_TX_PWR_DATA: reduced TX power (data frames)
  * @STA_FLG_DISABLE_TX: set if TX should be disabled
  * @STA_FLG_PS: set if STA is in Power Save
- * @STA_FLG_INVALID: set if STA is invalid
- * @STA_FLG_DLP_EN: Direct Link Protocol is enabled
- * @STA_FLG_SET_ALL_KEYS: the current key applies to all key IDs
  * @STA_FLG_DRAIN_FLOW: drain flow
  * @STA_FLG_PAN: STA is for PAN interface
  * @STA_FLG_CLASS_AUTH: station is authenticated
@@ -100,7 +97,6 @@
  * @STA_FLG_MIMO_EN_SISO: no support for MIMO
  * @STA_FLG_MIMO_EN_MIMO2: 2 streams supported
  * @STA_FLG_MIMO_EN_MIMO3: 3 streams supported
- * @STA_FLG_MFP_EN: Management Frame Protection
  * @STA_FLG_AGG_MPDU_DENS_MSK: A-MPDU density (mask)
  * @STA_FLG_AGG_MPDU_DENS_SHIFT: A-MPDU density (bit shift)
  * @STA_FLG_AGG_MPDU_DENS_2US: A-MPDU density (2 usec gap)
-- 
2.14.1
