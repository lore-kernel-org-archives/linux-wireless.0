Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59208 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759954Ab0GQOxj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jul 2010 10:53:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/3] iwlwifi: additional statistic debug counter
Date: Sat, 17 Jul 2010 07:55:14 -0700
Message-Id: <1279378516-31290-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279378516-31290-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279378516-31290-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add wait_for_silence_timeout_cnt to statistics_dbg structure

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 74ad10f..83247f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3035,7 +3035,8 @@ struct iwl39_statistics_tx {
 struct statistics_dbg {
 	__le32 burst_check;
 	__le32 burst_count;
-	__le32 reserved[4];
+	__le32 wait_for_silence_timeout_cnt;
+	__le32 reserved[3];
 } __attribute__ ((packed));
 
 struct iwl39_statistics_div {
-- 
1.7.0.4

