Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40368 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab1DTVfb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 17:35:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: update config options
Date: Wed, 20 Apr 2011 23:35:12 +0200
Message-Id: <1303335312-6970-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1303335312-6970-1-git-send-email-hauke@hauke-m.de>
References: <1303335312-6970-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index 37f32a1..f4cf832 100644
--- a/config.mk
+++ b/config.mk
@@ -209,9 +209,12 @@ CONFIG_MAC80211_HWSIM=m
 CONFIG_ATH5K=m
 # CONFIG_ATH5K_DEBUG=y
 # CONFIG_ATH5K_AHB=y
+
+CONFIG_ATH9K=m
 CONFIG_ATH9K_HW=m
 CONFIG_ATH9K_COMMON=m
 # CONFIG_ATH9K_DEBUGFS=y
+# CONFIG_ATH9K_AHB=y
 # CONFIG_ATH9K_PKTLOG=y
 
 # Disable this to get minstrel as default, we leave the ath9k
@@ -226,7 +229,7 @@ CONFIG_ATH9K_RATE_CONTROL=y
 ifdef CONFIG_PCI
 
 CONFIG_ATH5K_PCI=y
-CONFIG_ATH9K=m
+CONFIG_ATH9K_PCI=y
 
 CONFIG_IWLAGN=m
 # CONFIG_IWLWIFI_DEBUG=y
@@ -540,7 +543,6 @@ CONFIG_BRCMSMAC=y
 # CONFIG_BRCMDBG=y
 
 ifdef CONFIG_WIRELESS_EXT
-CONFIG_ATH6KL_CFG80211=y
 # CONFIG_ATH6KL_DISABLE_TARGET_DBGLOGS is not set
 # CONFIG_ATH6KL_ENABLE_COEXISTENCE is not set
 # CONFIG_ATH6KL_ENABLE_HOST_DEBUG is not set
@@ -567,7 +569,6 @@ ifeq ($(NEED_RT2X00),y)
 CONFIG_RT2X00=y
 CONFIG_RT2X00_LIB=m
 CONFIG_RT2800_LIB=m
-CONFIG_RT2X00_LIB_HT=y
 CONFIG_RT2X00_LIB_FIRMWARE=y
 CONFIG_RT2X00_LIB_CRYPTO=y
 # CONFIG_RT2X00_LIB_SOC=y
-- 
1.7.1

