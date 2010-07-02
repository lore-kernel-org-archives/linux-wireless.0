Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759537Ab0GBSoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/8] iwlwifi: generic parameter define for _agn device
Date: Fri,  2 Jul 2010 11:45:39 -0700
Message-Id: <1278096340-2546-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Code clean up to change name from having 5000 as part of name which easy
to confuse and think it is for 5000 series devices to more
generic _agn name since it is being used by multiple _agn devices.

No functional changes.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 96a4888..c281d07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -129,8 +129,8 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 			priv->cfg->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
+	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 648d53b..7d89d99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -179,8 +179,8 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 			priv->cfg->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
+	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
@@ -226,8 +226,8 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 			priv->cfg->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
+	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 79ba7ad..59681c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -160,8 +160,8 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 			priv->cfg->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
+	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
 	priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 0844955..d887b57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -958,8 +958,8 @@ struct iwl_qosparam_cmd {
 #define IWL3945_STATION_COUNT	25
 #define IWL4965_BROADCAST_ID	31
 #define	IWL4965_STATION_COUNT	32
-#define IWL5000_BROADCAST_ID	15
-#define	IWL5000_STATION_COUNT	16
+#define IWLAGN_BROADCAST_ID	15
+#define	IWLAGN_STATION_COUNT	16
 
 #define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
-- 
1.7.0.4

