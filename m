Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50117 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaKEVJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:51 -0500
Received: by mail-wg0-f47.google.com with SMTP id a1so1910293wgh.20
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:50 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/11] staging: vt6655: device.h remove dead member wstats
Date: Wed,  5 Nov 2014 21:08:58 +0000
Message-Id: <1415221739-3045-10-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220955_746796_FC53FAD5)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 74d2afb..1393210 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -440,8 +440,6 @@ struct vnt_private {
 	unsigned char abyEEPROM[EEP_MAX_CONTEXT_SIZE]; /* unsigned long alignment */
 
 	unsigned short wBeaconInterval;
-
-	struct iw_statistics	wstats;		/* wireless stats */
 };
 
 static inline PDEVICE_RD_INFO alloc_rd_info(void)
-- 
2.1.0

