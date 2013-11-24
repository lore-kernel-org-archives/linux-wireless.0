Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37167 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3KXUHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:14 -0500
Received: by mail-wi0-f175.google.com with SMTP id hi5so2725969wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:12 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/29] iwlwifi: mvm: a few more SKUs for 7260 and 3160
Date: Sun, 24 Nov 2013 22:06:35 +0200
Message-Id: <1385323606-3603-18-git-send-email-egrumbach@gmail.com> (sfid-20131124_210807_820779_7571C237)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These devices are not sold as discrete modules but are
rather soldered down to the board.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 941c0c8..c1efc03 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -297,6 +297,9 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x08B2, 0x4370, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0x4360, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x5070, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x5072, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x5170, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x5770, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x4020, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x402A, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0x4220, iwl7260_2n_cfg)},
@@ -350,6 +353,8 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x08B4, 0x8270, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8470, iwl3160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B3, 0x8570, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x1070, iwl3160_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x1170, iwl3160_2ac_cfg)},
 
 /* 7265 Series */
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
-- 
1.7.9.5

