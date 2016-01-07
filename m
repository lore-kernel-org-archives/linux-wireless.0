Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48375 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbcAGMrq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>, <stable@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/21] iwlwifi: update and fix 7265 series PCI IDs
Date: Thu,  7 Jan 2016 14:47:22 +0200
Message-Id: <1452170861-10060-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134902_097478_D18DA88B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Update and fix some 7265 PCI IDs entries.

CC: <stable@vger.kernel.org> [3.13+]
Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index af10651..6261a68 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -388,6 +388,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x095B, 0x5310, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5302, iwl7265_n_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5210, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095A, 0x5C10, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5012, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5412, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5410, iwl7265_2ac_cfg)},
@@ -405,10 +406,10 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x095A, 0x900A, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9110, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9112, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095A, 0x9210, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x9210, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x9200, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9510, iwl7265_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x095A, 0x9310, iwl7265_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x095B, 0x9310, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x9410, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5020, iwl7265_2n_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x502A, iwl7265_2n_cfg)},
-- 
2.5.0

