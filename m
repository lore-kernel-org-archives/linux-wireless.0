Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab1HMQ57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:57:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/13] iwlagn: change default sensitivity value for 5000 and 6000 series
Date: Sat, 13 Aug 2011 09:18:04 -0700
Message-Id: <1313252287-22858-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_185815_251188_C6020107)
In-Reply-To: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the default sensitivity value for both 5000 and 6000 series devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-6000.c |    8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 3eeb12e..58481c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -84,12 +84,12 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 }
 
 static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
-	.min_nrg_cck = 95,
+	.min_nrg_cck = 100,
 	.max_nrg_cck = 0, /* not used, set to 0 */
 	.auto_corr_min_ofdm = 90,
 	.auto_corr_min_ofdm_mrc = 170,
-	.auto_corr_min_ofdm_x1 = 120,
-	.auto_corr_min_ofdm_mrc_x1 = 240,
+	.auto_corr_min_ofdm_x1 = 105,
+	.auto_corr_min_ofdm_mrc_x1 = 220,
 
 	.auto_corr_max_ofdm = 120,
 	.auto_corr_max_ofdm_mrc = 210,
@@ -98,10 +98,10 @@ static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 
 	.auto_corr_min_cck = 125,
 	.auto_corr_max_cck = 200,
-	.auto_corr_min_cck_mrc = 170,
+	.auto_corr_min_cck_mrc = 200,
 	.auto_corr_max_cck_mrc = 400,
-	.nrg_th_cck = 95,
-	.nrg_th_ofdm = 95,
+	.nrg_th_cck = 100,
+	.nrg_th_ofdm = 100,
 
 	.barker_corr_th_min = 190,
 	.barker_corr_th_min_mrc = 390,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 12838c0..544581a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -114,7 +114,7 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 }
 
 static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
-	.min_nrg_cck = 97,
+	.min_nrg_cck = 110,
 	.max_nrg_cck = 0, /* not used, set to 0 */
 	.auto_corr_min_ofdm = 80,
 	.auto_corr_min_ofdm_mrc = 128,
@@ -130,11 +130,11 @@ static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 	.auto_corr_max_cck = 175,
 	.auto_corr_min_cck_mrc = 160,
 	.auto_corr_max_cck_mrc = 310,
-	.nrg_th_cck = 97,
-	.nrg_th_ofdm = 100,
+	.nrg_th_cck = 110,
+	.nrg_th_ofdm = 110,
 
 	.barker_corr_th_min = 190,
-	.barker_corr_th_min_mrc = 390,
+	.barker_corr_th_min_mrc = 336,
 	.nrg_th_cca = 62,
 };
 
-- 
1.7.0.4

