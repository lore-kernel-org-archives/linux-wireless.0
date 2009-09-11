Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49098 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbZIKOIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 10:08:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ssb: Disable verbose SDIO coreswitch
Date: Fri, 11 Sep 2009 16:08:06 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909111608.07077.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable SDIO coreswitch debugging.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/ssb/sdio.c
===================================================================
--- wireless-testing.orig/drivers/ssb/sdio.c	2009-09-08 19:29:16.000000000 +0200
+++ wireless-testing/drivers/ssb/sdio.c	2009-09-11 16:05:25.000000000 +0200
@@ -21,7 +21,7 @@
 #include "ssb_private.h"
 
 /* Define the following to 1 to enable a printk on each coreswitch. */
-#define SSB_VERBOSE_SDIOCORESWITCH_DEBUG		1
+#define SSB_VERBOSE_SDIOCORESWITCH_DEBUG		0
 
 
 /* Hardware invariants CIS tuples */

-- 
Greetings, Michael.
