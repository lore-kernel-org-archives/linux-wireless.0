Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43472 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab1GQU5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 16:57:41 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: add some new config options for b43
Date: Sun, 17 Jul 2011 22:57:29 +0200
Message-Id: <1310936250-10224-1-git-send-email-hauke@hauke-m.de> (sfid-20110717_225748_280137_C3BC1BE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 3cae526..c7ed0a0 100644
--- a/config.mk
+++ b/config.mk
@@ -273,6 +273,7 @@ endif #CONFIG_MAC80211_LEDS
 CONFIG_B43_PHY_LP=y
 CONFIG_B43_PHY_N=y
 # CONFIG_B43_PHY_HT=y
+# CONFIG_B43_PHY_LCN=y
 # CONFIG_B43_FORCE_PIO=y
 # CONFIG_B43_DEBUG=y
 
@@ -334,6 +335,7 @@ CONFIG_BCMA_BLOCKIO=y
 CONFIG_BCMA_HOST_PCI=y
 # CONFIG_BCMA_DEBUG=y
 # CONFIG_B43_BCMA=y
+# CONFIG_B43_BCMA_PIO=y
 
 CONFIG_P54_PCI=m
 
-- 
1.7.4.1

