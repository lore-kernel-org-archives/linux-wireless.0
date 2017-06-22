Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34334 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753584AbdFVVVh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Mordechai Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:50 +0300
Message-Id: <20170622212101.16422-15-luca@coelho.fi> (sfid-20170622_232154_616048_71D656A4)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 14/25] iwlwifi: mvm: change the firmware name loading
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechai Goodstein <mordechay.goodstein@intel.com>

The firmware moved the development from a0 MAC to z0.
z0 is using the same RFID and device ID as a0 so we only
need to switch the name.

Signed-off-by: Mordechai Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 63a4183c0de7..4634c46d1eb4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -74,7 +74,7 @@
 
 #define IWL_A000_JF_FW_PRE	"iwlwifi-Qu-a0-jf-b0-"
 #define IWL_A000_HR_FW_PRE	"iwlwifi-Qu-a0-hr-a0-"
-#define IWL_A000_HR_CDB_FW_PRE	"iwlwifi-QuIcp-a0-hrcdb-a0-"
+#define IWL_A000_HR_CDB_FW_PRE	"iwlwifi-QuIcp-z0-hrcdb-a0-"
 
 #define IWL_A000_HR_MODULE_FIRMWARE(api) \
 	IWL_A000_HR_FW_PRE "-" __stringify(api) ".ucode"
-- 
2.11.0
