Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49251 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1FURnf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 13:43:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: add some debug options.
Date: Tue, 21 Jun 2011 19:43:26 +0200
Message-Id: <1308678206-12934-2-git-send-email-hauke@hauke-m.de> (sfid-20110621_194339_032082_907023BB)
In-Reply-To: <1308678206-12934-1-git-send-email-hauke@hauke-m.de>
References: <1308678206-12934-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These options are only needed for debugging so they are deactivated.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 4e5e08c..d0e93bf 100644
--- a/config.mk
+++ b/config.mk
@@ -221,6 +221,7 @@ CONFIG_MAC80211_HWSIM=m
 
 CONFIG_ATH5K=m
 # CONFIG_ATH5K_DEBUG=y
+# CONFIG_ATH5K_TRACER=y
 # CONFIG_ATH5K_AHB=y
 
 CONFIG_ATH9K=m
@@ -248,6 +249,7 @@ CONFIG_IWLAGN=m
 # CONFIG_IWLWIFI_DEBUG=y
 # CONFIG_IWLWIFI_DEBUGFS=y
 # CONFIG_IWLWIFI_DEVICE_TRACING=y
+# CONFIG_IWLWIFI_DEVICE_SVTOOL=y
 # CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
 CONFIG_IWL_P2P=y
 
@@ -560,6 +562,7 @@ endif #CONFIG_COMPAT_KERNEL_2_6_27
 
 CONFIG_IWM=m
 # CONFIG_IWM_DEBUG=y
+# CONFIG_IWM_TRACING=y
 
 CONFIG_BT_HCIBTSDIO=m
 CONFIG_BT_MRVL_SDIO=m
-- 
1.7.4.1

