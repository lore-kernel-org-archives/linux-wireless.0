Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0KJSBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/16] iwlagn: update PCI ID for 6000g2a series devices
Date: Wed, 10 Nov 2010 09:56:36 -0800
Message-Id: <1289411810-23093-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the supported PCI ID list for 6000g2a series devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d6891a4..83a5405 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4428,13 +4428,6 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
 
 /* 6x00 Series Gen2a */
-	{IWL_PCI_DEVICE(0x0082, 0x1201, iwl6000g2a_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0085, 0x1211, iwl6000g2a_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1221, iwl6000g2a_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1206, iwl6000g2a_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0085, 0x1216, iwl6000g2a_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1226, iwl6000g2a_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1207, iwl6000g2a_2bg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6000g2a_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1306, iwl6000g2a_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1307, iwl6000g2a_2bg_cfg)},
-- 
1.7.0.4

