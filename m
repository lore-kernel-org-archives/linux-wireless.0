Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:56677 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab3LaRBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:01:04 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so5743874eaj.9
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:01:03 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlwifi: add new devices for 7265 series
Date: Tue, 31 Dec 2013 19:00:57 +0200
Message-Id: <1388509257-21100-1-git-send-email-egrumbach@gmail.com> (sfid-20131231_180108_048768_E1B9F029)
In-Reply-To: <52C2F7EA.3050600@gmail.com>
References: <52C2F7EA.3050600@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add new device / subdevice ID for 7265 series.
Fix 2 mistakes on the way.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 8660502..e627254 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -357,21 +357,27 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x095B, 0x5310, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5302, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5210, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095B, 0x5012, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095B, 0x500A, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5012, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x500A, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5410, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5400, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x1010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5000, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5200, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5002, iwl7265_n_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5202, iwl7265_n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9010, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9110, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9210, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9510, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9310, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9410, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5020, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x502A, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5420, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5090, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5190, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5590, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5290, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5490, iwl7265_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
-- 
1.7.9.5

