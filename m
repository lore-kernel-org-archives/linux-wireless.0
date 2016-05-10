Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40592 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751662AbcEJUIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:08:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:03 +0300
Message-Id: <1462910797-20303-7-git-send-email-luca@coelho.fi> (sfid-20160510_220837_083594_34E708DF)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 07/41] iwlwifi: mvm: add firmware API name comment
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the firmware API name to the struct iwl_wowlan_gtk_status.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
index eec52c5..5f22cc7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
@@ -368,7 +368,7 @@ struct iwl_wowlan_gtk_status {
 	u8 decrypt_key[16];
 	u8 tkip_mic_key[8];
 	struct iwl_wowlan_rsc_tsc_params_cmd rsc;
-} __packed;
+} __packed; /* WOWLAN_GTK_MATERIAL_VER_1 */
 
 struct iwl_wowlan_status {
 	struct iwl_wowlan_gtk_status gtk;
-- 
2.8.1

