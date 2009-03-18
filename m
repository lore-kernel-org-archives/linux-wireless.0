Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57755 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZCREq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/13] iwl3945: fix checkpatch.pl errors
Date: Tue, 17 Mar 2009 21:51:50 -0700
Message-Id: <1237351913-19202-11-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054711_732520_C2DF5A0F)
In-Reply-To: <1237351913-19202-10-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-8-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-9-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch fixes two checkpatch.pl errors.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 50c61ed..d03f553 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1179,7 +1179,7 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 	IWL_DEBUG_INFO(priv, "HW Revision ID = 0x%X\n", rev_id);
 
 	rc = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
-	if(rc)
+	if (rc)
 		return rc;
 
 	priv->cfg->ops->lib->apm_ops.config(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d653ff8..ab6a7d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -560,7 +560,7 @@ static int iwl3945_set_dynamic_key(struct iwl_priv *priv,
 		ret = iwl3945_set_wep_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	default:
-		IWL_ERR(priv,"Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
+		IWL_ERR(priv, "Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
 		ret = -EINVAL;
 	}
 
-- 
1.5.6.3

