Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbbCVRVo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 13:21:44 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/6] iwlwifi: add new 3165 series PCI IDs
Date: Sun, 22 Mar 2015 19:21:31 +0200
Message-Id: <1427044892-13907-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150322_182148_960419_1787E9B5)
In-Reply-To: <1427044767.8611.4.camel@egrumbacBox>
References: <1427044767.8611.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add new 3165 PCI IDs for new 1x1 cards.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index dbd6bcf..686dd30 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -368,10 +368,12 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 /* 3165 Series */
 	{IWL_PCI_DEVICE(0x3165, 0x4010, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x4012, iwl3165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x3165, 0x4110, iwl3165_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x3165, 0x4210, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x4410, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x4510, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4110, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3166, 0x4310, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3166, 0x4210, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x8010, iwl3165_2ac_cfg)},
 
 /* 7265 Series */
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
-- 
1.9.1

