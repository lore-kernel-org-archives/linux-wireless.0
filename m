Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab0KWTEa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:04:30 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/5] iwlwifi: add more power management flags
Date: Tue, 23 Nov 2010 10:58:53 -0800
Message-Id: <1290538736-10816-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding additional power management option available for the device.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 4028ed3..f9e7fa4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2671,6 +2671,11 @@ struct iwl_spectrum_notification {
 #define IWL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le16(BIT(2))
 #define IWL_POWER_PCI_PM_MSK			cpu_to_le16(BIT(3))
 #define IWL_POWER_FAST_PD			cpu_to_le16(BIT(4))
+#define IWL_POWER_BEACON_FILTERING		cpu_to_le16(BIT(5))
+#define IWL_POWER_SHADOW_REG_ENA		cpu_to_le16(BIT(6))
+#define IWL_POWER_CT_KILL_SET			cpu_to_le16(BIT(7))
+#define IWL_POWER_BT_SCO_ENA			cpu_to_le16(BIT(8))
+#define IWL_POWER_ADVANCE_PM_ENA		cpu_to_le16(BIT(9))
 
 struct iwl3945_powertable_cmd {
 	__le16 flags;
-- 
1.7.0.4

