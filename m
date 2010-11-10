Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab0KJSBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/16] iwlagn: update PCI ID for 6000g2b series devices
Date: Wed, 10 Nov 2010 09:56:35 -0800
Message-Id: <1289411810-23093-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the supported PCI ID list for 6000g2b series devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6a82b20..d6891a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4444,24 +4444,12 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6000g2a_2abg_cfg)},
 
 /* 6x00 Series Gen2b */
-	{IWL_PCI_DEVICE(0x008F, 0x5105, iwl6000g2b_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0090, 0x5115, iwl6000g2b_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x008F, 0x5125, iwl6000g2b_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x008F, 0x5107, iwl6000g2b_bg_cfg)},
-	{IWL_PCI_DEVICE(0x008F, 0x5201, iwl6000g2b_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0090, 0x5211, iwl6000g2b_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x008F, 0x5221, iwl6000g2b_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x008F, 0x5206, iwl6000g2b_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6000g2b_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x008F, 0x5226, iwl6000g2b_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x008F, 0x5207, iwl6000g2b_2bg_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5301, iwl6000g2b_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl6000g2b_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x008A, 0x5307, iwl6000g2b_bg_cfg)},
-	{IWL_PCI_DEVICE(0x008A, 0x5321, iwl6000g2b_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x008A, 0x5325, iwl6000g2b_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x008B, 0x5311, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008A, 0x5327, iwl6000g2b_bg_cfg)},
 	{IWL_PCI_DEVICE(0x008B, 0x5315, iwl6000g2b_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x008B, 0x5317, iwl6000g2b_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0090, 0x5211, iwl6000g2b_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0090, 0x5215, iwl6000g2b_2bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0090, 0x5216, iwl6000g2b_2abg_cfg)},
-- 
1.7.0.4

