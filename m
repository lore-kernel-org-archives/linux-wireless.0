Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59364 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751225AbdFEUnB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:10 +0300
Message-Id: <20170605204218.30151-18-luca@coelho.fi> (sfid-20170605_224326_503488_A718A042)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 17/25] iwlwifi: fix a kernel-doc tag
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The kernel-doc here is on an enum, so don't tag it as struct
but correctly as enum instead, preventing an error.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index d3a78a11821a..63e4857718c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -308,7 +308,7 @@ struct iwl_device_cmd {
 #define IWL_MAX_CMD_TBS_PER_TFD	2
 
 /**
- * struct iwl_hcmd_dataflag - flag for each one of the chunks of the command
+ * enum iwl_hcmd_dataflag - flag for each one of the chunks of the command
  *
  * @IWL_HCMD_DFL_NOCOPY: By default, the command is copied to the host command's
  *	ring. The transport layer doesn't map the command's buffer to DMA, but
-- 
2.11.0
