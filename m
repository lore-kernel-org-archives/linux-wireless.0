Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbZKMT4h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:37 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/16] iwlwifi: disable coex until implementation ready for 6x50
Date: Fri, 13 Nov 2009 11:56:24 -0800
Message-Id: <1258142198-3223-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Temporary disable the coex function for wifi/wimax for 6x50
series until the full implementation ready.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f732f6d..72ed944 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -395,7 +395,6 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.support_sm_ps = true,
-	.support_wimax_coexist = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -425,7 +424,6 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.support_wimax_coexist = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
-- 
1.5.6.3

