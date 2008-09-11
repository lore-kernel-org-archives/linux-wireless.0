Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19305 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbYIKDtg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 23:49:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/3] iwlwifi: update 5350 Wifi PCI IDs
Date: Thu, 11 Sep 2008 11:45:20 +0800
Message-Id: <1221104722-8771-2-git-send-email-yi.zhu@intel.com> (sfid-20080911_054940_648932_5BE35056)
In-Reply-To: <1221104722-8771-1-git-send-email-yi.zhu@intel.com>
References: <1221104722-8771-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch updates PCI IDs for 5350 Wifi/WiMax.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 31ea288..21975b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4506,7 +4506,10 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x4235, PCI_ANY_ID, iwl5300_agn_cfg)},
 	{IWL_PCI_DEVICE(0x4236, PCI_ANY_ID, iwl5300_agn_cfg)},
 	{IWL_PCI_DEVICE(0x4237, PCI_ANY_ID, iwl5100_agn_cfg)},
-	{IWL_PCI_DEVICE(0x423A, PCI_ANY_ID, iwl5350_agn_cfg)},
+/* 5350 WiFi/WiMax */
+	{IWL_PCI_DEVICE(0x423A, 0x1001, iwl5350_agn_cfg)},
+	{IWL_PCI_DEVICE(0x423A, 0x1021, iwl5350_agn_cfg)},
+	{IWL_PCI_DEVICE(0x423B, 0x1011, iwl5350_agn_cfg)},
 #endif /* CONFIG_IWL5000 */
 	{0}
 };
-- 
1.5.3.6

