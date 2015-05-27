Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-2.httrack.com ([195.154.67.106]:40518 "EHLO
	smtp-2.httrack.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbbE0Qwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 12:52:43 -0400
From: Xavier Roche <roche@httrack.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Trivial Patch Monkey <trivial@kernel.org>,
	Xavier Roche <roche@httrack.com>
Subject: [PATCH] Replaced #include <asm/(uaccess|atomic|io).h> by #include <linux/(uaccess|atomic|io).h>
Date: Wed, 27 May 2015 18:33:31 +0200
Message-Id: <1432744411-6635-1-git-send-email-roche@httrack.com> (sfid-20150527_185304_901291_F63CEB3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minor checkpatch.pl fix (staging tree -- also validated on linux-next)

Signed-off-by: Xavier Roche <roche@httrack.com>
---
 drivers/staging/rtl8723au/include/osdep_service.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/osdep_service.h b/drivers/staging/rtl8723au/include/osdep_service.h
index dedb418..98250b1 100644
--- a/drivers/staging/rtl8723au/include/osdep_service.h
+++ b/drivers/staging/rtl8723au/include/osdep_service.h
@@ -29,10 +29,10 @@
 #include <linux/kref.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/byteorder.h>
-#include <asm/atomic.h>
-#include <asm/io.h>
+#include <linux/atomic.h>
+#include <linux/io.h>
 #include <linux/semaphore.h>
 #include <linux/sem.h>
 #include <linux/sched.h>
-- 
1.9.1

