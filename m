Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:65191 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaLRILZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 03:11:25 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so873401wiw.9
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 00:11:24 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/5] iwlwifi: add new device IDs for 3165
Date: Thu, 18 Dec 2014 10:10:00 +0200
Message-Id: <1418890201-15177-4-git-send-email-egrumbach@gmail.com> (sfid-20141218_091130_103980_83D08509)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5CD8C0@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A few device IDs were added, reflect this change in the
driver.

Cc; <stable@vger.kernel.org> [3.13+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 3ee8e38..2f0c4b1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -367,7 +367,11 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 /* 3165 Series */
 	{IWL_PCI_DEVICE(0x3165, 0x4010, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4012, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4110, iwl3165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3165, 0x4210, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4410, iwl3165_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x3165, 0x4510, iwl3165_2ac_cfg)},
 
 /* 7265 Series */
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
-- 
1.9.1

