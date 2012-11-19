Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:33837 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2KSLvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 06:51:48 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so724893dak.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 03:51:48 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: johannes.berg@intel.com, ilw@linux.intel.com,
	wey-yi.w.guy@intel.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] iwlwifi: Remove duplicate inclusion of iwl-trans.h in pcie/drv.c
Date: Mon, 19 Nov 2012 17:15:40 +0530
Message-Id: <1353325540-9338-1-git-send-email-sachin.kamat@linaro.org> (sfid-20121119_125157_651111_5B3E39AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl-trans.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 2a46753..956fe6c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -69,7 +69,6 @@
 
 #include "iwl-trans.h"
 #include "iwl-drv.h"
-#include "iwl-trans.h"
 
 #include "cfg.h"
 #include "internal.h"
-- 
1.7.4.1

