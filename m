Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47300 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1IURG1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 13:06:27 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: remove old config options
Date: Wed, 21 Sep 2011 19:06:17 +0200
Message-Id: <1316624777-8001-2-git-send-email-hauke@hauke-m.de> (sfid-20110921_190633_988906_AC6937ED)
In-Reply-To: <1316624777-8001-1-git-send-email-hauke@hauke-m.de>
References: <1316624777-8001-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both config options have be removed from the Kconfig files in the
kernel and are not used by the code any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index 802bf38..3463f83 100644
--- a/config.mk
+++ b/config.mk
@@ -252,7 +252,6 @@ CONFIG_IWLAGN=m
 # CONFIG_IWLWIFI_DEVICE_TRACING=y
 # CONFIG_IWLWIFI_DEVICE_SVTOOL=y
 # CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
-CONFIG_IWL_P2P=y
 
 CONFIG_IWLWIFI_LEGACY=m
 CONFIG_COMPAT_IWL4965=m
@@ -623,7 +622,6 @@ endif #CONFIG_COMPAT_STAGING
 ifdef CONFIG_CRC7
 CONFIG_WL1251=m
 CONFIG_WL12XX=m
-CONFIG_WL12XX_HT=y
 endif #CONFIG_CRC7
 
 CONFIG_MWIFIEX=m
-- 
1.7.4.1

