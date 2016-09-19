Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55952 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934266AbcISHba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:31:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Oren Givon <oren.givon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:23 +0300
Message-Id: <20160919073028.22065-20-luca@coelho.fi> (sfid-20160919_093137_233884_7682CF6C)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 20/25] iwlwifi: add new 8265 series PCI ID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new PCI ID for the 8265 series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 14c6e94..3d766f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -487,6 +487,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24FD, 0x1130, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0130, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x1010, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x10D0, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0050, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0150, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x9010, iwl8265_2ac_cfg)},
-- 
2.9.3
