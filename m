Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966214AbbBCHPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:20 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/19] iwlwifi: mvm: reduce quota threshold
Date: Tue,  3 Feb 2015 09:14:38 +0200
Message-Id: <1422947678-16917-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081526_826381_9533F903)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The quota threshold should be reduced to 4 to update the
firmware more frequently.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index d91c46b..beba375 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -99,7 +99,7 @@
 #define IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS	30
 #define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
 #define IWL_MVM_FW_BCAST_FILTER_PASS_ALL	0
-#define IWL_MVM_QUOTA_THRESHOLD			8
+#define IWL_MVM_QUOTA_THRESHOLD			4
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
 #define IWL_MVM_RS_DISABLE_P2P_MIMO		0
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
-- 
1.9.1

