Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbYDXAPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 09/16] iwlwifi: rs fix wrong parenthesizing in rs_get_lower_rate function
Date: Wed, 23 Apr 2008 17:15:01 -0700
Message-Id: <1208996108-15326-10-git-send-email-reinette.chatre@intel.com> (sfid-20080424_023546_053220_EC1E0CCA)
In-Reply-To: <1208996108-15326-9-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-8-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 1ad6256..469c143 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -735,7 +735,7 @@ static u32 rs_get_lower_rate(struct iwl4965_lq_sta *lq_sta,
 		else
 			tbl->lq_type = LQ_G;
 
-		if (num_of_ant(tbl->ant_type > 1))
+		if (num_of_ant(tbl->ant_type) > 1)
 			tbl->ant_type = ANT_A;/*FIXME:RS*/
 
 		tbl->is_fat = 0;
-- 
1.5.3.4

