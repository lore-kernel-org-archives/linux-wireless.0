Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbYAOC1A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:27:00 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/12] iwlwifi: Update iwlwifi version stamp to 1.2.23
Date: Mon, 14 Jan 2008 17:46:23 -0800
Message-Id: <1200361585-31801-11-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022717_547874_5551DCA4)
In-Reply-To: <1200361585-31801-10-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-6-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-7-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-8-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-9-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c834e69..d35c0bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -91,7 +91,7 @@ int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 8 Tx queues */
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "1.2.22k" VD VS
+#define IWLWIFI_VERSION "1.2.23k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index ca7a175..b300e61 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -90,7 +90,7 @@ int iwl4965_param_amsdu_size_8K;   /* def: enable 8K amsdu size */
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "1.2.22k" VD VS
+#define IWLWIFI_VERSION "1.2.23k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
-- 
1.5.3.4

