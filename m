Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47672 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab0KJCVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:53 -0500
Received: by mail-qy0-f174.google.com with SMTP id 12so2500227qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:52 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 35/44] compat/2.6.26: {U,}SHORT_MAX/SHORT_MIN have been deprecated
Date: Tue,  9 Nov 2010 21:20:17 -0500
Message-Id: <1289355626-25373-36-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.26.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/compat-2.6.26.h b/include/linux/compat-2.6.26.h
index 30ee46c..38e1d8d 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -39,11 +39,6 @@
 #define SW_RFKILL_ALL           0x03  /* rfkill master switch, type "any"
 					 set = radio enabled */
 
-/* From kernel.h */
-#define USHORT_MAX      ((u16)(~0U))
-#define SHORT_MAX       ((s16)(USHORT_MAX>>1))
-#define SHORT_MIN       (-SHORT_MAX - 1)
-
 extern int dev_set_name(struct device *dev, const char *name, ...)
 			__attribute__((format(printf, 2, 3)));
 
-- 
1.7.2.30.gc37d7.dirty

