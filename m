Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42404 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751519AbdJ2M3A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:29:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:14 +0200
Message-Id: <20171029122816.8802-16-luca@coelho.fi> (sfid-20171029_132903_593355_F6CB988F)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 15/17] iwlwifi: add new cards for 8260 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ihab Zhaika <ihab.zhaika@intel.com>

add three new PCI ID'S for 8260 series

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index aa3c07192624..a988f41125e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -467,6 +467,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F3, 0x9110, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x8030, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F4, 0x9030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F4, 0xC030, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F4, 0xD030, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x8130, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x9130, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x8132, iwl8260_2ac_cfg)},
@@ -485,6 +487,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F3, 0x0950, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0930, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0000, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x4010, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0010, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0110, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x1110, iwl8265_2ac_cfg)},
-- 
2.14.2
