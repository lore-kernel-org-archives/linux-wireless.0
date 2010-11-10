Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab0KJSBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/16] iwlagn: update PCI ID for 100 series devices
Date: Wed, 10 Nov 2010 09:56:37 -0800
Message-Id: <1289411810-23093-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the supported PCI ID list for 100 series devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 83a5405..bdabf7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4486,10 +4486,11 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 
 /* 100 Series WiFi */
 	{IWL_PCI_DEVICE(0x08AE, 0x1005, iwl100_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x08AE, 0x1007, iwl100_bg_cfg)},
 	{IWL_PCI_DEVICE(0x08AF, 0x1015, iwl100_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x08AF, 0x1017, iwl100_bg_cfg)},
 	{IWL_PCI_DEVICE(0x08AE, 0x1025, iwl100_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x08AE, 0x1007, iwl100_bg_cfg)},
-	{IWL_PCI_DEVICE(0x08AE, 0x1017, iwl100_bg_cfg)},
+	{IWL_PCI_DEVICE(0x08AE, 0x1027, iwl100_bg_cfg)},
 
 /* 130 Series WiFi */
 	{IWL_PCI_DEVICE(0x0896, 0x5005, iwl130_bgn_cfg)},
-- 
1.7.0.4

