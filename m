Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42376 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750915AbdJ2M2t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:28:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:16 +0200
Message-Id: <20171029122816.8802-18-luca@coelho.fi> (sfid-20171029_132853_377153_09D9FBE3)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 17/17] iwlwifi: add new cards for a000 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ihab Zhaika <ihab.zhaika@intel.com>

add four new PCI ID'S for a000 series

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index efa2fbb926cc..4a21c12276d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -586,6 +586,11 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x0070, iwla000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0030, iwla000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x1080, iwla000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0090, iwla000_2ac_cfg_hr_cdb)},
+	{IWL_PCI_DEVICE(0x2720, 0x0310, iwla000_2ac_cfg_hr_cdb)},
+	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwla000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x40C0, 0x0A10, iwla000_2ax_cfg_hr)},
+
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
2.14.2
