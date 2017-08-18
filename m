Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44576 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751106AbdHRPwS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:52:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>, stable@vger.kernel.org
Date: Fri, 18 Aug 2017 18:49:15 +0300
Message-Id: <20170818154922.2904-18-luca@coelho.fi> (sfid-20170818_175221_550231_68FC4EBA)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
Subject: [PATCH 17/24] iwlwifi: pci: add new PCI ID for 7265D
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We have a new PCI subsystem ID for 7265D.  Add it to the list.

Cc: stable@vger.kernel.org
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 27d1eec1c899..5398a0917f06 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -430,6 +430,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x095B, 0x520A, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9000, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9400, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9E10, iwl7265_2ac_cfg)},
 
 /* 8000 Series */
 	{IWL_PCI_DEVICE(0x24F3, 0x0010, iwl8260_2ac_cfg)},
-- 
2.14.1
