Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58140 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaIISI7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 14:08:59 -0400
From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH] iwlwifi/iwl-drv.c: fix typo defualt -> default
Date: Tue,  9 Sep 2014 20:08:53 +0200
Message-Id: <1410286133-14817-1-git-send-email-toralf.foerster@gmx.de> (sfid-20140909_200905_817760_E7CD7819)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

trivial, but this is user visible b/c it is in the help text

Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 77e3178..8019939 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1359,7 +1359,7 @@ MODULE_PARM_DESC(fw_restart, "restart firmware in case of error (default true)")
 module_param_named(antenna_coupling, iwlwifi_mod_params.ant_coupling,
 		   int, S_IRUGO);
 MODULE_PARM_DESC(antenna_coupling,
-		 "specify antenna coupling in dB (defualt: 0 dB)");
+		 "specify antenna coupling in dB (default: 0 dB)");
 
 module_param_named(wd_disable, iwlwifi_mod_params.wd_disable, int, S_IRUGO);
 MODULE_PARM_DESC(wd_disable,
-- 
2.1.0

