Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.unikorn.me ([176.9.143.13]:34800 "EHLO mail.unikorn.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750970AbeC0Kn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 06:43:56 -0400
Message-ID: <4d583f7b1a1953114a4dcbb85976918866b82648.camel@unikorn.me> (sfid-20180327_124400_980235_30242671)
Subject: [PATCH] iwlwifi: add device ID for Rivet Networks Killer
 Wireless-AC 1550
From: Izzy Kulbe <kernel@unikorn.me>
To: kvalo@codeaurora.org, luciano.coelho@intel.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 12:43:50 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for Rivet Networks Killer Wireless-AC 1550 chipset, 
which is using the Intel Wireless-AC 9260 chip

Signed-off-by: Izzy Kulbe <kernel@unikorn.me>

---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 56fc28750a41..62ab4790687c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -543,6 +543,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2526, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1410, iwl9270_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2526, 0x1550, iwl9270_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1610, iwl9270_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_cfg)},
-- 
2.16.2
