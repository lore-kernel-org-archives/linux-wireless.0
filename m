Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53290 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab1EJLLv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 07:11:51 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: add RTL8192SE driver
Date: Tue, 10 May 2011 13:11:35 +0200
Message-Id: <1305025896-12586-2-git-send-email-hauke@hauke-m.de> (sfid-20110510_131154_395793_6FEBB8E2)
In-Reply-To: <1305025896-12586-1-git-send-email-hauke@hauke-m.de>
References: <1305025896-12586-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk               |    1 +
 scripts/admin-update.sh |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index f4cf832..3411743 100644
--- a/config.mk
+++ b/config.mk
@@ -368,6 +368,7 @@ endif #CONFIG_PCMCIA
 endif #CONFIG_WIRELESS_EXT
 
 CONFIG_RTL8192CE=m
+CONFIG_RTL8192SE=m
 
 endif #CONFIG_PCI
 ## end of PCI
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 3310278..ea123ca 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -235,6 +235,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192c"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192ce"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192cu"
+DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192se"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
 DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
-- 
1.7.4.1

