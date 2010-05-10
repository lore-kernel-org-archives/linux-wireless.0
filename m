Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab0EJW2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 38/47] iwlwifi: provide more comments for cfg structure
Date: Mon, 10 May 2010 15:28:09 -0700
Message-Id: <1273530498-11876-39-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Provide comments for newly added cfg parameters

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d80aa6c..7e5a5ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -247,6 +247,18 @@ struct iwl_mod_params {
  * @support_wimax_coexist: support wimax/wifi co-exist
  * @plcp_delta_threshold: plcp error rate threshold used to trigger
  *	radio tuning when there is a high receiving plcp error rate
+ * @chain_noise_scale: default chain noise scale used for gain computation
+ * @monitor_recover_period: default timer used to check stuck queues
+ * @temperature_kelvin: temperature report by uCode in kelvin
+ * @max_event_log_size: size of event log buffer size for ucode event logging
+ * @tx_power_by_driver: tx power calibration performed by driver
+ *	instead of uCode
+ * @ucode_tracing: support ucode continuous tracing
+ * @sensitivity_calib_by_driver: driver has the capability to perform
+ *	sensitivity calibration operation
+ * @chain_noise_calib_by_driver: driver has the capability to perform
+ *	chain noise calibration operation
+ * @scan_antennas: available antenna for scan operation
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
-- 
1.6.3.3

