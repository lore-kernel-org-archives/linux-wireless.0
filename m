Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758445Ab2DXXv1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/11] iwlwifi: add BT reduced tx power flag
Date: Tue, 24 Apr 2012 16:45:55 -0700
Message-Id: <1335311164-10252-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015155_204060_A9CA5152)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 296347a..c212e53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1891,7 +1891,7 @@ struct iwl_bt_cmd {
 #define IWLAGN_BT_VALID_3W_TIMERS	cpu_to_le16(BIT(3))
 #define IWLAGN_BT_VALID_KILL_ACK_MASK	cpu_to_le16(BIT(4))
 #define IWLAGN_BT_VALID_KILL_CTS_MASK	cpu_to_le16(BIT(5))
-#define IWLAGN_BT_VALID_BT4_TIMES	cpu_to_le16(BIT(6))
+#define IWLAGN_BT_VALID_REDUCED_TX_PWR	cpu_to_le16(BIT(6))
 #define IWLAGN_BT_VALID_3W_LUT		cpu_to_le16(BIT(7))
 
 #define IWLAGN_BT_ALL_VALID_MSK		(IWLAGN_BT_VALID_ENABLE_FLAGS | \
@@ -1900,7 +1900,7 @@ struct iwl_bt_cmd {
 					IWLAGN_BT_VALID_3W_TIMERS | \
 					IWLAGN_BT_VALID_KILL_ACK_MASK | \
 					IWLAGN_BT_VALID_KILL_CTS_MASK | \
-					IWLAGN_BT_VALID_BT4_TIMES | \
+					IWLAGN_BT_VALID_REDUCED_TX_PWR | \
 					IWLAGN_BT_VALID_3W_LUT)
 
 struct iwl_basic_bt_cmd {
-- 
1.7.0.4

