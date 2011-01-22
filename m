Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab1AVASW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:22 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/14] iwlagn: add 2000 series pci id
Date: Fri, 21 Jan 2011 16:06:40 -0800
Message-Id: <1295654809-5790-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add PCI ID supports for all 2000 series devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   43 ++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9240abf..dad9a63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4512,6 +4512,49 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0896, 0x5025, iwl130_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0896, 0x5027, iwl130_bg_cfg)},
 
+/* 2x00 Series */
+	{IWL_PCI_DEVICE(0x0890, 0x4022, iwl2000_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0891, 0x4222, iwl2000_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0890, 0x4422, iwl2000_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0890, 0x4026, iwl2000_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0891, 0x4226, iwl2000_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0890, 0x4426, iwl2000_2bg_cfg)},
+
+/* 2x30 Series */
+	{IWL_PCI_DEVICE(0x0887, 0x4062, iwl2030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0888, 0x4262, iwl2030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0887, 0x4462, iwl2030_2bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0887, 0x4066, iwl2030_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0888, 0x4266, iwl2030_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x0887, 0x4466, iwl2030_2bg_cfg)},
+
+/* 6x35 Series */
+	{IWL_PCI_DEVICE(0x088E, 0x4060, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4064, iwl6035_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x4264, iwl6035_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4464, iwl6035_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4066, iwl6035_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x4266, iwl6035_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x088E, 0x4466, iwl6035_2bg_cfg)},
+
+/* 200 Series */
+	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl200_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0895, 0x0222, iwl200_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0422, iwl200_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0026, iwl200_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0895, 0x0226, iwl200_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0426, iwl200_bg_cfg)},
+
+/* 230 Series */
+	{IWL_PCI_DEVICE(0x0892, 0x0062, iwl230_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0893, 0x0262, iwl230_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0892, 0x0462, iwl230_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0892, 0x0066, iwl230_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0893, 0x0266, iwl230_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0892, 0x0466, iwl230_bg_cfg)},
+
 #endif /* CONFIG_IWL5000 */
 
 	{0}
-- 
1.7.0.4

