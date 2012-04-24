Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758540Ab2DXXv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/11] iwlwifi: small define change
Date: Tue, 24 Apr 2012 16:45:58 -0700
Message-Id: <1335311164-10252-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015200_645985_37CD6F34)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 5e02b4f..15e9bfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1903,6 +1903,8 @@ struct iwl_bt_cmd {
 					IWLAGN_BT_VALID_REDUCED_TX_PWR | \
 					IWLAGN_BT_VALID_3W_LUT)
 
+#define IWLAGN_BT_DECISION_LUT_SIZE	12
+
 struct iwl_basic_bt_cmd {
 	u8 flags;
 	u8 ledtime; /* unused */
@@ -1913,7 +1915,7 @@ struct iwl_basic_bt_cmd {
 	u8 bt3_prio_sample_time;
 	u8 bt3_timer_t2_value;
 	__le16 bt4_reaction_time; /* unused */
-	__le32 bt3_lookup_table[12];
+	__le32 bt3_lookup_table[IWLAGN_BT_DECISION_LUT_SIZE];
 	__le16 bt4_decision_time; /* unused */
 	__le16 valid;
 };
-- 
1.7.0.4

