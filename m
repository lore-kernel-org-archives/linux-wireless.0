Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35016 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751134AbdFYLNJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:13:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:56 +0300
Message-Id: <20170625111158.1792-25-luca@coelho.fi> (sfid-20170625_131314_090445_3F1010E3)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 24/26] iwlwifi: mvm: fix typo in CTDP_CMD_OPERATION_REPORT description
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 224d10b1b076..b84e8ddbbbc9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -2130,7 +2130,7 @@ struct ct_kill_notif {
 * enum ctdp_cmd_operation - CTDP command operations
 * @CTDP_CMD_OPERATION_START: update the current budget
 * @CTDP_CMD_OPERATION_STOP: stop ctdp
-* @CTDP_CMD_OPERATION_REPORT: get the avgerage budget
+* @CTDP_CMD_OPERATION_REPORT: get the average budget
 */
 enum iwl_mvm_ctdp_cmd_operation {
 	CTDP_CMD_OPERATION_START	= 0x1,
-- 
2.11.0
