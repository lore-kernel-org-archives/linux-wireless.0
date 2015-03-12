Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbbCLNGJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:09 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/49] iwlwifi: add new 8260 series PCI IDs
Date: Thu, 12 Mar 2015 15:04:20 +0200
Message-Id: <1426165474-25586-35-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143417_194062_D40052C2)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

New sub system IDs were introduced for the 8260 series.
This patch adds them so new 8260 cards can be recognized.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index dbd6bcf..3f9289d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -413,10 +413,27 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 /* 8000 Series */
 	{IWL_PCI_DEVICE(0x24F3, 0x0010, iwl8260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x24F3, 0x0004, iwl8260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x1010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x1050, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x0030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F4, 0x1030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0xC010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0xD010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F4, 0xC030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F4, 0xD030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0xC050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0xD050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x8010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x9010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F4, 0x8030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F4, 0x9030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x8050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x9050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0004, iwl8260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x24F5, 0x0010, iwl4165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F6, 0x0030, iwl4165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x0810, iwl8260_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
1.9.1

