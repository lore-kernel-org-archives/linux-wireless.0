Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52445 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbXKGGGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 01:06:30 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/5] iwlwifi: replace 0x8086 with PCI_VENDOR_ID_INTEL
Date: Tue,  6 Nov 2007 22:06:24 -0800
Message-Id: <1194415589137-git-send-email-reinette.chatre@intel.com> (sfid-20071107_060636_983325_512193C6)
In-Reply-To: <11944155883607-git-send-email-reinette.chatre@intel.com>
References: <11944155883607-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Replace 0x8086 with PCI_VENDOR_ID_INTEL for PCI_DEVICE declaration.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index e9cb40e..101b970 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2267,8 +2267,8 @@ void iwl_hw_cancel_deferred_work(struct iwl_priv *priv)
 }
 
 struct pci_device_id iwl_hw_card_ids[] = {
-	{PCI_DEVICE(0x8086, 0x4222)},
-	{PCI_DEVICE(0x8086, 0x4227)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4222)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4227)},
 	{0}
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index fed2357..620f125 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4690,8 +4690,8 @@ void iwl_hw_cancel_deferred_work(struct iwl_priv *priv)
 }
 
 struct pci_device_id iwl_hw_card_ids[] = {
-	{PCI_DEVICE(0x8086, 0x4229)},
-	{PCI_DEVICE(0x8086, 0x4230)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4229)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4230)},
 	{0}
 };
 
-- 
1.5.2.5
