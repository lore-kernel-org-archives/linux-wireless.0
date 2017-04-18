Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52864 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755394AbdDRWWI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:22:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Tzipi Peres <tzipi.peres@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:16 +0300
Message-Id: <20170418221729.28372-13-luca@coelho.fi> (sfid-20170419_002211_456984_44DC0EE4)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 12/25] iwlwifi: add four new 8265 and 8275 series PCI IDs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tzipi Peres <tzipi.peres@intel.com>

Add one new PCI ID for the 8265 series.
Add three new PCI ID for the 8275 series.

Signed-off-by: Tzipi Peres <tzipi.peres@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index d38fcc1a4768..52e1d0c9428d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -501,6 +501,10 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24FD, 0x0930, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0950, iwl8265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0850, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x1014, iwl8265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x3E02, iwl8275_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x3E01, iwl8275_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FD, 0x1012, iwl8275_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FD, 0x0012, iwl8275_2ac_cfg)},
 
 /* 9000 Series */
-- 
2.11.0
