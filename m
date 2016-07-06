Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33454 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753651AbcGFKoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	"[4.1+]" <stable@vger.kernel.org>,
	David Spinadel <david.spinadel@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:08 +0300
Message-Id: <1467801651-1816-13-git-send-email-luca@coelho.fi> (sfid-20160706_124450_941500_5F7392D4)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 13/56] iwlwifi: add new 8260 PCI IDs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add 3 new 8260 series PCI IDs:
  - (0x24F3, 0x10B0)
  - (0x24F3, 0xD0B0)
  - (0x24F3, 0xB0B0)

CC: <stable@vger.kernel.org> [4.1+]
Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index a588b05..1cae19d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -433,6 +433,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 /* 8000 Series */
 	{IWL_PCI_DEVICE(0x24F3, 0x0010, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x1010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0x10B0, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0130, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x1130, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0132, iwl8260_2ac_cfg)},
@@ -454,6 +455,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F3, 0xD010, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xC050, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0xD050, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0xD0B0, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F3, 0xB0B0, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x8010, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x8110, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x9010, iwl8260_2ac_cfg)},
-- 
2.8.1

