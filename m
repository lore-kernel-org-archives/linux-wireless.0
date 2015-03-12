Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37930 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbbCLNG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:26 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 44/49] iwlwifi: add more new 8260 series PCI IDs
Date: Thu, 12 Mar 2015 15:04:29 +0200
Message-Id: <1426165474-25586-44-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143418_904058_C487427D)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

More sub system IDs were introduced for the 8260 series.
Add the new sub system IDs so the cards can be recognized.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 3f9289d..2794cd2 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -414,9 +414,14 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 /* 8000 Series */
 	{IWL_PCI_DEVICE(0x24F3, 0x0010, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x1010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0110, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x1110, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0250, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x1050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0150, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x0030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F4, 0x1130, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x1030, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xC010, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xD010, iwl8260_2ac_cfg)},
@@ -434,6 +439,9 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F5, 0x0010, iwl4165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F6, 0x0030, iwl4165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0810, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0910, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0850, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0950, iwl8260_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
1.9.1

