Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab1DHPuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/16] iwlwifi: remove extranious macro from firmware define
Date: Fri,  8 Apr 2011 08:30:21 -0700
Message-Id: <1302276636-12802-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

define of firmware filenames use extra macro to build the files name.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-2000.c |    9 +++------
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 ++----
 drivers/net/wireless/iwlwifi/iwl-6000.c |   12 ++++--------
 4 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 1b27992..4323d27 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -57,12 +57,10 @@
 #define IWL100_UCODE_API_MIN 5
 
 #define IWL1000_FW_PRE "iwlwifi-1000-"
-#define _IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE #api ".ucode"
-#define IWL1000_MODULE_FIRMWARE(api) _IWL1000_MODULE_FIRMWARE(api)
+#define IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE #api ".ucode"
 
 #define IWL100_FW_PRE "iwlwifi-100-"
-#define _IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE #api ".ucode"
-#define IWL100_MODULE_FIRMWARE(api) _IWL100_MODULE_FIRMWARE(api)
+#define IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE #api ".ucode"
 
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index f602af4..564477d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -60,16 +60,13 @@
 #define IWL200_UCODE_API_MIN 5
 
 #define IWL2030_FW_PRE "iwlwifi-2030-"
-#define _IWL2030_MODULE_FIRMWARE(api) IWL2030_FW_PRE #api ".ucode"
-#define IWL2030_MODULE_FIRMWARE(api) _IWL2030_MODULE_FIRMWARE(api)
+#define IWL2030_MODULE_FIRMWARE(api) IWL2030_FW_PRE #api ".ucode"
 
 #define IWL2000_FW_PRE "iwlwifi-2000-"
-#define _IWL2000_MODULE_FIRMWARE(api) IWL2000_FW_PRE #api ".ucode"
-#define IWL2000_MODULE_FIRMWARE(api) _IWL2000_MODULE_FIRMWARE(api)
+#define IWL2000_MODULE_FIRMWARE(api) IWL2000_FW_PRE #api ".ucode"
 
 #define IWL200_FW_PRE "iwlwifi-200-"
-#define _IWL200_MODULE_FIRMWARE(api) IWL200_FW_PRE #api ".ucode"
-#define IWL200_MODULE_FIRMWARE(api) _IWL200_MODULE_FIRMWARE(api)
+#define IWL200_MODULE_FIRMWARE(api) IWL200_FW_PRE #api ".ucode"
 
 static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 66f5fe8..4dafc58 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -59,12 +59,10 @@
 #define IWL5150_UCODE_API_MIN 1
 
 #define IWL5000_FW_PRE "iwlwifi-5000-"
-#define _IWL5000_MODULE_FIRMWARE(api) IWL5000_FW_PRE #api ".ucode"
-#define IWL5000_MODULE_FIRMWARE(api) _IWL5000_MODULE_FIRMWARE(api)
+#define IWL5000_MODULE_FIRMWARE(api) IWL5000_FW_PRE #api ".ucode"
 
 #define IWL5150_FW_PRE "iwlwifi-5150-"
-#define _IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE #api ".ucode"
-#define IWL5150_MODULE_FIRMWARE(api) _IWL5150_MODULE_FIRMWARE(api)
+#define IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE #api ".ucode"
 
 /* NIC configuration for 5000 series */
 static void iwl5000_nic_config(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 24d105b..9fb2a42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -60,20 +60,16 @@
 #define IWL6000G2_UCODE_API_MIN 4
 
 #define IWL6000_FW_PRE "iwlwifi-6000-"
-#define _IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
-#define IWL6000_MODULE_FIRMWARE(api) _IWL6000_MODULE_FIRMWARE(api)
+#define IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
 
 #define IWL6050_FW_PRE "iwlwifi-6050-"
-#define _IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
-#define IWL6050_MODULE_FIRMWARE(api) _IWL6050_MODULE_FIRMWARE(api)
+#define IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
 
 #define IWL6005_FW_PRE "iwlwifi-6000g2a-"
-#define _IWL6005_MODULE_FIRMWARE(api) IWL6005_FW_PRE #api ".ucode"
-#define IWL6005_MODULE_FIRMWARE(api) _IWL6005_MODULE_FIRMWARE(api)
+#define IWL6005_MODULE_FIRMWARE(api) IWL6005_FW_PRE #api ".ucode"
 
 #define IWL6030_FW_PRE "iwlwifi-6000g2b-"
-#define _IWL6030_MODULE_FIRMWARE(api) IWL6030_FW_PRE #api ".ucode"
-#define IWL6030_MODULE_FIRMWARE(api) _IWL6030_MODULE_FIRMWARE(api)
+#define IWL6030_MODULE_FIRMWARE(api) IWL6030_FW_PRE #api ".ucode"
 
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
-- 
1.7.0.4

