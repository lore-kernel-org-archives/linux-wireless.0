Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53212 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753258AbdJMNZV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 09:25:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Oct 2017 16:25:01 +0300
Message-Id: <20171013132502.10473-9-luca@coelho.fi> (sfid-20171013_152607_097697_F4F7A4D3)
In-Reply-To: <20171013132502.10473-1-luca@coelho.fi>
References: <20171013132502.10473-1-luca@coelho.fi>
Subject: [PATCH 8/9] iwlwifi: pcie: sort IDs for the 9000 series for easier comparisons
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

It's hard to find values that are missing in the list, so sorting the
values and comparing them makes it much easier.  To simplify this
task, sort the devices in the list.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 84 +++++++++++++--------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index ce7254ec0514..aa3c07192624 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -512,65 +512,65 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24FD, 0x0012, iwl8275_2ac_cfg)},
 
 /* 9000 Series */
-	{IWL_PCI_DEVICE(0x271B, 0x0010, iwl9160_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x271B, 0x0014, iwl9160_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x271B, 0x0210, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0000, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0014, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0xA014, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0034, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0038, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0064, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x00A0, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x00A4, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0214, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0230, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0234, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0238, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x023C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0260, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x02A0, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x02A4, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1410, iwl9270_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1610, iwl9270_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x40A4, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0xA014, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x271B, 0x0010, iwl9160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x271B, 0x0014, iwl9160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x271B, 0x0210, iwl9160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0034, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0038, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0034, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0038, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0060, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0210, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0310, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0410, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0510, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0610, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0A10, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0060, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0260, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0064, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x00A4, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x40A4, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x02A4, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x00A0, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x02A0, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0060, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA370, 0x0060, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0060, iwl9460_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0230, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0234, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0238, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x023C, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA370, 0x0030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x1030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0xA370, 0x1030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0034, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA370, 0x0034, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0034, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0038, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x003C, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0038, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA370, 0x0038, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0038, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x003C, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA370, 0x003C, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x31DC, 0x003C, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0034, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0xA370, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0xA370, 0x1030, iwl9560_2ac_cfg)},
 
 /* a000 Series */
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr_cdb)},
-- 
2.14.2
