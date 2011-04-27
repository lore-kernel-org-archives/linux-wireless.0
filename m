Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm23-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.191]:43314 "HELO
	nm23-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752672Ab1D0JBE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 05:01:04 -0400
Message-ID: <197612.83637.qm@web161606.mail.bf1.yahoo.com> (sfid-20110427_110109_326171_CBDBD017)
Date: Wed, 27 Apr 2011 02:01:03 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Reply-To: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 1/2 re-send] compat-wireless: enable default RT33XX support
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable rt2x00 support for rt33xx devices 

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/config.mk
+++ b/config.mk
@@ -326,7 +326,7 @@ CONFIG_RT2400PCI=m
 CONFIG_RT2500PCI=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800PCI=m
-# CONFIG_RT2800PCI_RT33XX=y
+CONFIG_RT2800PCI_RT33XX=y
 # CONFIG_RT2800PCI_RT35XX=y
 # CONFIG_RT2800PCI_RT53XX=y
 endif #CONFIG_CRC_CCITT
@@ -450,7 +450,7 @@ CONFIG_ATH9K_HTC=m
 CONFIG_RT2500USB=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800USB=m
-# CONFIG_RT2800USB_RT33XX=y
+CONFIG_RT2800USB_RT33XX=y
 # CONFIG_RT2800USB_RT35XX=y
 CONFIG_RT2800USB_UNKNOWN=y
 endif #CONFIG_CRC_CCITT

