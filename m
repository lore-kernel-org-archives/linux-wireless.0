Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab2A1Rhd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 12:37:33 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/4] iwlwifi: fix typo
Date: Sat, 28 Jan 2012 08:30:49 -0800
Message-Id: <1327768252-22742-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120128_183740_888937_A57A9D98)
In-Reply-To: <1327768252-22742-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1327768252-22742-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix few places of typo

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index 185b69e..f97d061 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -111,17 +111,17 @@
  *
  * @IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32:
  * @IWL_TM_CMD_APP2DEV_INDIRECT_REG_WRITE32:
- *	commands from user applicaiton to indirectly access peripheral register
+ *	commands from user application to indirectly access peripheral register
  *
  * @IWL_TM_CMD_APP2DEV_READ_SRAM:
  * @IWL_TM_CMD_APP2DEV_DUMP_SRAM:
- *	commands from user applicaiton to read data in sram
+ *	commands from user application to read data in sram
  *
- * @IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW: load Weak On Wireless LAN uCode image
+ * @IWL_TM_CMD_APP2DEV_LOAD_WOWLAN_FW: load Wake On Wireless LAN uCode image
  * @IWL_TM_CMD_APP2DEV_GET_FW_VERSION: retrieve uCode version
  * @IWL_TM_CMD_APP2DEV_GET_DEVICE_ID: retrieve ID information in device
  * @IWL_TM_CMD_APP2DEV_GET_FW_INFO:
- *	retrieve informration of existing loaded uCode image
+ *	retrieve information of existing loaded uCode image
  *
  */
 enum iwl_tm_cmd_t {
-- 
1.7.0.4

