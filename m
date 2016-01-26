Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48526 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965093AbcAZKVt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 05:21:49 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/5] iwlwifi: add new 3168 series devices support
Date: Tue, 26 Jan 2016 12:21:34 +0200
Message-Id: <1453803698-20550-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160126_112157_564391_27571E63)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add new sub-system PCI IDs to the 3168 series.
Added 0x2010, 0x2050 and 0x2150 sub-system IDs.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 6261a68..944e88a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -378,7 +378,10 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x3165, 0x8110, iwl3165_2ac_cfg)},
 
 /* 3168 Series */
+	{IWL_PCI_DEVICE(0x24FB, 0x2010, iwl3168_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FB, 0x2110, iwl3168_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FB, 0x2050, iwl3168_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24FB, 0x2150, iwl3168_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x24FB, 0x0000, iwl3168_2ac_cfg)},
 
 /* 7265 Series */
-- 
2.5.0

