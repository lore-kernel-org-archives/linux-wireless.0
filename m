Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbcC3OGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/43] iwlwifi: edit the 9000 series PCI IDs
Date: Wed, 30 Mar 2016 17:05:03 +0300
Message-Id: <1459346715-7954-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160714_111286_07386209)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Edit some of the 9560 series and 5165 series PCI IDs.
These devices do not exist yet.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index fb8b5ec..41c6dd5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -483,17 +483,19 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24FD, 0x0810, iwl8265_2ac_cfg)},
 
 /* 9000 Series */
+	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0A10, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl5165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl5165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0210, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0410, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0610, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9560_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
2.5.0

