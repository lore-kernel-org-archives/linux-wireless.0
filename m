Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48328 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752001AbdLANFp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 08:05:45 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>, stable@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  1 Dec 2017 15:05:34 +0200
Message-Id: <20171201130535.27656-2-luca@coelho.fi> (sfid-20171201_140549_243435_F44D1CAE)
In-Reply-To: <20171201130535.27656-1-luca@coelho.fi>
References: <20171201130535.27656-1-luca@coelho.fi>
Subject: [PATCH 1/2] iwlwifi: add new cards for 9260 and 22000 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ihab Zhaika <ihab.zhaika@intel.com>

add 1 PCI ID for 9260 series and 1 for 22000 series.

Cc: stable@vger.kernel.org
Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index f21fe59faccf..ccd7c33c4c28 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -553,6 +553,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x271B, 0x0014, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0210, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0214, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x271C, 0x0214, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x0034, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x0038, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x003C, iwl9560_2ac_cfg)},
@@ -664,6 +665,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x0310, iwla000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwla000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0A10, iwla000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwla000_2ax_cfg_hr)},
 
 #endif /* CONFIG_IWLMVM */
 
-- 
2.15.0
