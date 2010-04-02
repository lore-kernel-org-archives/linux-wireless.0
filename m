Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29646 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab0DBUi6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:38:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/7] iwlwifi: remove irrelevant comments
Date: Fri,  2 Apr 2010 13:38:49 -0700
Message-Id: <1270240734-12825-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
References: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Removing irrelevant comments from iwl-agn.c

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8262f43..8b66010 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -83,13 +83,6 @@ MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("iwl4965");
 
-/*************** STATION TABLE MANAGEMENT ****
- * mac80211 should be examined to determine if sta_info is duplicating
- * the functionality provided here
- */
-
-/**************************************************************/
-
 /**
  * iwl_commit_rxon - commit staging_rxon to hardware
  *
-- 
1.6.3.3

