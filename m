Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54430 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751323AbdIOMrV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 08:47:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Oren Givon <oren.givon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 15 Sep 2017 15:46:58 +0300
Message-Id: <20170915124704.9032-5-luca@coelho.fi> (sfid-20170915_144726_763691_702FD455)
In-Reply-To: <20170915124704.9032-1-luca@coelho.fi>
References: <20170915124704.9032-1-luca@coelho.fi>
Subject: [PATCH 04/10] iwlwifi: add a new a000 device
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add a new a000 device with PCI ID (0x2720, 0x0030).

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 3416c6155996..e0966f656376 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -577,6 +577,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwla000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0078, iwla000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0070, iwla000_2ac_cfg_hr_cdb)},
+	{IWL_PCI_DEVICE(0x2720, 0x0030, iwla000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x1080, iwla000_2ax_cfg_hr)},
 #endif /* CONFIG_IWLMVM */
 
-- 
2.14.1
