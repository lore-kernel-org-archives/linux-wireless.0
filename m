Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60884 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751150AbdFBL1m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:27:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:51 +0300
Message-Id: <20170602112553.2466-24-luca@coelho.fi> (sfid-20170602_132800_064747_F75C42B6)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 23/25] iwlwifi: mvm: remove unused REPLY_MAX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This value is unused, and there's no reason we'd ever use it.
Just remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 332f204761cc..ef8b47faa265 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -470,8 +470,6 @@ enum iwl_legacy_cmds {
 	SCAN_OFFLOAD_PROFILES_QUERY_CMD = 0x56,
 	SCAN_OFFLOAD_HOTSPOTS_CONFIG_CMD = 0x58,
 	SCAN_OFFLOAD_HOTSPOTS_QUERY_CMD = 0x59,
-
-	REPLY_MAX = 0xff,
 };
 
 /* Please keep this enum *SORTED* by hex value.
-- 
2.11.0
