Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47827 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab1BXSx3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 13:53:29 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: some minor updates for config.mk
Date: Thu, 24 Feb 2011 19:53:08 +0100
Message-Id: <1298573588-2943-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1298573588-2943-1-git-send-email-hauke@hauke-m.de>
References: <1298573588-2943-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 8007708..dd6aa60 100644
--- a/config.mk
+++ b/config.mk
@@ -330,6 +330,7 @@ ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800PCI=m
 # CONFIG_RT2800PCI_RT33XX=y
 # CONFIG_RT2800PCI_RT35XX=y
+# CONFIG_RT2800PCI_RT53XX=y
 endif #CONFIG_CRC_CCITT
 NEED_RT2X00=y
 
@@ -547,10 +548,10 @@ ifneq ($(CONFIG_COMPAT_STAGING),)
 
 CONFIG_BRCM80211=m
 CONFIG_BRCMSMAC=y
+# CONFIG_BRCMDBG=y
 
 ifdef CONFIG_WIRELESS_EXT
 CONFIG_ATH6KL_CFG80211=y
-CONFIG_ATH6KL_DEBUG=y
 # CONFIG_ATH6KL_DISABLE_TARGET_DBGLOGS is not set
 # CONFIG_ATH6KL_ENABLE_COEXISTENCE is not set
 # CONFIG_ATH6KL_ENABLE_HOST_DEBUG is not set
-- 
1.7.1

