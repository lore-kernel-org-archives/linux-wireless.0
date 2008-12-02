Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:29717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbYLBAbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 19:31:31 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/5] iwlwifi: 5150 parametrize eeprom versions
Date: Mon,  1 Dec 2008 16:32:21 -0800
Message-Id: <1228177942-25137-5-git-send-email-reinette.chatre@intel.com> (sfid-20081202_013138_063600_B693BF8F)
In-Reply-To: <1228177942-25137-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228177942-25137-1-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-2-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-3-git-send-email-reinette.chatre@intel.com>
 <1228177942-25137-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Add support for 5150 eeprom versions

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 26e04ec..488b580 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1587,6 +1587,8 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 };
 
-- 
1.5.4.3

