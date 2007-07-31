Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbXGaSeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:25 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:24 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/24] rt2x00: Include <linux/delay.h>
Date: Tue, 31 Jul 2007 20:37:35 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.35354.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 4e359c1ed171f1918b105431047d8c7adcf6e7fc Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Mon, 30 Jul 2007 18:04:25 +0200
Subject: [PATCH 19/24] rt2x00: Include <linux/delay.h>

Recent header cleanup removed the linux/delay.h header,
this header was however still needed for x86.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    1 +
 drivers/net/wireless/rt2500pci.c |    1 +
 drivers/net/wireless/rt2500usb.c |    1 +
 drivers/net/wireless/rt61pci.c   |    1 +
 drivers/net/wireless/rt73usb.c   |    1 +
 5 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index e9bf565..4ea2217 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -29,6 +29,7 @@
  */
 #define DRV_NAME "rt2400pci"
 
+#include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 7661a82..6e9d3ad 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -29,6 +29,7 @@
  */
 #define DRV_NAME "rt2500pci"
 
+#include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 2e19634..753ee36 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -29,6 +29,7 @@
  */
 #define DRV_NAME "rt2500usb"
 
+#include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index d574297..b280d7b 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -29,6 +29,7 @@
  */
 #define DRV_NAME "rt61pci"
 
+#include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 9875e39..a076e28 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -29,6 +29,7 @@
  */
 #define DRV_NAME "rt73usb"
 
+#include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-- 
1.5.2.4

