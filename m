Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277AbZKMT4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:41 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/16] iwlwifi: remove external reference for non-exist data structure
Date: Fri, 13 Nov 2009 11:56:27 -0800
Message-Id: <1258142198-3223-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Number of data structure for 6000 series no longer in production, the
data structure already being removed; also need to remove the external
reference define in iwl-dev.h

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 273adee..774a315 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -55,9 +55,6 @@ extern struct iwl_cfg iwl5350_agn_cfg;
 extern struct iwl_cfg iwl5100_bg_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
-extern struct iwl_cfg iwl6000h_2agn_cfg;
-extern struct iwl_cfg iwl6000h_2abg_cfg;
-extern struct iwl_cfg iwl6000h_2bg_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
 extern struct iwl_cfg iwl6000i_2abg_cfg;
 extern struct iwl_cfg iwl6000i_2bg_cfg;
-- 
1.5.6.3

