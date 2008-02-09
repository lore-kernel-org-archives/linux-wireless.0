Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53459 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbYBIAjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 19:39:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: Update iwlwifi version stamp to 1.2.26
Date: Fri,  8 Feb 2008 16:39:11 -0800
Message-Id: <1202517551-8691-1-git-send-email-reinette.chatre@intel.com> (sfid-20080209_003918_567535_AAB46688)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We update the version stamp at this time to distinguish the in-kernel
driver from the out of tree driver. The out of tree driver currently
has version number 1.2.25, but the latest driver code can only be
found in this in-kernel driver.

Having a later version number will reduce confusion between the two
versions as we transition from out of tree to in-kernel.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index b2f3a2a..c0d99ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -91,7 +91,7 @@ int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 8 Tx queues */
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "1.2.23k" VD VS
+#define IWLWIFI_VERSION "1.2.26k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3402495..3fa0bb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -90,7 +90,7 @@ int iwl4965_param_amsdu_size_8K;   /* def: enable 8K amsdu size */
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "1.2.23k" VD VS
+#define IWLWIFI_VERSION "1.2.26k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
-- 
1.5.3.4

