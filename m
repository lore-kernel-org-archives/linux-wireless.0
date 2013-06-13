Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37982 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3FMUNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 16:13:51 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] backports: rename compat file descriptions
Date: Thu, 13 Jun 2013 13:13:44 -0700
Message-Id: <1371154424-18088-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130613_221356_551689_4A167844)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Make these descriptions generic.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 backport/compat/backport-3.11.c  |    2 +-
 backport/compat/compat-2.6.25.c  |    2 +-
 backport/compat/compat-2.6.26.c  |    2 +-
 backport/compat/compat-2.6.27.c  |    2 +-
 backport/compat/compat-2.6.28.c  |    2 +-
 backport/compat/compat-2.6.29.c  |    2 +-
 backport/compat/compat-2.6.32.c  |    2 +-
 backport/compat/compat-2.6.33.c  |    2 +-
 backport/compat/compat-2.6.34.c  |    2 +-
 backport/compat/compat-2.6.35.c  |    2 +-
 backport/compat/compat-2.6.36.c  |    2 +-
 backport/compat/compat-2.6.37.c  |    2 +-
 backport/compat/compat-2.6.39.c  |    2 +-
 backport/compat/compat-3.0.c     |    2 +-
 backport/compat/compat-3.1.c     |    2 +-
 backport/compat/compat-3.3.c     |    2 +-
 backport/compat/compat-3.4.c     |    2 +-
 backport/compat/compat-3.5.c     |    2 +-
 backport/compat/compat-3.7.c     |    2 +-
 backport/compat/compat-3.8.c     |    2 +-
 backport/compat/compat-3.9.c     |    2 +-
 backport/compat/user_namespace.c |    3 +--
 22 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/backport/compat/backport-3.11.c b/backport/compat/backport-3.11.c
index 72e0800..dc9073e 100644
--- a/backport/compat/backport-3.11.c
+++ b/backport/compat/backport-3.11.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2013  Hauke Mehrtens <hauke@hauke-m.de>
  *
- * Compatibility file for Linux wireless for kernels 3.11.
+ * Backport functionality introduced in Linux 3.11.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/backport/compat/compat-2.6.25.c b/backport/compat/compat-2.6.25.c
index 20cc3db..b1459f1 100644
--- a/backport/compat/compat-2.6.25.c
+++ b/backport/compat/compat-2.6.25.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.25.
+ * Backport functionality introduced in Linux 2.6.25.
  */
 
 #include <linux/miscdevice.h>
diff --git a/backport/compat/compat-2.6.26.c b/backport/compat/compat-2.6.26.c
index 9063a6a..f80058a 100644
--- a/backport/compat/compat-2.6.26.c
+++ b/backport/compat/compat-2.6.26.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.26.
+ * Backport functionality introduced in Linux 2.6.26.
  *
  * Copyright holders from ported work:
  *
diff --git a/backport/compat/compat-2.6.27.c b/backport/compat/compat-2.6.27.c
index 79bbed5..cda98e8 100644
--- a/backport/compat/compat-2.6.27.c
+++ b/backport/compat/compat-2.6.27.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.27
+ * Backport functionality introduced in Linux 2.6.27
  */
 #include <linux/debugfs.h>
 #include <linux/compat.h>
diff --git a/backport/compat/compat-2.6.28.c b/backport/compat/compat-2.6.28.c
index 451e614..e47626b 100644
--- a/backport/compat/compat-2.6.28.c
+++ b/backport/compat/compat-2.6.28.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.28.
+ * Backport functionality introduced in Linux 2.6.28.
  */
 
 #include <linux/compat.h>
diff --git a/backport/compat/compat-2.6.29.c b/backport/compat/compat-2.6.29.c
index 1beb718..d216407 100644
--- a/backport/compat/compat-2.6.29.c
+++ b/backport/compat/compat-2.6.29.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.29.
+ * Backport functionality introduced in Linux 2.6.29.
  */
 
 #include <linux/compat.h>
diff --git a/backport/compat/compat-2.6.32.c b/backport/compat/compat-2.6.32.c
index 68ab03e..7d76b40 100644
--- a/backport/compat/compat-2.6.32.c
+++ b/backport/compat/compat-2.6.32.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.32.
+ * Backport functionality introduced in Linux 2.6.32.
  */
 
 #include <linux/compat.h>
diff --git a/backport/compat/compat-2.6.33.c b/backport/compat/compat-2.6.33.c
index 565836c..b6115ba 100644
--- a/backport/compat/compat-2.6.33.c
+++ b/backport/compat/compat-2.6.33.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.33.
+ * Backport functionality introduced in Linux 2.6.33.
  */
 
 #include <linux/compat.h>
diff --git a/backport/compat/compat-2.6.34.c b/backport/compat/compat-2.6.34.c
index 863be64..b257df1 100644
--- a/backport/compat/compat-2.6.34.c
+++ b/backport/compat/compat-2.6.34.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.34.
+ * Backport functionality introduced in Linux 2.6.34.
  */
 
 #include <linux/mmc/sdio_func.h>
diff --git a/backport/compat/compat-2.6.35.c b/backport/compat/compat-2.6.35.c
index f6e2672..86ea557 100644
--- a/backport/compat/compat-2.6.35.c
+++ b/backport/compat/compat-2.6.35.c
@@ -6,7 +6,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.35.
+ * Backport functionality introduced in Linux 2.6.35.
  */
 
 #include <linux/compat.h>
diff --git a/backport/compat/compat-2.6.36.c b/backport/compat/compat-2.6.36.c
index 92ef827..ea6443d 100644
--- a/backport/compat/compat-2.6.36.c
+++ b/backport/compat/compat-2.6.36.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.36.
+ * Backport functionality introduced in Linux 2.6.36.
  */
 
 #include <linux/compat.h>
diff --git a/backport/compat/compat-2.6.37.c b/backport/compat/compat-2.6.37.c
index 3ef2909..5c6cc7b 100644
--- a/backport/compat/compat-2.6.37.c
+++ b/backport/compat/compat-2.6.37.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.37.
+ * Backport functionality introduced in Linux 2.6.37.
  */
 
 #include <linux/compat.h>
diff --git a/backport/compat/compat-2.6.39.c b/backport/compat/compat-2.6.39.c
index 0e36da8..62d8a66 100644
--- a/backport/compat/compat-2.6.39.c
+++ b/backport/compat/compat-2.6.39.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 2.6.39.
+ * Backport functionality introduced in Linux 2.6.39.
  */
 
 #include <linux/compat.h>
diff --git a/backport/compat/compat-3.0.c b/backport/compat/compat-3.0.c
index f52392c..0a993d7 100644
--- a/backport/compat/compat-3.0.c
+++ b/backport/compat/compat-3.0.c
@@ -6,7 +6,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 3.0.
+ * Backport functionality introduced in Linux 3.0.
  */
 
 #include <linux/compat.h>
diff --git a/backport/compat/compat-3.1.c b/backport/compat/compat-3.1.c
index cb5d596..b876329 100644
--- a/backport/compat/compat-3.1.c
+++ b/backport/compat/compat-3.1.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 3.1.
+ * Backport functionality introduced in Linux 3.1.
  */
 
 #include <linux/idr.h>
diff --git a/backport/compat/compat-3.3.c b/backport/compat/compat-3.3.c
index 8489344..a44f59d 100644
--- a/backport/compat/compat-3.3.c
+++ b/backport/compat/compat-3.3.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 3.3.
+ * Backport functionality introduced in Linux 3.3.
  */
 
 #include <linux/kernel.h>
diff --git a/backport/compat/compat-3.4.c b/backport/compat/compat-3.4.c
index 1718cd2..b72c69c 100644
--- a/backport/compat/compat-3.4.c
+++ b/backport/compat/compat-3.4.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 3.4.
+ * Backport functionality introduced in Linux 3.4.
  */
 
 #include <linux/fs.h>
diff --git a/backport/compat/compat-3.5.c b/backport/compat/compat-3.5.c
index 0355ed1..7068cfb 100644
--- a/backport/compat/compat-3.5.c
+++ b/backport/compat/compat-3.5.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 3.5.
+ * Backport functionality introduced in Linux 3.5.
  */
 
 #include <linux/module.h>
diff --git a/backport/compat/compat-3.7.c b/backport/compat/compat-3.7.c
index 284e8dc..0f2d332 100644
--- a/backport/compat/compat-3.7.c
+++ b/backport/compat/compat-3.7.c
@@ -5,7 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels 3.7.
+ * Backport functionality introduced in Linux 3.7.
  */
 
 #include <linux/workqueue.h>
diff --git a/backport/compat/compat-3.8.c b/backport/compat/compat-3.8.c
index 5b1ead9..2884323 100644
--- a/backport/compat/compat-3.8.c
+++ b/backport/compat/compat-3.8.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2006-2012 Jiri Kosina
  * Copyright (c) 2012  Luis R. Rodriguez <mcgrof@do-not-panic.com>
  *
- * Compatibility file for Linux wireless for kernels 3.8.
+ * Backport functionality introduced in Linux 3.8.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/backport/compat/compat-3.9.c b/backport/compat/compat-3.9.c
index f81fe79..03f3af8 100644
--- a/backport/compat/compat-3.9.c
+++ b/backport/compat/compat-3.9.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2013  Luis R. Rodriguez <mcgrof@do-not-panic.com>
  *
- * Compatibility file for Linux wireless for kernels 3.9.
+ * Backport functionality introduced in Linux 3.9.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/backport/compat/user_namespace.c b/backport/compat/user_namespace.c
index 288efc0..6d01404 100644
--- a/backport/compat/user_namespace.c
+++ b/backport/compat/user_namespace.c
@@ -5,8 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Compatibility file for Linux wireless for kernels backporting
- * user_namespace.c
+ * Backport functionality introduced in Linux user_namespace.c
  */
 
 #include <linux/module.h>
-- 
1.7.10.4

