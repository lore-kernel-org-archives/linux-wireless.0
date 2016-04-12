Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11129 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbcDLIQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 04:16:55 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/4] iwlwifi: add device IDs for the 8265 device
Date: Tue, 12 Apr 2016 11:16:48 +0300
Message-Id: <1460449011-8417-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160412_101659_889134_791D28CA)
In-Reply-To: <1460448889.2630.12.camel@intel.com>
References: <1460448889.2630.12.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add new 8265 series PCI IDs.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 05b9685..79d7cd7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -479,8 +479,18 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24F3, 0x0930, iwl8260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24F3, 0x0000, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0010, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x0110, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x1110, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x1010, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x0050, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x0150, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x9010, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x8110, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x8050, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x8010, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0810, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x9110, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x8130, iwl8265_2ac_cfg)},
 
 /* 9000 Series */
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl5165_2ac_cfg)},
-- 
2.5.0

