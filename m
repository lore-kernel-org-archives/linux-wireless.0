Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55748 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbZLVPV2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 10:21:28 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: autoconf.h moved from linux/ to generated/ with kernel 2.6.33
Date: Tue, 22 Dec 2009 16:20:02 +0100
Message-Id: <1261495204-28966-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
References: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed the headers, because autoconf.h moved from linux/ into generated/

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.14.h |    3 ++-
 include/linux/compat-2.6.18.h |    3 ++-
 include/linux/compat-2.6.19.h |    2 +-
 include/linux/compat-2.6.21.h |    2 +-
 include/linux/compat-2.6.22.h |    2 +-
 include/linux/compat-2.6.23.h |    2 +-
 include/linux/compat-2.6.24.h |    3 ++-
 include/linux/compat-2.6.25.h |    2 +-
 include/linux/compat-2.6.26.h |    2 +-
 include/linux/compat-2.6.27.h |    2 +-
 include/linux/compat-2.6.28.h |    2 +-
 include/linux/compat-2.6.29.h |    2 +-
 include/linux/compat-2.6.30.h |    3 ++-
 include/linux/compat-2.6.31.h |    2 +-
 include/linux/compat-2.6.32.h |    2 +-
 include/linux/compat-2.6.33.h |    4 ++--
 include/linux/compat-2.6.h    |    6 +++++-
 17 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/include/linux/compat-2.6.14.h b/include/linux/compat-2.6.14.h
index 22e7e31..c509899 100644
--- a/include/linux/compat-2.6.14.h
+++ b/include/linux/compat-2.6.14.h
@@ -1,12 +1,13 @@
 #ifndef LINUX_26_14_COMPAT_H
 #define LINUX_26_14_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.14 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14))
 
+#include <linux/autoconf.h>
+
 typedef unsigned int gfp_t;
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)) */
diff --git a/include/linux/compat-2.6.18.h b/include/linux/compat-2.6.18.h
index 3245c42..ef0dd31 100644
--- a/include/linux/compat-2.6.18.h
+++ b/include/linux/compat-2.6.18.h
@@ -1,12 +1,13 @@
 #ifndef LINUX_26_18_COMPAT_H
 #define LINUX_26_18_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.18 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18))
 
+#include <linux/autoconf.h>
+
 #define roundup(x, y)	((((x) + ((y) - 1)) / (y)) * (y))
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)) */
diff --git a/include/linux/compat-2.6.19.h b/include/linux/compat-2.6.19.h
index 017044c..67f87fc 100644
--- a/include/linux/compat-2.6.19.h
+++ b/include/linux/compat-2.6.19.h
@@ -1,12 +1,12 @@
 #ifndef LINUX_26_19_COMPAT_H
 #define LINUX_26_19_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.19 */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19))
 
+#include <linux/autoconf.h>
 #include <linux/slab.h>
 
 static inline int
diff --git a/include/linux/compat-2.6.21.h b/include/linux/compat-2.6.21.h
index 263ebd2..25ac354 100644
--- a/include/linux/compat-2.6.21.h
+++ b/include/linux/compat-2.6.21.h
@@ -1,12 +1,12 @@
 #ifndef LINUX_26_21_COMPAT_H
 #define LINUX_26_21_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.21 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
 
+#include <linux/autoconf.h>
 #include <linux/sysctl.h>
 
 #define register_sysctl_table(table)				\
diff --git a/include/linux/compat-2.6.22.h b/include/linux/compat-2.6.22.h
index 85cd9d5..42dc805 100644
--- a/include/linux/compat-2.6.22.h
+++ b/include/linux/compat-2.6.22.h
@@ -1,12 +1,12 @@
 #ifndef LINUX_26_22_COMPAT_H
 #define LINUX_26_22_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.21 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22))
 
+#include <linux/autoconf.h>
 #include <linux/pci.h>
 #include <linux/skbuff.h>
 
diff --git a/include/linux/compat-2.6.23.h b/include/linux/compat-2.6.23.h
index c36f90d..c73b77f 100644
--- a/include/linux/compat-2.6.23.h
+++ b/include/linux/compat-2.6.23.h
@@ -1,12 +1,12 @@
 #ifndef LINUX_26_23_COMPAT_H
 #define LINUX_26_23_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for < 2.6.23 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
 
+#include <linux/autoconf.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
diff --git a/include/linux/compat-2.6.24.h b/include/linux/compat-2.6.24.h
index 43e6302..91a3b85 100644
--- a/include/linux/compat-2.6.24.h
+++ b/include/linux/compat-2.6.24.h
@@ -1,12 +1,13 @@
 #ifndef LINUX_26_24_COMPAT_H
 #define LINUX_26_24_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.21, 2.6.22 and 2.6.23 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
 
+#include <linux/autoconf.h>
+
 /* Added on 2.6.24 in include/linux/types.h by Al viro on commit 142956af */
 typedef unsigned long               uintptr_t;
 
diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index 23cf487..7477cb6 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -1,12 +1,12 @@
 #ifndef LINUX_26_25_COMPAT_H
 #define LINUX_26_25_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.24 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
 
+#include <linux/autoconf.h>
 #include <linux/types.h>
 #include <linux/io.h>
 #include <linux/hw_random.h>
diff --git a/include/linux/compat-2.6.26.h b/include/linux/compat-2.6.26.h
index b7c3b05..143df3b 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -1,11 +1,11 @@
 #ifndef LINUX_26_26_COMPAT_H
 #define LINUX_26_26_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26))
 
+#include <linux/autoconf.h>
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index ed10a6c..f77bb7b 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -1,11 +1,11 @@
 #ifndef LINUX_26_27_COMPAT_H
 #define LINUX_26_27_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27))
 
+#include <linux/autoconf.h>
 #include <linux/list.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 8f90edc..700eab6 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -1,11 +1,11 @@
 #ifndef LINUX_26_28_COMPAT_H
 #define LINUX_26_28_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
 
+#include <linux/autoconf.h>
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
 #include <linux/usb.h>
diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index cad5e6b..b3c9dc2 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -1,11 +1,11 @@
 #ifndef LINUX_26_29_COMPAT_H
 #define LINUX_26_29_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
 
+#include <linux/autoconf.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/usb.h>
diff --git a/include/linux/compat-2.6.30.h b/include/linux/compat-2.6.30.h
index 2ff1d69..f0074d8 100644
--- a/include/linux/compat-2.6.30.h
+++ b/include/linux/compat-2.6.30.h
@@ -1,11 +1,12 @@
 #ifndef LINUX_26_30_COMPAT_H
 #define LINUX_26_30_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
 
+#include <linux/autoconf.h>
+
 #ifndef TP_PROTO
 #define TP_PROTO(args...)	TPPROTO(args)
 #endif
diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index 27dc6a1..d51e9e2 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -1,11 +1,11 @@
 #ifndef LINUX_26_31_COMPAT_H
 #define LINUX_26_31_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31))
 
+#include <linux/autoconf.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index 727ac71..a6ed8c4 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -1,11 +1,11 @@
 #ifndef LINUX_26_32_COMPAT_H
 #define LINUX_26_32_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
 
+#include <linux/autoconf.h>
 #include <linux/netdevice.h>
 #include <asm/compat.h>
 #include <net/iw_handler.h>
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 5367cd9..a453a7e 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -1,12 +1,12 @@
 #ifndef LINUX_26_33_COMPAT_H
 #define LINUX_26_33_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
-#include <linux/compat_autoconf.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
 
+#include <linux/autoconf.h>
+#include <linux/compat_autoconf.h>
 #include <linux/skbuff.h>
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cistpl.h>
diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index bea00c9..81224de 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -1,8 +1,12 @@
 #ifndef LINUX_26_COMPAT_H
 #define LINUX_26_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,33))
+#include <generated/autoconf.h>
+#else
+#include <linux/autoconf.h>
+#endif
 #include <linux/compat_autoconf.h>
 
 /*
-- 
1.6.3.3

