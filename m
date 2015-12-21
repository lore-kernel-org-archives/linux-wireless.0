Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbbLUUwS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:18 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/45] iwlwifi: 9000: increase the number of queues
Date: Mon, 21 Dec 2015 22:50:30 +0200
Message-Id: <1450731046-2796-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220058_188556_BAC61808)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

9000 family devices have 31 queues.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index a784bb6..0d2aa1d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -83,7 +83,7 @@
 
 static const struct iwl_base_params iwl9000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_9000,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_queues = 31,
 	.pll_cfg_val = 0,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
-- 
2.5.0

