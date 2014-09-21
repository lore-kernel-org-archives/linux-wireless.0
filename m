Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:63632 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaIUTWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:22:43 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/17] iwlwifi: Add missing PCI IDs for the 7260 series
Date: Sun, 21 Sep 2014 22:22:12 +0300
Message-Id: <1411327338-23099-11-git-send-email-egrumbach@gmail.com> (sfid-20140921_213114_374613_029B8763)
In-Reply-To: <541F23D2.90600@gmail.com>
References: <541F23D2.90600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add 4 missing PCI IDs for the 7260 series.

Cc: <stable@vger.kernel.org> [3.10+]
Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index ca68c3c..6ced854 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -275,6 +275,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x08B1, 0x4070, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4072, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4170, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4C60, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4C70, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4060, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x406A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4160, iwl7260_2n_cfg)},
@@ -318,6 +320,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x08B1, 0xC770, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0xC760, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC270, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xCC70, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xCC60, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC272, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC260, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0xC26A, iwl7260_n_cfg)},
-- 
1.9.1

