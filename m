Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64052 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaAMUW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:26 -0500
Received: by mail-ee0-f49.google.com with SMTP id d17so941150eek.36
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:25 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/18] iwlwifi: mvm: add REPLY_SF_CFG_CMD to cmd strings
Date: Mon, 13 Jan 2014 22:21:56 +0200
Message-Id: <1389644517-22807-17-git-send-email-egrumbach@gmail.com> (sfid-20140113_213436_794189_AB68C6B4)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 2437a06..a3d43de 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -309,6 +309,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(BT_PROFILE_NOTIFICATION),
 	CMD(BT_CONFIG),
 	CMD(MCAST_FILTER_CMD),
+	CMD(REPLY_SF_CFG_CMD),
 	CMD(REPLY_BEACON_FILTERING_CMD),
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
 	CMD(MAC_PM_POWER_TABLE),
-- 
1.7.9.5

