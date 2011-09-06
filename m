Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab1IFRPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/10] iwlagn: enable 11n support for "_d" sku
Date: Tue,  6 Sep 2011 09:31:23 -0700
Message-Id: <1315326685-22213-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191524_983771_D899CB5D)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"_d" SKU is 11n enabled device

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 764d310..913f2a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -285,6 +285,7 @@ struct iwl_cfg iwl2000_2bg_cfg = {
 struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.name = "2000D Series 2x2 BGN",
 	IWL_DEVICE_2000,
+	.ht_params = &iwl2000_ht_params,
 };
 
 #define IWL_DEVICE_2030						\
-- 
1.7.0.4

