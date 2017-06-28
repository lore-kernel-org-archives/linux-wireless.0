Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35940 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751557AbdF1UOt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:14:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Tzipi Peres <tzipi.peres@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:14 +0300
Message-Id: <20170628201330.9432-16-luca@coelho.fi> (sfid-20170628_221456_083565_BD0AEA99)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 15/31] iwlwifi: add twelve new 9560 series PCI IDs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tzipi Peres <tzipi.peres@intel.com>

Add twelve new PCI IDs for the 9560 series.

Signed-off-by: Tzipi Peres <tzipi.peres@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index e995b055be4e..7bf765ba5235 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016-2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -35,6 +35,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
+ * Copyright(c) 2017 Intel Deutschland GmbH
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -535,6 +536,18 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA370, 0x1030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0034, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0xA370, 0x0034, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0034, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0038, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0038, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0xA370, 0x0038, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0038, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0xA370, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x31DC, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0034, iwl9560_2ac_cfg)},
 
 /* a000 Series */
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr_cdb)},
-- 
2.11.0
