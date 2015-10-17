Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38044 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbbJQKdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 06:33:22 -0400
Received: by wicll6 with SMTP id ll6so41468533wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 03:33:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/9] staging: vt6655: device.h remove unsed headers.
Date: Sat, 17 Oct 2015 11:32:56 +0100
Message-Id: <1445077982-17832-3-git-send-email-tvboxspy@gmail.com> (sfid-20151017_123327_573475_BB497ED4)
In-Reply-To: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
References: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of these headers rate to old api that are no longer used
in driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 4b8573b..be6c42b 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -31,34 +31,12 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/mm.h>
-#include <linux/errno.h>
-#include <linux/ioport.h>
 #include <linux/pci.h>
-#include <linux/kernel.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
-#include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/string.h>
-#include <linux/wait.h>
-#include <linux/if_arp.h>
-#include <linux/sched.h>
-#include <linux/io.h>
-#include <linux/if.h>
 #include <linux/crc32.h>
-#include <linux/uaccess.h>
-#include <linux/proc_fs.h>
-#include <linux/inetdevice.h>
-#include <linux/reboot.h>
-#include <linux/ethtool.h>
-/* Include Wireless Extension definition and check version - Jean II */
 #include <net/mac80211.h>
-#include <linux/wireless.h>
-#include <net/iw_handler.h>	/* New driver API */
 
 /* device specific */
 
-- 
2.5.0

