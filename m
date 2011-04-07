Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52689 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1DGOkS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 10:40:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: Remove extra config option for kfifo.
Date: Thu,  7 Apr 2011 16:39:45 +0200
Message-Id: <1302187186-15327-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kfifo is now build when CONFIG_COMPAT_KERNEL_36 is set.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/config.mk b/config.mk
index 5f861ca..846d2e0 100644
--- a/config.mk
+++ b/config.mk
@@ -107,11 +107,6 @@ ifdef CONFIG_FW_LOADER
 endif #CONFIG_FW_LOADER
 endif #CONFIG_COMPAT_KERNEL_33
 
-ifdef CONFIG_COMPAT_KERNEL_36
-CONFIG_COMPAT_KFIFO=m
-endif #CONFIG_COMPAT_KERNEL_36
-
-
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
 
-- 
1.7.1

