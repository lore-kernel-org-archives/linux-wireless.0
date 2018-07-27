Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38566 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730088AbeG0OKi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:10:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 27 Jul 2018 15:48:23 +0300
Message-Id: <20180727124838.25910-2-luca@coelho.fi> (sfid-20180727_144854_667177_FB6155EC)
In-Reply-To: <20180727124838.25910-1-luca@coelho.fi>
References: <20180727124838.25910-1-luca@coelho.fi>
Subject: [PATCH 01/16] iwlwifi: pcie: add a bunch of PCI IDs for 22000 and 22560
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add some missing PCI IDs for 22000 and 22560 devices.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 21 ++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 0358b406be81..651975bc159b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -806,17 +806,32 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA370, 0x42A4, iwl9462_2ac_cfg_soc)},
 
 /* 22000 Series */
-	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22000_2ac_cfg_jf)},
 	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl22000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0040, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0070, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0030, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0090, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0310, iwl22000_2ac_cfg_hr_cdb)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22000_2ac_cfg_jf)},
+	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwl22560_2ax_cfg_su_cdb)},
+	{IWL_PCI_DEVICE(0x40C0, 0x0010, iwl22560_2ax_cfg_su_cdb)},
+	{IWL_PCI_DEVICE(0x40c0, 0x0090, iwl22560_2ax_cfg_su_cdb)},
+	{IWL_PCI_DEVICE(0x40C0, 0x0310, iwl22560_2ax_cfg_su_cdb)},
+	{IWL_PCI_DEVICE(0x40C0, 0x0A10, iwl22560_2ax_cfg_su_cdb)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0040, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0070, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0078, iwl22000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0040, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0070, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0078, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x00B0, iwl22000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl22000_2ax_cfg_hr)},
 
 #endif /* CONFIG_IWLMVM */
 
-- 
2.18.0
