Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14983 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431AbYDBQjc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 12:39:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: fix incorrect config variable
Date: Wed,  2 Apr 2008 09:39:18 -0700
Message-Id: <1207154358-29025-1-git-send-email-reinette.chatre@intel.com> (sfid-20080402_173951_925377_38D78D56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index ac12269..8114d05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -779,7 +779,7 @@ struct iwl3945_priv {
 	struct iwl3945_init_alive_resp card_alive_init;
 	struct iwl3945_alive_resp card_alive;
 
-#ifdef CONFIG_IWL4965_LEDS
+#ifdef CONFIG_IWL3945_LEDS
 	struct iwl3945_led led[IWL_LED_TRG_MAX];
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
-- 
1.5.3.4

