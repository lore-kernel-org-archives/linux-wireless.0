Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3GZITd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:19:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/7] iwlwifi: add DELL SKU for 5150 HMC
Date: Fri, 26 Jul 2013 10:19:22 +0200
Message-Id: <1374826768-2440-1-git-send-email-johannes@sipsolutions.net> (sfid-20130726_101938_055939_9E008ECB)
In-Reply-To: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
References: <1374826675.8248.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This SKU was missing in the list of supported devices

https://bugzilla.kernel.org/show_bug.cgi?id=60577

Cc: <stable@vger.kernel.org> [all versions]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 81f3ea5..ff13458 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -130,6 +130,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x423C, 0x1306, iwl5150_abg_cfg)}, /* Half Mini Card */
 	{IWL_PCI_DEVICE(0x423C, 0x1221, iwl5150_agn_cfg)}, /* Mini Card */
 	{IWL_PCI_DEVICE(0x423C, 0x1321, iwl5150_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1326, iwl5150_abg_cfg)}, /* Half Mini Card */
 
 	{IWL_PCI_DEVICE(0x423D, 0x1211, iwl5150_agn_cfg)}, /* Mini Card */
 	{IWL_PCI_DEVICE(0x423D, 0x1311, iwl5150_agn_cfg)}, /* Half Mini Card */
-- 
1.8.0

