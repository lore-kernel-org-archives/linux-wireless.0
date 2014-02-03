Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:61227 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaBCUjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:39:33 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so3911075eaj.21
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:39:32 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/8] iwlwifi: add more 7265 HW IDs
Date: Mon,  3 Feb 2014 22:39:18 +0200
Message-Id: <1391459962-7381-4-git-send-email-egrumbach@gmail.com> (sfid-20140203_213939_255605_FB56653B)
In-Reply-To: <52EFFCE8.6070505@gmail.com>
References: <52EFFCE8.6070505@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Add 6 new HW IDs for the 7265 series.

Cc: <stable@vger.kernel.org> [3.13]
Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 3040924..f47bcbe 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -359,20 +359,25 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 /* 7265 Series */
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5110, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5112, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5100, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x510A, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5310, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5302, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5210, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5012, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095A, 0x500A, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5410, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5400, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x1010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5000, iwl7265_2n_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x500A, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5200, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5002, iwl7265_n_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5202, iwl7265_n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9010, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9012, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9110, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x9112, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9210, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9510, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9310, iwl7265_2ac_cfg)},
-- 
1.7.9.5

