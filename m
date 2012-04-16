Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab2DPWB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/16] iwlwifi: remove antenna from mod params struct
Date: Mon, 16 Apr 2012 14:56:57 -0700
Message-Id: <1334613430-30720-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000203_896945_C14DBC4E)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It doesn't even exist as a module parameter,
so just remove the item from the struct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 8c962c1..428883b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -118,7 +118,6 @@ extern struct iwl_mod_params iwlagn_mod_params;
  * @disable_11n: disable 11n capabilities, default = 0,
  *	use IWL_DISABLE_HT_* constants
  * @amsdu_size_8K: enable 8K amsdu size, default = 1
- * @antenna: both antennas (use diversity), default = 0
  * @restart_fw: restart firmware, default = 1
  * @plcp_check: enable plcp health check, default = true
  * @wd_disable: enable stuck queue check, default = 0
@@ -135,7 +134,6 @@ struct iwl_mod_params {
 	int sw_crypto;
 	unsigned int disable_11n;
 	int amsdu_size_8K;
-	int antenna;
 	int restart_fw;
 	bool plcp_check;
 	int  wd_disable;
-- 
1.7.0.4

