Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbbECTd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:26 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 41/42] iwlwifi: mvm: remove some unused stuff from scan.c
Date: Sun,  3 May 2015 22:31:52 +0300
Message-Id: <1430681513-7838-41-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213356_015512_918E1D81)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Some more tidbits left over from the legacy scan removal.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 8646887..3c33d61 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -67,11 +67,8 @@
 #include <net/mac80211.h>
 
 #include "mvm.h"
-#include "iwl-eeprom-parse.h"
 #include "fw-api-scan.h"
 
-#define IWL_PLCP_QUIET_THRESH 1
-#define IWL_ACTIVE_QUIET_TIME 10
 #define IWL_DENSE_EBS_SCAN_RATIO 5
 #define IWL_SPARSE_EBS_SCAN_RATIO 1
 
@@ -107,8 +104,6 @@ struct iwl_mvm_scan_params {
 enum iwl_umac_scan_uid_type {
 	IWL_UMAC_SCAN_UID_REG_SCAN	= BIT(0),
 	IWL_UMAC_SCAN_UID_SCHED_SCAN	= BIT(1),
-	IWL_UMAC_SCAN_UID_ALL		= IWL_UMAC_SCAN_UID_REG_SCAN |
-					  IWL_UMAC_SCAN_UID_SCHED_SCAN,
 };
 
 static int iwl_umac_scan_stop(struct iwl_mvm *mvm,
-- 
2.1.0

