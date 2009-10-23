Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24355 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZJWUms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 18/18] iwlwifi: minor comments changes for wimax co-exist command
Date: Fri, 23 Oct 2009 13:42:36 -0700
Message-Id: <1256330556-20997-19-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

'COEX_PRIORITY_TABLE_CMD' host command will be supported for 5000 series
and up.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 0d660a7..954bad6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -109,7 +109,7 @@ enum {
 	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* 4965 only */
 
 	/* WiMAX coexistence */
-	COEX_PRIORITY_TABLE_CMD = 0x5a,	/*5000 only */
+	COEX_PRIORITY_TABLE_CMD = 0x5a,	/* for 5000 series and up */
 	COEX_MEDIUM_NOTIFICATION = 0x5b,
 	COEX_EVENT_CMD = 0x5c,
 
-- 
1.5.6.3

