Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160AbXK2DLX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:11:23 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 36/36] iwlwifi: update version number to 1.2.22
Date: Thu, 29 Nov 2007 11:10:16 +0800
Message-Id: <1196305816-23023-37-git-send-email-yi.zhu@intel.com> (sfid-20071129_033535_103297_3CA9AEAA)
In-Reply-To: <1196305816-23023-36-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-17-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-18-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-19-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-20-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-21-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-22-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-23-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-24-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-25-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-26-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-27-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-28-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-29-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-30-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-31-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-32-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-33-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-34-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-35-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-36-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 963d3cd..48fd1e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -91,7 +91,7 @@ int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 8 Tx queues */
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "1.1.19k" VD VS
+#define IWLWIFI_VERSION "1.2.22k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 98a394e..25fa990 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -90,7 +90,7 @@ int iwl4965_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 16 Tx queues */
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "1.1.19k" VD VS
+#define IWLWIFI_VERSION "1.2.22k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
-- 
1.5.3.6
