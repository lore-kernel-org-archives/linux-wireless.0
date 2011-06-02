Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60520 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab1FBQfw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:35:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/9] compat-wireless: activate CONFIG_RT2800{USB,PCI}_RT35XX by default.
Date: Thu,  2 Jun 2011 18:35:23 +0200
Message-Id: <1307032525-18916-8-git-send-email-hauke@hauke-m.de> (sfid-20110602_183606_048386_32DA274C)
In-Reply-To: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
References: <1307032525-18916-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now activated by default in the Kconfig so it should be save for us too.

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index 00408bf..0a60ab9 100644
--- a/config.mk
+++ b/config.mk
@@ -341,7 +341,7 @@ CONFIG_RT2500PCI=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800PCI=m
 CONFIG_RT2800PCI_RT33XX=y
-# CONFIG_RT2800PCI_RT35XX=y
+CONFIG_RT2800PCI_RT35XX=y
 # CONFIG_RT2800PCI_RT53XX=y
 endif #CONFIG_CRC_CCITT
 NEED_RT2X00=y
@@ -470,7 +470,7 @@ CONFIG_RT2500USB=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800USB=m
 CONFIG_RT2800USB_RT33XX=y
-# CONFIG_RT2800USB_RT35XX=y
+CONFIG_RT2800USB_RT35XX=y
 # CONFIG_RT2800USB_RT53XX=y
 CONFIG_RT2800USB_UNKNOWN=y
 endif #CONFIG_CRC_CCITT
-- 
1.7.4.1

