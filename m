Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42420 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751557AbdJ2M3H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:29:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:15 +0200
Message-Id: <20171029122816.8802-17-luca@coelho.fi> (sfid-20171029_132917_646067_CA240EEA)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 16/17] iwlwifi: add new cards for 8265 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ihab Zhaika <ihab.zhaika@intel.com>

add two new PCI ID'S for 8265 series

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index a988f41125e0..efa2fbb926cc 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -513,6 +513,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24FD, 0x3E01, iwl8275_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x1012, iwl8275_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0012, iwl8275_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x0014, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x9074, iwl8265_2ac_cfg)},
 
 /* 9000 Series */
 	{IWL_PCI_DEVICE(0x2526, 0x0000, iwl9260_2ac_cfg)},
-- 
2.14.2
