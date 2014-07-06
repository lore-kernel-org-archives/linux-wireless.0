Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:32945 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGFJgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:24 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so5480972wiv.8
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:23 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/40] iwlwifi: fix naming mistake for the fw_monitor module parameter
Date: Sun,  6 Jul 2014 12:35:37 +0300
Message-Id: <1404639376-3792-1-git-send-email-egrumbach@gmail.com> (sfid-20140706_113627_589683_5503C3B7)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index bb842f4..77e3178 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1407,5 +1407,5 @@ MODULE_PARM_DESC(power_level,
 		 "default power save level (range from 1 - 5, default: 1)");
 
 module_param_named(fw_monitor, iwlwifi_mod_params.fw_monitor, bool, S_IRUGO);
-MODULE_PARM_DESC(dbgm,
+MODULE_PARM_DESC(fw_monitor,
 		 "firmware monitor - to debug FW (default: false - needs lots of memory)");
-- 
1.8.3.2

