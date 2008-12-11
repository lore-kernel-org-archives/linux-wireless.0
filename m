Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbYLKScp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:32:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwlwifi: add contact email to MODULE_AUTHOR
Date: Thu, 11 Dec 2008 10:33:41 -0800
Message-Id: <1229020421-4823-7-git-send-email-reinette.chatre@intel.com> (sfid-20081211_193253_427392_EDA3E040)
In-Reply-To: <1229020421-4823-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1229020421-4823-1-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-2-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-3-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-4-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-5-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3680570..47aecf7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -83,7 +83,7 @@
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
-MODULE_AUTHOR(DRV_COPYRIGHT);
+MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("iwl4965");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a3b9605..67fd6e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -42,7 +42,7 @@
 
 MODULE_DESCRIPTION("iwl core");
 MODULE_VERSION(IWLWIFI_VERSION);
-MODULE_AUTHOR(DRV_COPYRIGHT);
+MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
 #define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 72f82ec..08b842f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -72,6 +72,7 @@ struct iwl_cmd;
 
 #define IWLWIFI_VERSION "1.3.27k"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2008 Intel Corporation"
+#define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3f41836..161d812 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -93,12 +93,13 @@ int iwl3945_param_queues_num = IWL39_MAX_NUM_QUEUES; /* def: 8 Tx queues */
 
 #define IWLWIFI_VERSION "1.2.26k" VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2008 Intel Corporation"
+#define DRV_AUTHOR     "<ilw@linux.intel.com>"
 #define DRV_VERSION     IWLWIFI_VERSION
 
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
-MODULE_AUTHOR(DRV_COPYRIGHT);
+MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
 static const struct ieee80211_supported_band *iwl3945_get_band(
-- 
1.5.4.3

