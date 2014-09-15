Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56727 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaIOFN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:29 -0400
Received: by mail-wi0-f178.google.com with SMTP id ho1so3392350wib.5
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:28 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/28] iwlwifi/iwl-drv.c: fix typo defualt -> default
Date: Mon, 15 Sep 2014 08:12:48 +0300
Message-Id: <1410757980-2138-16-git-send-email-egrumbach@gmail.com> (sfid-20140915_073115_220463_3629F8B0)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Toralf Förster <toralf.foerster@gmx.de>

trivial, but this is user visible b/c it is in the help text

Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index aefd94c..ed673ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1363,7 +1363,7 @@ MODULE_PARM_DESC(fw_restart, "restart firmware in case of error (default true)")
 module_param_named(antenna_coupling, iwlwifi_mod_params.ant_coupling,
 		   int, S_IRUGO);
 MODULE_PARM_DESC(antenna_coupling,
-		 "specify antenna coupling in dB (defualt: 0 dB)");
+		 "specify antenna coupling in dB (default: 0 dB)");
 
 module_param_named(wd_disable, iwlwifi_mod_params.wd_disable, int, S_IRUGO);
 MODULE_PARM_DESC(wd_disable,
-- 
1.9.1

