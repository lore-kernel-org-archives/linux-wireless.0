Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934530Ab1IOTcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:05 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/27] iwlagn: New SKU for 6005 SFF
Date: Thu, 15 Sep 2011 11:46:36 -0700
Message-Id: <1316112414-6341-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213313_278660_396F32BB)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding another SKU for 6005 series devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 78a3f8d..1be0bc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -260,6 +260,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0xC020, iwl6005_2agn_sff_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0xC220, iwl6005_2agn_sff_cfg)},
 
 /* 6x30 Series */
 	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},
-- 
1.7.0.4

