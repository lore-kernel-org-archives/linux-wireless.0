Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759945AbXG3C7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 22:59:44 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 6/8] iwlwifi: fix compile error when CONFIG_IWLWIFI_HT is not selected
Date: Mon, 30 Jul 2007 10:57:04 +0800
Message-Id: <11857642444000-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11857642421391-git-send-email-yi.zhu@intel.com>
References: <11857642261522-git-send-email-yi.zhu@intel.com>
 <11857642343783-git-send-email-yi.zhu@intel.com>
 <11857642362891-git-send-email-yi.zhu@intel.com>
 <1185764238442-git-send-email-yi.zhu@intel.com>
 <11857642401149-git-send-email-yi.zhu@intel.com>
 <11857642421391-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965-rs.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965-rs.c b/drivers/net/wireless/iwl-4965-rs.c
index 6f3d4ab..7d4a980 100644
--- a/drivers/net/wireless/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwl-4965-rs.c
@@ -2007,11 +2007,7 @@ static void rs_free(void *data)
 
 static void rs_clear(void *priv_rate)
 {
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
 	struct iwl_priv *priv = (struct iwl_priv *) priv_rate;
-#endif /*CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
 
 	IWL_DEBUG_RATE("NOP\n");
 
-- 
1.5.2
