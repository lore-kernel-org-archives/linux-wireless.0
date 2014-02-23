Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44310 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaBWT5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:39 -0500
Received: by mail-wi0-f171.google.com with SMTP id cc10so2368727wib.4
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:38 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/17] iwlwifi: mvm: fix a few wd_disable comments
Date: Sun, 23 Feb 2014 21:57:08 +0200
Message-Id: <1393185428-8524-17-git-send-email-egrumbach@gmail.com> (sfid-20140223_211709_446827_CF8154A1)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Few minor comments.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c       |    3 +--
 drivers/net/wireless/iwlwifi/iwl-modparams.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index d49e9b9..847a0ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1351,8 +1351,7 @@ MODULE_PARM_DESC(antenna_coupling,
 
 module_param_named(wd_disable, iwlwifi_mod_params.wd_disable, int, S_IRUGO);
 MODULE_PARM_DESC(wd_disable,
-		"Disable stuck queue watchdog timer 0=system default, "
-		"1=disable, 2=enable (default: 0)");
+		"Disable stuck queue watchdog timer 0=system default, 1=disable (default: 1)");
 
 module_param_named(nvm_file, iwlwifi_mod_params.nvm_file, charp, S_IRUGO);
 MODULE_PARM_DESC(nvm_file, "NVM file name");
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index 0a84ade..1d100f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -93,7 +93,7 @@ enum iwl_power_level {
  *	use IWL_DISABLE_HT_* constants
  * @amsdu_size_8K: enable 8K amsdu size, default = 0
  * @restart_fw: restart firmware, default = 1
- * @wd_disable: enable stuck queue check, default = 0
+ * @wd_disable: disable stuck queue check, default = 1
  * @bt_coex_active: enable bt coex, default = true
  * @led_mode: system default, default = 0
  * @power_save: disable power save, default = false
-- 
1.7.9.5

