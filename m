Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:60118 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaCDRgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 12:36:46 -0500
Received: by mail-we0-f171.google.com with SMTP id t61so2820231wes.16
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 09:36:46 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] iwlwifi: fix and add 7265 series HW IDs
Date: Tue,  4 Mar 2014 19:36:39 +0200
Message-Id: <1393954599-11270-2-git-send-email-egrumbach@gmail.com> (sfid-20140304_183652_965254_646F235C)
In-Reply-To: <53160EF4.8090005@gmail.com>
References: <53160EF4.8090005@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Update of the HW IDs for the 7265 series.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index f47bcbe..3872ead 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -359,13 +359,12 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 /* 7265 Series */
 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5110, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095A, 0x5112, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5100, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095A, 0x510A, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5310, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095B, 0x5302, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x5302, iwl7265_n_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5210, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5012, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5412, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5410, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5400, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x1010, iwl7265_2ac_cfg)},
-- 
1.8.3.2

