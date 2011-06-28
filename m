Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34419 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760649Ab1F1SjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 14:39:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: add rtl8192de
Date: Tue, 28 Jun 2011 20:38:52 +0200
Message-Id: <1309286332-12470-3-git-send-email-hauke@hauke-m.de> (sfid-20110628_205755_610613_D0ADB025)
In-Reply-To: <1309286332-12470-1-git-send-email-hauke@hauke-m.de>
References: <1309286332-12470-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk               |    1 +
 scripts/admin-update.sh |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index d0e93bf..3cae526 100644
--- a/config.mk
+++ b/config.mk
@@ -392,6 +392,7 @@ endif #CONFIG_WIRELESS_EXT
 
 CONFIG_RTL8192CE=m
 CONFIG_RTL8192SE=m
+CONFIG_RTL8192DE=m
 
 ifdef CONFIG_COMPAT_STAGING
 CONFIG_BRCMSMAC=m
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 7b2d1f8..74c177f 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -237,6 +237,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192c"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192ce"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192cu"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192se"
+DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192de"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
 DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
-- 
1.7.4.1

