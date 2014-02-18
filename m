Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f195.google.com ([209.85.192.195]:48209 "EHLO
	mail-pd0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaBRLeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 06:34:23 -0500
From: avi.kp.137@gmail.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Avinash kumar <avi.kp.137@gmail.com>
Subject: [PATCH 6/6] drivers:net:wireless:airo.c:checkpatch.pl cleanup
Date: Tue, 18 Feb 2014 17:04:10 +0530
Message-Id: <5303453d.82e6440a.29fb.6ba4@mx.google.com> (sfid-20140218_123426_281443_C7046774)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash kumar <avi.kp.137@gmail.com>

removed following warnings-
drivers/net/wireless/airo.c:39: WARNING: Use #include <linux/io.h> instead of <asm/io.h>
drivers/net/wireless/airo.c:48: WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>
---
 drivers/net/wireless/airo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index edf4b57..79c4a76 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -36,7 +36,7 @@
 #include <linux/bitops.h>
 #include <linux/scatterlist.h>
 #include <linux/crypto.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/unaligned.h>
 
 #include <linux/netdevice.h>
@@ -45,7 +45,7 @@
 #include <linux/if_arp.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
-- 
1.7.9.5

