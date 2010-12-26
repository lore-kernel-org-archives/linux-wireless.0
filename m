Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32206 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab0LZS1v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 13:27:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/3] iwlwifi: remove reference to Gen2
Date: Sun, 26 Dec 2010 10:17:58 -0800
Message-Id: <1293387478-3297-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1293387478-3297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1293387478-3297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

The correct name should be used for the newer devices, remove
reference to Gen2

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b54d74d..5f11dc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4412,7 +4412,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x4239, 0x1311, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
 
-/* 6x00 Series Gen2a */
+/* 6x05 Series */
 	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1306, iwl6005_2abg_cfg)},
 	{IWL_PCI_DEVICE(0x0082, 0x1307, iwl6005_2bg_cfg)},
@@ -4421,7 +4421,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6005_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0085, 0x1316, iwl6005_2abg_cfg)},
 
-/* 6x00 Series Gen2b */
+/* 6x30 Series */
 	{IWL_PCI_DEVICE(0x008A, 0x5305, iwl1030_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x008A, 0x5307, iwl1030_bg_cfg)},
 	{IWL_PCI_DEVICE(0x008A, 0x5325, iwl1030_bgn_cfg)},
@@ -4447,7 +4447,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0089, 0x1311, iwl6050_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0089, 0x1316, iwl6050_2abg_cfg)},
 
-/* 6x50 WiFi/WiMax Series Gen2 */
+/* 6150 WiFi/WiMax Series */
 	{IWL_PCI_DEVICE(0x0885, 0x1305, iwl6150_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0885, 0x1306, iwl6150_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0885, 0x1325, iwl6150_bgn_cfg)},
-- 
1.7.0.4

