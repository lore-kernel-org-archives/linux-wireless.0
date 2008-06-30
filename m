Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbYF3J0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:26:35 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/33] iwlwifi: add REPLY_TX_POWER_DBM_CMD to get_cmd_string
Date: Mon, 30 Jun 2008 17:23:05 +0800
Message-Id: <1214817813-17639-6-git-send-email-yi.zhu@intel.com> (sfid-20080630_112637_634612_4D9FF911)
In-Reply-To: <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds REPLY_TX_POWER_DBM_CMD to get_cmd_string.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-hcmd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 6c53736..8fa991b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -93,6 +93,7 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(CALIBRATION_CFG_CMD);
 		IWL_CMD(CALIBRATION_RES_NOTIFICATION);
 		IWL_CMD(CALIBRATION_COMPLETE_NOTIFICATION);
+		IWL_CMD(REPLY_TX_POWER_DBM_CMD);
 	default:
 		return "UNKNOWN";
 
-- 
1.5.3.6

