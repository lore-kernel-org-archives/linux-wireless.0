Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35885 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZLWAx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 19:53:27 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: autoconf.h moved from linux/ to generated/ with kernel 2.6.33
Date: Wed, 23 Dec 2009 01:53:06 +0100
Message-Id: <1261529586-434-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <43e72e890912220803w3665563aob918a6486f3fc546@mail.gmail.com>
References: <43e72e890912220803w3665563aob918a6486f3fc546@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed the headers, because autoconf.h moved from linux/ into generated/

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

v2:
 - remove linux/autoconf.h from compat-2.6.XX.h. It is already included by compat-2.6.h
---
 include/linux/compat-2.6.14.h |    1 -
 include/linux/compat-2.6.18.h |    1 -
 include/linux/compat-2.6.19.h |    1 -
 include/linux/compat-2.6.21.h |    1 -
 include/linux/compat-2.6.22.h |    1 -
 include/linux/compat-2.6.23.h |    1 -
 include/linux/compat-2.6.24.h |    1 -
 include/linux/compat-2.6.25.h |    1 -
 include/linux/compat-2.6.26.h |    1 -
 include/linux/compat-2.6.27.h |    1 -
 include/linux/compat-2.6.28.h |    1 -
 include/linux/compat-2.6.29.h |    1 -
 include/linux/compat-2.6.30.h |    1 -
 include/linux/compat-2.6.31.h |    1 -
 include/linux/compat-2.6.32.h |    1 -
 include/linux/compat-2.6.33.h |    2 --
 include/linux/compat-2.6.h    |    6 +++++-
 17 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/include/linux/compat-2.6.14.h b/include/linux/compat-2.6.14.h
index 22e7e31..1f19f7f 100644
--- a/include/linux/compat-2.6.14.h
+++ b/include/linux/compat-2.6.14.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_14_COMPAT_H
 #define LINUX_26_14_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.14 */
diff --git a/include/linux/compat-2.6.18.h b/include/linux/compat-2.6.18.h
index 3245c42..5e0182b 100644
--- a/include/linux/compat-2.6.18.h
+++ b/include/linux/compat-2.6.18.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_18_COMPAT_H
 #define LINUX_26_18_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.18 */
diff --git a/include/linux/compat-2.6.19.h b/include/linux/compat-2.6.19.h
index 017044c..1e648c0 100644
--- a/include/linux/compat-2.6.19.h
+++ b/include/linux/compat-2.6.19.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_19_COMPAT_H
 #define LINUX_26_19_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.19 */
diff --git a/include/linux/compat-2.6.21.h b/include/linux/compat-2.6.21.h
index 263ebd2..89ed6d9 100644
--- a/include/linux/compat-2.6.21.h
+++ b/include/linux/compat-2.6.21.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_21_COMPAT_H
 #define LINUX_26_21_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.21 */
diff --git a/include/linux/compat-2.6.22.h b/include/linux/compat-2.6.22.h
index 85cd9d5..7ca1b18 100644
--- a/include/linux/compat-2.6.22.h
+++ b/include/linux/compat-2.6.22.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_22_COMPAT_H
 #define LINUX_26_22_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.21 */
diff --git a/include/linux/compat-2.6.23.h b/include/linux/compat-2.6.23.h
index c36f90d..0b791b0 100644
--- a/include/linux/compat-2.6.23.h
+++ b/include/linux/compat-2.6.23.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_23_COMPAT_H
 #define LINUX_26_23_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for < 2.6.23 */
diff --git a/include/linux/compat-2.6.24.h b/include/linux/compat-2.6.24.h
index 43e6302..58655f6 100644
--- a/include/linux/compat-2.6.24.h
+++ b/include/linux/compat-2.6.24.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_24_COMPAT_H
 #define LINUX_26_24_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.21, 2.6.22 and 2.6.23 */
diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index 23cf487..c645d39 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_25_COMPAT_H
 #define LINUX_26_25_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 /* Compat work for 2.6.24 */
diff --git a/include/linux/compat-2.6.26.h b/include/linux/compat-2.6.26.h
index b7c3b05..af653a9 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_26_COMPAT_H
 #define LINUX_26_26_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26))
diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index ed10a6c..64531a6 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_27_COMPAT_H
 #define LINUX_26_27_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27))
diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 8f90edc..9cd4ae8 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_28_COMPAT_H
 #define LINUX_26_28_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index cad5e6b..8a968fa 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_29_COMPAT_H
 #define LINUX_26_29_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
diff --git a/include/linux/compat-2.6.30.h b/include/linux/compat-2.6.30.h
index 2ff1d69..f997d86 100644
--- a/include/linux/compat-2.6.30.h
+++ b/include/linux/compat-2.6.30.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_30_COMPAT_H
 #define LINUX_26_30_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index 27dc6a1..54ddefd 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_31_COMPAT_H
 #define LINUX_26_31_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31))
diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index 727ac71..c3e4dbe 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -1,7 +1,6 @@
 #ifndef LINUX_26_32_COMPAT_H
 #define LINUX_26_32_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 5367cd9..9bb0dbb 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -1,9 +1,7 @@
 #ifndef LINUX_26_33_COMPAT_H
 #define LINUX_26_33_COMPAT_H
 
-#include <linux/autoconf.h>
 #include <linux/version.h>
-#include <linux/compat_autoconf.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
 
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

