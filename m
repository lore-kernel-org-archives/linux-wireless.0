Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33077 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547Ab1FIWER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:04:17 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 07/11] compat-wireless: activate CONFIG_RT2800{USB,PCI}_RT35XX by default.
Date: Fri, 10 Jun 2011 00:03:38 +0200
Message-Id: <1307657022-23808-8-git-send-email-hauke@hauke-m.de> (sfid-20110610_000437_118880_7649F8F3)
In-Reply-To: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
References: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now activated by default in the Kconfig so it should be save for us too.

Add to compat-3.0-stable

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index 29e6e06..da1ebeb 100644
--- a/config.mk
+++ b/config.mk
@@ -340,7 +340,7 @@ CONFIG_RT2500PCI=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800PCI=m
 CONFIG_RT2800PCI_RT33XX=y
-# CONFIG_RT2800PCI_RT35XX=y
+CONFIG_RT2800PCI_RT35XX=y
 # CONFIG_RT2800PCI_RT53XX=y
 endif #CONFIG_CRC_CCITT
 NEED_RT2X00=y
@@ -469,7 +469,7 @@ CONFIG_RT2500USB=m
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

