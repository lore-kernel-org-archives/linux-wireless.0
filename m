Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50318 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab1LCOq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 09:46:56 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/6] compat-wireless: add some missing config options
Date: Sat,  3 Dec 2011 15:46:23 +0100
Message-Id: <1322923585-13966-4-git-send-email-hauke@hauke-m.de> (sfid-20111203_154701_104658_D2B93334)
In-Reply-To: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
References: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/config.mk b/config.mk
index 5eabc51..c8256b8 100644
--- a/config.mk
+++ b/config.mk
@@ -171,8 +171,8 @@ CONFIG_MAC80211=m
 # CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
 # CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y
 # CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG=y
+# CONFIG_MAC80211_VERBOSE_TDLS_DEBUG
 # CONFIG_MAC80211_DEBUG_COUNTERS=y
-# CONFIG_MAC80211_DRIVER_API_TRACER=y
 
 # choose between pid and minstrel as default rate control algorithm
 CONFIG_MAC80211_RC_DEFAULT=minstrel_ht
@@ -292,12 +292,11 @@ CONFIG_IWLWIFI=m
 # CONFIG_IWLWIFI_DEVICE_SVTOOL=y
 # CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
 
-CONFIG_IWLWIFI_LEGACY=m
+CONFIG_IWLEGACY=m
 CONFIG_COMPAT_IWL4965=m
 CONFIG_IWL3945=m
-# CONFIG_IWLWIFI_LEGACY_DEBUG=y
-# CONFIG_IWLWIFI_LEGACY_DEBUGFS=y
-# CONFIG_IWLWIFI_LEGACY_DEVICE_TRACING=y
+# CONFIG_IWLEGACY_DEBUG=y
+# CONFIG_IWLEGACY_DEBUGFS=y
 
 
 CONFIG_B43=m
@@ -437,6 +436,8 @@ CONFIG_RTL8192DE=m
 
 CONFIG_BRCMSMAC=m
 
+CONFIG_MWIFIEX_PCIE=m
+
 endif #CONFIG_PCI
 ## end of PCI
 
-- 
1.7.5.4

