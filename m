Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41554 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751610AbdHAJkv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:40:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Tzipi Peres <tzipi.peres@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  1 Aug 2017 12:40:39 +0300
Message-Id: <20170801094039.22349-9-luca@coelho.fi> (sfid-20170801_114059_887901_E9FA9355)
In-Reply-To: <20170801094039.22349-1-luca@coelho.fi>
References: <20170801094039.22349-1-luca@coelho.fi>
Subject: [PATCH 8/8] iwlwifi: add the new 9000 series PCI IDs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tzipi Peres <tzipi.peres@intel.com>

Add two PCI IDs for the 9160 series.
Add five PCI IDs for the 9260 series.
Add one PCI IDs for the 9270 series.
Add seven PCI IDs for the 9460 series.
Add five PCI IDs for the 9560 series.

Signed-off-by: Tzipi Peres <tzipi.peres@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index f16c1bb9bf94..84f4ba01e14f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -510,9 +510,17 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 /* 9000 Series */
 	{IWL_PCI_DEVICE(0x271B, 0x0010, iwl9160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x271B, 0x0014, iwl9160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x271B, 0x0210, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0000, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0014, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0xA014, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0210, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0214, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1410, iwl9270_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1610, iwl9270_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9460_2ac_cfg)},
@@ -527,10 +535,22 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0260, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0064, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x00A4, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x40A4, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x02A4, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x00A0, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x02A0, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0060, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA370, 0x0060, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x31DC, 0x0060, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0230, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0234, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0238, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x023C, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA370, 0x0030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_cfg)},
-- 
2.13.2
