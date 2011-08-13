Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab1HMSS2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/60] iwlagn: remove out-dated comments
Date: Sat, 13 Aug 2011 10:37:38 -0700
Message-Id: <1313257116-2697-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201836_923966_CF544417)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Portion of iwl_cfg comments is not correct anymore, remove it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6078590..01f9c09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -220,16 +220,7 @@ struct iwl_ht_params {
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
  * highest and @ucode_api_min the lowest). Firmware will only be loaded if
- * it has a supported API version. The firmware's API version will be
- * stored in @iwl_priv, enabling the driver to make runtime changes based
- * on firmware version used.
- *
- * For example,
- * if (IWL_UCODE_API(priv->ucode_ver) >= 2) {
- *	Driver interacts with Firmware API version >= 2.
- * } else {
- *	Driver interacts with Firmware API version 1.
- * }
+ * it has a supported API version.
  *
  * The ideal usage of this infrastructure is to treat a new ucode API
  * release as a new hardware revision.
-- 
1.7.0.4

