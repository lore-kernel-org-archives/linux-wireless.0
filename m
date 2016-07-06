Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33504 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753823AbcGFKpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:45:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:31 +0300
Message-Id: <1467801651-1816-36-git-send-email-luca@coelho.fi> (sfid-20160706_124546_863363_B1B54625)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 36/56] iwlwifi: mvm: fix coex related comments
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Those comments were wrong, fix them.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index a63f5bb..07fc981 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -615,8 +615,8 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	 * don't reduce the Tx power if one of these is true:
 	 *  we are in LOOSE
 	 *  single share antenna product
-	 *  BT is active
-	 *  we are associated
+	 *  BT is inactive
+	 *  we are not associated
 	 */
 	if (iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT ||
 	    mvm->cfg->bt_shared_single_ant || !vif->bss_conf.assoc ||
-- 
2.8.1

