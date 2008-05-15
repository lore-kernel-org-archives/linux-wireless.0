Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbYEOF4P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 01/26] iwlwifi: changing irrelevant comment
Date: Thu, 15 May 2008 13:53:53 +0800
Message-Id: <1210830858-3410-2-git-send-email-yi.zhu@intel.com> (sfid-20080515_075621_039352_4B66B27F)
In-Reply-To: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch changes an old eeprom comment in probe flow.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 55ca752..d0f948d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6605,7 +6605,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	if (err)
 		goto out_iounmap;
 
-	/* MAC Address location in EEPROM same for 3945/4965 */
+	/* extract MAC Address */
 	iwl_eeprom_get_mac(priv, priv->mac_addr);
 	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
-- 
1.5.3.6

