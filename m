Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46403 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaGVT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:40 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so1026526wib.8
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:39 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/20] iwlwifi: fix inconsistency about power_save module parameter
Date: Tue, 22 Jul 2014 22:26:45 +0300
Message-Id: <1406057211-31752-14-git-send-email-egrumbach@gmail.com> (sfid-20140722_212745_066903_C2B4DFD5)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

modinfo and kerneldoc disagreed on the meaning of this field.

Reported-by: Andrea Oliveri <oliveriandrea@gmail.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-modparams.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index f2d39cb..71507cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -99,7 +99,7 @@ enum iwl_disable_11n {
  * @wd_disable: disable stuck queue check, default = 1
  * @bt_coex_active: enable bt coex, default = true
  * @led_mode: system default, default = 0
- * @power_save: disable power save, default = false
+ * @power_save: enable power save, default = false
  * @power_level: power level, default = 1
  * @debug_level: levels are IWL_DL_*
  * @ant_coupling: antenna coupling in dB, default = 0
-- 
1.8.3.2

