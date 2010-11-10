Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47672 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0KJCUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:20:50 -0500
Received: by qyk12 with SMTP id 12so2500227qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:20:49 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 02/44] compat/2.6.17: add compat macro for `NET_SKB_PAD'
Date: Tue,  9 Nov 2010 21:19:44 -0500
Message-Id: <1289355626-25373-3-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.17.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.17.h b/include/linux/compat-2.6.17.h
index 36d9fb2..b7c9473 100644
--- a/include/linux/compat-2.6.17.h
+++ b/include/linux/compat-2.6.17.h
@@ -6,6 +6,8 @@
 /* Compat work for 2.6.17 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,17))
 
+#define NET_SKB_PAD	16
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,17)) */
 
 #endif /* LINUX_26_17_COMPAT_H */
-- 
1.7.2.30.gc37d7.dirty

