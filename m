Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26170 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab0KPQGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:41 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/18] iwlagn: change default ACK/CTS MASK setting for WiFi/BT coex
Date: Tue, 16 Nov 2010 08:01:37 -0800
Message-Id: <1289923311-14920-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the default BT_KILL_ACK_MASK and BT_KILL_CTS_MASK for BT coex

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index a3cd811..9c1b7fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2450,8 +2450,8 @@ struct iwl_bt_cmd {
 
 #define IWLAGN_BT3_T7_DEFAULT		1
 
-#define IWLAGN_BT_KILL_ACK_MASK_DEFAULT	cpu_to_le32(0xffffffff)
-#define IWLAGN_BT_KILL_CTS_MASK_DEFAULT	cpu_to_le32(0xffffffff)
+#define IWLAGN_BT_KILL_ACK_MASK_DEFAULT	cpu_to_le32(0xffff0000)
+#define IWLAGN_BT_KILL_CTS_MASK_DEFAULT	cpu_to_le32(0xffff0000)
 
 #define IWLAGN_BT3_PRIO_SAMPLE_DEFAULT	2
 
-- 
1.7.0.4

