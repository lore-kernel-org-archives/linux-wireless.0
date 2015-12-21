Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbbLUUwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:38 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/45] iwlwifi: Update PCI IDs for 8000 and 9000 series
Date: Mon, 21 Dec 2015 22:50:41 +0200
Message-Id: <1450731046-2796-40-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220059_645569_D9B239BE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

A new PCI IDs update to the 8000 and 9000 series.

type=feature

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 4f94be9..af10651 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -471,19 +471,20 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F3, 0x0850, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0950, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0930, iwl8260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x24FD, 0x0000, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0000, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0010, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x8010, iwl8265_2ac_cfg)},
 
 /* 9000 Series */
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl5165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl5165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl5165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9260_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
-- 
2.5.0

