Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28147 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbZJPVZ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/10] iwlwifi: fix incorrect otp blocks number for 6x50 series
Date: Fri, 16 Oct 2009 14:25:52 -0700
Message-Id: <1255728358-29976-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For 6x50 series, number of OTP blocks is different from 6x00 series

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index e74dad3..887e4e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -408,7 +408,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
 	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
@@ -434,7 +434,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = false,
 	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
@@ -485,7 +485,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = false,
 	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
-- 
1.5.6.3

