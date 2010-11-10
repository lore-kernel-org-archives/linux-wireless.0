Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0KJCWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:22:07 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:22:06 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 44/44] compat/2.6.35: 2.6.35 does not define `SHRT_MIN'
Date: Tue,  9 Nov 2010 21:20:26 -0500
Message-Id: <1289355626-25373-45-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.35.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 32fd039..c1e5dea 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -11,7 +11,6 @@
 /* added on linux/kernel.h */
 #define USHRT_MAX      ((u16)(~0U))
 #define SHRT_MAX       ((s16)(USHRT_MAX>>1))
-#define SHRT_MIN       ((s16)(-SHRT_MAX - 1))
 
 #define  SDIO_BUS_ECSI		0x20	/* Enable continuous SPI interrupt */
 #define  SDIO_BUS_SCSI		0x40	/* Support continuous SPI interrupt */
-- 
1.7.2.30.gc37d7.dirty

