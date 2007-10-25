Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbXJYJXA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:23:00 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 23/30] iwlwifi: Update iwlwifi version stamp to 1.1.18
Date: Thu, 25 Oct 2007 17:15:44 +0800
Message-Id: <11933037851697-git-send-email-yi.zhu@intel.com> (sfid-20071025_104102_205523_D8F092AD)
In-Reply-To: <11933037831480-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
 <11933037743841-git-send-email-yi.zhu@intel.com>
 <11933037762104-git-send-email-yi.zhu@intel.com>
 <11933037784073-git-send-email-yi.zhu@intel.com>
 <11933037794199-git-send-email-yi.zhu@intel.com>
 <11933037812209-git-send-email-yi.zhu@intel.com>
 <11933037822284-git-send-email-yi.zhu@intel.com>
 <11933037831480-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 37513e5..2da0f50 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -101,7 +101,7 @@ int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "1.1.17k" VD VS
+#define IWLWIFI_VERSION "1.1.18k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index bf93db5..f07643b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -100,7 +100,7 @@ int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "1.1.17k" VD VS
+#define IWLWIFI_VERSION "1.1.18k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
-- 
1.5.2
