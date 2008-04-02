Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbYDBRug (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 13:50:36 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Miles Lane <miles.lane@gmail.com>
Subject: [PATCH] iwl4965: use IWLWIFI_LEDS config variable
Date: Wed,  2 Apr 2008 10:50:35 -0700
Message-Id: <1207158635-14328-1-git-send-email-reinette.chatre@intel.com> (sfid-20080402_185040_416586_EBF4C15E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix error reported by Miles Lane <miles.lane@gmail.com>

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: Miles Lane <miles.lane@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index c8e7028..25fc09d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1057,7 +1057,7 @@ struct iwl_priv {
 	struct iwl_rfkill_mngr rfkill_mngr;
 #endif
 
-#ifdef CONFIG_IWL4965_LEDS
+#ifdef CONFIG_IWLWIFI_LEDS
 	struct iwl4965_led led[IWL_LED_TRG_MAX];
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
-- 
1.5.3.4

