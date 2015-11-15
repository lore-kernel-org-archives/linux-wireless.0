Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48833 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbbKOTeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2015 14:34:09 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/4] iwlwifi: Add new PCI IDs for the 8260 series
Date: Sun, 15 Nov 2015 21:34:02 +0200
Message-Id: <1447616045-31484-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151115_203415_464419_FF8570A4)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8EAF98@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8EAF98@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add some new PCI IDs for the 8260 series which were missing.
The following sub-system IDs were added:
0x0130, 0x1130, 0x0132, 0x1132, 0x1150, 0x8110, 0x9110, 0x8130,
0x9130, 0x8132, 0x9132, 0x8150, 0x9150, 0x0044, 0x0930

CC: <stable@vger.kernel.org> [4.1+]
Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 644b58b..639761f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -423,14 +423,21 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 /* 8000 Series */
 	{IWL_PCI_DEVICE(0x24F3, 0x0010, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x1010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0130, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x1130, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0132, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x1132, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0110, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x01F0, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0012, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x1012, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x1110, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0050, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0250, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x1050, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0150, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x1150, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x0030, iwl8260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x24F4, 0x1130, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x1030, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xC010, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xC110, iwl8260_2ac_cfg)},
@@ -438,18 +445,28 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F3, 0xC050, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xD050, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x8010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x8110, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x9010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x9110, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x8030, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x9030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x8130, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x9130, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x8132, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x9132, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x8050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x8150, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x9050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x9150, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0004, iwl8260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0044, iwl8260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x24F5, 0x0010, iwl4165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F6, 0x0030, iwl4165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0810, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0910, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0850, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0950, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0930, iwl8260_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
2.5.0

