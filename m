Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbZFCShT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:37:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwlwifi: fix comment describing disable_11n
Date: Wed,  3 Jun 2009 11:44:12 -0700
Message-Id: <1244054652-19451-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244054652-19451-6-git-send-email-reinette.chatre@intel.com>
References: <1244054652-19451-1-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-2-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-3-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-4-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-5-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Fixing a comment in the code describing this module parameter.
The description printed when user runs "modinfo" is correct.

Reported-by: Jiajia Zheng <jiajia.zheng@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4173a40..b52d0fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -182,7 +182,7 @@ struct iwl_mod_params {
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
 	int num_of_ampdu_queues;/* def: HW dependent */
-	int disable_11n;	/* def: 0 = disable 11n capabilities */
+	int disable_11n;	/* def: 0 = 11n capabilities enabled */
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
 	int antenna;  		/* def: 0 = both antennas (use diversity) */
 	int restart_fw;		/* def: 1 = restart firmware */
-- 
1.5.6.3

