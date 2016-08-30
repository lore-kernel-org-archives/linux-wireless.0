Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41226 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758217AbcH3LkK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:40:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:38:57 +0300
Message-Id: <1472557142-14782-11-git-send-email-luca@coelho.fi> (sfid-20160830_134013_578266_97343364)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 11/16] iwlwifi: add new 9460 series PCI IDs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add 4 more new 9460 series PCI IDs.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index d053183..3e5a11a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -517,6 +517,10 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0xA370, 0x0060, iwl9460_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0060, iwl9460_2ac_cfg)},
 
 /* a000 Series */
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg)},
-- 
2.8.1
