Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53283 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab1EJLLu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 07:11:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 3/3] compat-wireless: enable RT33XX and RT53XX support.
Date: Tue, 10 May 2011 13:11:36 +0200
Message-Id: <1305025896-12586-3-git-send-email-hauke@hauke-m.de> (sfid-20110510_131153_829885_D9D08847)
In-Reply-To: <1305025896-12586-1-git-send-email-hauke@hauke-m.de>
References: <1305025896-12586-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is based on a patch by Walter Goldens.

CC: Walter Goldens <goldenstranger@yahoo.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index 3411743..76044a5 100644
--- a/config.mk
+++ b/config.mk
@@ -326,9 +326,9 @@ CONFIG_RT2400PCI=m
 CONFIG_RT2500PCI=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800PCI=m
-# CONFIG_RT2800PCI_RT33XX=y
+CONFIG_RT2800PCI_RT33XX=y
 # CONFIG_RT2800PCI_RT35XX=y
-# CONFIG_RT2800PCI_RT53XX=y
+CONFIG_RT2800PCI_RT53XX=y
 endif #CONFIG_CRC_CCITT
 NEED_RT2X00=y
 
@@ -451,8 +451,9 @@ CONFIG_ATH9K_HTC=m
 CONFIG_RT2500USB=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800USB=m
-# CONFIG_RT2800USB_RT33XX=y
+CONFIG_RT2800USB_RT33XX=y
 # CONFIG_RT2800USB_RT35XX=y
+CONFIG_RT2800USB_RT53XX=y
 CONFIG_RT2800USB_UNKNOWN=y
 endif #CONFIG_CRC_CCITT
 CONFIG_RT2X00_LIB_USB=m
-- 
1.7.4.1

