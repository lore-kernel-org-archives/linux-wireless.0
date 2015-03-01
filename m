Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbbCATcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:01 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/31] iwlwifi: mvm: increase the number of PAPD channel groups to 9
Date: Sun,  1 Mar 2015 21:31:19 +0200
Message-Id: <1425238304-498-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203206_464031_31B9D90B)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Newer devices have more PAPD channel groups.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-phy-db.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
index d4fb5ca..e893c6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
@@ -72,7 +72,7 @@
 #include "iwl-trans.h"
 
 #define CHANNEL_NUM_SIZE	4	/* num of channels in calib_ch size */
-#define IWL_NUM_PAPD_CH_GROUPS	7
+#define IWL_NUM_PAPD_CH_GROUPS	9
 #define IWL_NUM_TXP_CH_GROUPS	9
 
 struct iwl_phy_db_entry {
-- 
1.9.1

