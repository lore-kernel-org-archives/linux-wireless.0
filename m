Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36861 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbaGPVXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:33 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so6948875wib.4
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/21] staging: vt6656: remove DBG_PRT kernel messages macro and enums
Date: Wed, 16 Jul 2014 22:22:05 +0100
Message-Id: <1405545731-6082-15-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232400_792487_8A34CECC)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All dead code and nolonger used by driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index dbd5810..f08f7de 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -185,16 +185,6 @@
 /* USB registers */
 #define USB_REG4			0x604
 
-#define DBG_PRT(l, p, args...) { if (l <= msglevel) printk(p, ##args); }
-
-enum {
-	MSG_LEVEL_ERR = 0,            /* Errors causing abnormal operation */
-	MSG_LEVEL_NOTICE = 1,         /* Errors needing user notification */
-	MSG_LEVEL_INFO = 2,           /* Normal message. */
-	MSG_LEVEL_VERBOSE = 3,        /* Will report all trival errors. */
-	MSG_LEVEL_DEBUG = 4           /* Only for debug purpose. */
-};
-
 #define DEVICE_INIT_COLD	0x0 /* cold init */
 #define DEVICE_INIT_RESET	0x1 /* reset init or Dx to D0 power remain */
 #define DEVICE_INIT_DXPL	0x2 /* Dx to D0 power lost init */
-- 
2.0.1

