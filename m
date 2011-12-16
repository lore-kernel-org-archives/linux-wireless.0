Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760199Ab1LPQh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:56 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/24] iwlwifi: add missing documentation for iwl_shared
Date: Fri, 16 Dec 2011 07:37:24 -0800
Message-Id: <1324049849-831-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173819_331765_D8AE84D5)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A few descriptions were missing

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index aa1ed65..8cf877e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -347,16 +347,19 @@ struct iwl_cfg {
  * @ucode_owner: IWL_OWNERSHIP_*
  * @cmd_queue: command queue number
  * @status: STATUS_*
+ * @wowlan: are we running wowlan uCode
  * @valid_contexts: microcode/device supports multiple contexts
  * @bus: pointer to the bus layer data
  * @cfg: see struct iwl_cfg
  * @priv: pointer to the upper layer data
+ * @trans: pointer to the transport layer data
  * @hw_params: see struct iwl_hw_params
  * @workqueue: the workqueue used by all the layers of the driver
  * @lock: protect general shared data
  * @sta_lock: protects the station table.
  *	If lock and sta_lock are needed, lock must be acquired first.
  * @mutex:
+ * @wait_command_queue: the wait_queue for SYNC host command nad uCode load
  * @eeprom: pointer to the eeprom/OTP image
  * @ucode_type: indicator of loaded ucode image
  * @notif_waits: things waiting for notification
-- 
1.7.0.4

