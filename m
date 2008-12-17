Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26637 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYLQI7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 03:59:42 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Wu, Fengguang" <fengguang.wu@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/8] iwlwifi: add line feed to printk
Date: Wed, 17 Dec 2008 16:52:28 +0800
Message-Id: <1229503954-30347-3-git-send-email-yi.zhu@intel.com> (sfid-20081217_095948_438512_6D925462)
In-Reply-To: <1229503954-30347-2-git-send-email-yi.zhu@intel.com>
References: <1229503954-30347-1-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wu, Fengguang <fengguang.wu@intel.com>

This adds line feed to printk.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index dce32ff..11eccd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -292,7 +292,7 @@ static int iwl_get_blink_rate(struct iwl_priv *priv)
 			if (tpt  > (blink_tbl[i].tpt * IWL_1MB_RATE))
 				break;
 
-	IWL_DEBUG_LED("LED BLINK IDX=%d", i);
+	IWL_DEBUG_LED("LED BLINK IDX=%d\n", i);
 	return i;
 }
 
-- 
1.5.3.6

