Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20654 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab0A2TyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/12] iwlwifi: update sensitivity calibration data for 6x00 series
Date: Fri, 29 Jan 2010 11:53:54 -0800
Message-Id: <1264794842-8046-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Update sensitivity range values for 6000 & 6x50 series

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 81e03e3..a9f8551 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -108,7 +108,7 @@ static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 
 	.auto_corr_max_ofdm = 145,
 	.auto_corr_max_ofdm_mrc = 232,
-	.auto_corr_max_ofdm_x1 = 145,
+	.auto_corr_max_ofdm_x1 = 110,
 	.auto_corr_max_ofdm_mrc_x1 = 232,
 
 	.auto_corr_min_cck = 125,
-- 
1.6.3.3

