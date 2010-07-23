Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758706Ab0GWQN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:58 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/10] iwlwifi: remove spurious semicolons
Date: Fri, 23 Jul 2010 09:15:39 -0700
Message-Id: <1279901739-10541-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

defines shouldn't be terminated with a
semicolon, the code using them should
supply it. Luckily these are not used
in a context where it matters.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 67892f9..798bf9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -964,8 +964,8 @@ struct iwl_qosparam_cmd {
 #define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
 
-#define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2);
-#define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8);
+#define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2)
+#define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8)
 #define STA_FLG_RTS_MIMO_PROT_MSK	cpu_to_le32(1 << 17)
 #define STA_FLG_AGG_MPDU_8US_MSK	cpu_to_le32(1 << 18)
 #define STA_FLG_MAX_AGG_SIZE_POS	(19)
-- 
1.7.0.4

