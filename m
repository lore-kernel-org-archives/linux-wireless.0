Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-2.httrack.com ([195.154.67.106]:48723 "EHLO
	smtp-2.httrack.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbE1Fkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 01:40:52 -0400
From: Xavier Roche <roche@httrack.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Trivial Patch Monkey <trivial@kernel.org>,
	Xavier Roche <roche@httrack.com>
Subject: [PATCH] rtl8723au: replaced asm/atomic.h by linux/atomic.h
Date: Thu, 28 May 2015 07:39:31 +0200
Message-Id: <1432791571-17262-1-git-send-email-roche@httrack.com> (sfid-20150528_074058_181322_39A9665C)
In-Reply-To: <1432744411-6635-1-git-send-email-roche@httrack.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minor additional checkpatch.pl fix for include/rtw_io.h

Signed-off-by: Xavier Roche <roche@httrack.com>
---
 drivers/staging/rtl8723au/include/rtw_io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/include/rtw_io.h b/drivers/staging/rtl8723au/include/rtw_io.h
index c8119e2..dfdf35a 100644
--- a/drivers/staging/rtl8723au/include/rtw_io.h
+++ b/drivers/staging/rtl8723au/include/rtw_io.h
@@ -24,7 +24,7 @@
 #include <linux/list.h>
 /* include <linux/smp_lock.h> */
 #include <linux/spinlock.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 
 #include <linux/usb.h>
 #include <linux/usb/ch9.h>
-- 
1.9.1

