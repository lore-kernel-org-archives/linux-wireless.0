Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3A1JhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:37:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/37] iwlwifi: clean up CMD_MODE enum
Date: Mon, 28 Jan 2013 10:37:09 +0100
Message-Id: <1359365864-4259-3-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103731_996703_4D110762)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just format the enum better.

Change-Id: I16cfc815676e12fadea1640f3496a91a6b804c0a
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index ce878b9..d4ab24b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -193,11 +193,11 @@ struct iwl_rx_packet {
  * @CMD_ON_DEMAND: This command is sent by the test mode pipe.
  */
 enum CMD_MODE {
-	CMD_SYNC = 0,
-	CMD_ASYNC = BIT(0),
-	CMD_WANT_SKB = BIT(1),
-	CMD_WANT_HCMD = BIT(2),
-	CMD_ON_DEMAND = BIT(3),
+	CMD_SYNC		= 0,
+	CMD_ASYNC		= BIT(0),
+	CMD_WANT_SKB		= BIT(1),
+	CMD_WANT_HCMD		= BIT(2),
+	CMD_ON_DEMAND		= BIT(3),
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
-- 
1.8.0

