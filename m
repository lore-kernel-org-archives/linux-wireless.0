Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56871 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619AbbJELk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 07:40:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>, <stable@vger.kernerl.org>
Date: Mon,  5 Oct 2015 14:40:44 +0300
Message-Id: <1444045246-9946-6-git-send-email-luca@coelho.fi> (sfid-20151005_134112_446561_646161D3)
In-Reply-To: <1444044666.27220.5.camel@coelho.fi>
References: <1444044666.27220.5.camel@coelho.fi>
Subject: [PATCH 6/8] iwlwifi: pci: add a few more PCI subvendor IDs for the 7265 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add 3 new subdevice IDs for the 0x095A device ID and 2 for the 0x095B
device ID.

Cc: <stable@vger.kernerl.org> [3.13+]
Reported-by: Jeremy <jeremy.bomkamp@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index b0825c4..644b58b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -414,6 +414,11 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x095A, 0x5590, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5290, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5490, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5F10, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x5212, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x520A, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9000, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9400, iwl7265_2ac_cfg)},
 
 /* 8000 Series */
 	{IWL_PCI_DEVICE(0x24F3, 0x0010, iwl8260_2ac_cfg)},
-- 
2.5.3

