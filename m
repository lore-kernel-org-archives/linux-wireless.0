Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43390 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbXI0DfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:35:04 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] iwlwifi: Update iwlwifi version stamp to 1.1.17
Date: Thu, 27 Sep 2007 11:27:44 +0800
Message-Id: <11908636853788-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636833477-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
 <11908636712746-git-send-email-yi.zhu@intel.com>
 <11908636732679-git-send-email-yi.zhu@intel.com>
 <11908636743625-git-send-email-yi.zhu@intel.com>
 <11908636753775-git-send-email-yi.zhu@intel.com>
 <11908636772860-git-send-email-yi.zhu@intel.com>
 <11908636781043-git-send-email-yi.zhu@intel.com>
 <1190863679136-git-send-email-yi.zhu@intel.com>
 <11908636801368-git-send-email-yi.zhu@intel.com>
 <11908636823439-git-send-email-yi.zhu@intel.com>
 <11908636833477-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a83934f..5db0615 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -103,7 +103,7 @@ int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "0.1.15k" VD VS
+#define IWLWIFI_VERSION "1.1.17k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 283c6a3..950ccfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -102,7 +102,7 @@ int iwl_param_queues_num = IWL_MAX_NUM_QUEUES;
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "0.1.15k" VD VS
+#define IWLWIFI_VERSION "1.1.17k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
-- 
1.5.1
