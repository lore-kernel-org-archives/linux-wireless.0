Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56565 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1KJBdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:31 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/28] iwlwifi: two more SKUs for 6x05 series
Date: Wed,  9 Nov 2011 16:39:06 -0800
Message-Id: <1320885571-19122-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023340_681629_E338CDCC)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add two more SKUs for 6x05 series of device.
First SKU has low 5GHz channels actives, the other SKU has high 5GHz channels actives.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 19cc6a8..9ecfbd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -255,6 +255,8 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0082, 0xC020, iwl6005_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0xC220, iwl6005_2agn_sff_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1341, iwl6005_2agn_d_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1304, iwl6005_2agn_cfg)},/* low 5GHz active */
+	{IWL_PCI_DEVICE(0x0082, 0x1305, iwl6005_2agn_cfg)},/* high 5GHz active */
 
 /* 6x30 Series */
 	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},
-- 
1.7.0.4

