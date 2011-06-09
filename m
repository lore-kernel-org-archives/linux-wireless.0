Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33068 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab1FIWEM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:04:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 06/11] compat-wireless: activate CARL9170_WPC by default
Date: Fri, 10 Jun 2011 00:03:37 +0200
Message-Id: <1307657022-23808-7-git-send-email-hauke@hauke-m.de> (sfid-20110610_000418_371552_999FEAFC)
In-Reply-To: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
References: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 2a0c229..29e6e06 100644
--- a/config.mk
+++ b/config.mk
@@ -453,7 +453,7 @@ ifdef CONFIG_MAC80211_LEDS
 CONFIG_CARL9170_LEDS=y
 endif #CONFIG_MAC80211_LEDS
 # CONFIG_CARL9170_DEBUGFS=y
-# CONFIG_CARL9170_WPC=y
+CONFIG_CARL9170_WPC=y
 endif #CONFIG_COMPAT_KERNEL_2_6_29
 
 # This activates a threading fix for usb urb.
-- 
1.7.4.1

