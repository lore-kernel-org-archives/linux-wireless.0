Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1LPQhi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:38 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/24] iwlwifi: Add official names for new devices
Date: Fri, 16 Dec 2011 07:37:07 -0800
Message-Id: <1324049849-831-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173741_978048_00EEA98F)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Replace the engineering names with the marketing names for the
new devices.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 1d2cb4c..0946933 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -254,13 +254,13 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.iq_invert = true					\
 
 struct iwl_cfg iwl2000_2bgn_cfg = {
-	.name = "2000 Series 2x2 BGN",
+	.name = "Intel(R) Centrino(R) Wireless-N 2200 BGN",
 	IWL_DEVICE_2000,
 	.ht_params = &iwl2000_ht_params,
 };
 
 struct iwl_cfg iwl2000_2bgn_d_cfg = {
-	.name = "2000D Series 2x2 BGN",
+	.name = "Intel(R) Centrino(R) Wireless-N 2200D BGN",
 	IWL_DEVICE_2000,
 	.ht_params = &iwl2000_ht_params,
 };
@@ -282,7 +282,7 @@ struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.iq_invert = true					\
 
 struct iwl_cfg iwl2030_2bgn_cfg = {
-	.name = "2000 Series 2x2 BGN/BT",
+	.name = "Intel(R) Centrino(R) Wireless-N 2230 BGN",
 	IWL_DEVICE_2030,
 	.ht_params = &iwl2000_ht_params,
 };
@@ -304,13 +304,13 @@ struct iwl_cfg iwl2030_2bgn_cfg = {
 	.iq_invert = true					\
 
 struct iwl_cfg iwl105_bgn_cfg = {
-	.name = "105 Series 1x1 BGN",
+	.name = "Intel(R) Centrino(R) Wireless-N 105 BGN",
 	IWL_DEVICE_105,
 	.ht_params = &iwl2000_ht_params,
 };
 
 struct iwl_cfg iwl105_bgn_d_cfg = {
-	.name = "105D Series 1x1 BGN",
+	.name = "Intel(R) Centrino(R) Wireless-N 105D BGN",
 	IWL_DEVICE_105,
 	.ht_params = &iwl2000_ht_params,
 };
@@ -333,7 +333,7 @@ struct iwl_cfg iwl105_bgn_d_cfg = {
 	.iq_invert = true					\
 
 struct iwl_cfg iwl135_bgn_cfg = {
-	.name = "135 Series 1x1 BGN/BT",
+	.name = "Intel(R) Centrino(R) Wireless-N 135 BGN",
 	IWL_DEVICE_135,
 	.ht_params = &iwl2000_ht_params,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a3be117..54b7533 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -423,7 +423,7 @@ struct iwl_cfg iwl6030_2bg_cfg = {
 };
 
 struct iwl_cfg iwl6035_2agn_cfg = {
-	.name = "6035 Series 2x2 AGN/BT",
+	.name = "Intel(R) Centrino(R) Advanced-N 6235 AGN",
 	IWL_DEVICE_6030,
 	.ht_params = &iwl6000_ht_params,
 };
-- 
1.7.0.4

