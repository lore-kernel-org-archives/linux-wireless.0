Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0KPQGk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:40 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/18] iwlagn: set dynamic aggregation threshold for BT
Date: Tue, 16 Nov 2010 08:01:35 -0800
Message-Id: <1289923311-14920-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setting the max/min/def value for BT dynamic aggregation threshold.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 31c29a5..a3cd811 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2410,9 +2410,9 @@ struct iwl_link_quality_cmd {
 #define BT_FRAG_THRESHOLD_MAX	0
 #define BT_FRAG_THRESHOLD_MIN	0
 
-#define BT_AGG_THRESHOLD_DEF	0
-#define BT_AGG_THRESHOLD_MAX	0
-#define BT_AGG_THRESHOLD_MIN	0
+#define BT_AGG_THRESHOLD_DEF	1200
+#define BT_AGG_THRESHOLD_MAX	8000
+#define BT_AGG_THRESHOLD_MIN	400
 
 /*
  * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
-- 
1.7.0.4

