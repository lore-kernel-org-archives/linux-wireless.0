Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48106 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbZKIWVn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:21:43 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] [compat-2.6] Add symbol CONFIG_RT2800_LIB
Date: Mon,  9 Nov 2009 23:21:00 +0100
Message-Id: <1257805260-13265-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1257805260-13265-1-git-send-email-hauke@hauke-m.de>
References: <1257805260-13265-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index ce70832..9a04dea 100644
--- a/config.mk
+++ b/config.mk
@@ -248,6 +248,7 @@ CONFIG_RT2X00_LIB_PCI=m
 CONFIG_RT2400PCI=m
 CONFIG_RT2500PCI=m
 CONFIG_RT2800PCI=m
+CONFIG_RT2800PCI_PCI=y
 NEED_RT2X00=y
 
 # Two rt2x00 drivers require firmware: rt61pci and rt73usb. They depend on
@@ -368,14 +369,13 @@ endif # end of SDIO driver list
 
 # Common rt2x00 requirements
 ifeq ($(NEED_RT2X00),y)
-CONFIG_RT2X00=m
+CONFIG_RT2X00=y
 CONFIG_RT2X00_LIB=m
+CONFIG_RT2800_LIB=m
 CONFIG_RT2X00_LIB_HT=y
 CONFIG_RT2X00_LIB_FIRMWARE=y
 CONFIG_RT2X00_LIB_CRYPTO=y
-CONFIG_RT2X00_LIB_RFKILL=y
 CONFIG_RT2X00_LIB_LEDS=y
-# CONFIG_RT2X00_LIB_DEBUGFS=y
 # CONFIG_RT2X00_DEBUG=y
 endif
 
-- 
1.6.3.3

