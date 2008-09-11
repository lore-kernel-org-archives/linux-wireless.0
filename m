Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19305 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbYIKDtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 23:49:39 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/3] iwlwifi: add MODULE_FIRMWARE for 5000 HW
Date: Thu, 11 Sep 2008 11:45:21 +0800
Message-Id: <1221104722-8771-3-git-send-email-yi.zhu@intel.com> (sfid-20080911_054941_788375_DE28EC36)
In-Reply-To: <1221104722-8771-2-git-send-email-yi.zhu@intel.com>
References: <1221104722-8771-1-git-send-email-yi.zhu@intel.com>
 <1221104722-8771-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds MODULE_FIRMWARE statement for 5000 HW.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cccd84c..f6003e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1569,6 +1569,8 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 };
 
+MODULE_FIRMWARE("iwlwifi-5000" IWL5000_UCODE_API ".ucode");
+
 module_param_named(disable50, iwl50_mod_params.disable, int, 0444);
 MODULE_PARM_DESC(disable50,
 		  "manually disable the 50XX radio (default 0 [radio on])");
-- 
1.5.3.6

