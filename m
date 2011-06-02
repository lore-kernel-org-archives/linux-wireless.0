Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60510 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab1FBQfu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:35:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/9] compat-wireless: activate CARL9170_WPC by default
Date: Thu,  2 Jun 2011 18:35:22 +0200
Message-Id: <1307032525-18916-7-git-send-email-hauke@hauke-m.de> (sfid-20110602_183605_493430_F97EFE7B)
In-Reply-To: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
References: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 2160409..00408bf 100644
--- a/config.mk
+++ b/config.mk
@@ -454,7 +454,7 @@ ifdef CONFIG_MAC80211_LEDS
 CONFIG_CARL9170_LEDS=y
 endif #CONFIG_MAC80211_LEDS
 # CONFIG_CARL9170_DEBUGFS=y
-# CONFIG_CARL9170_WPC=y
+CONFIG_CARL9170_WPC=y
 endif #CONFIG_COMPAT_KERNEL_2629
 
 # This activates a threading fix for usb urb.
-- 
1.7.4.1

