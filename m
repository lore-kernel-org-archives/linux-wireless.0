Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:39762 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbbISKkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 06:40:03 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: emmanuel.grumbach@intel.com
Cc: johannes.berg@intel.com, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] iwlwifi: fix requested firmware name for iwlwifi-3160
Date: Sat, 19 Sep 2015 12:39:50 +0200
Message-Id: <1442659190-6060-1-git-send-email-hauke@hauke-m.de> (sfid-20150919_124007_995516_62A820AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modinfo iwlwifi showed the following required firmware:
firmware: iwlwifi-3160-IWL3160_UCODE_API_OK.ucode

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 6951aba..bccd2d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -348,6 +348,6 @@ const struct iwl_cfg iwl7265d_n_cfg = {
 };
 
 MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
+MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3165_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
 MODULE_FIRMWARE(IWL7265D_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
-- 
2.1.4

