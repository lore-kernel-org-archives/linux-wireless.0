Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab0KJCUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:20:53 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:20:53 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 05/44] compat/2.6.19: fix comment
Date: Tue,  9 Nov 2010 21:19:47 -0500
Message-Id: <1289355626-25373-6-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.19.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/compat-2.6.19.h b/include/linux/compat-2.6.19.h
index 1e648c0..9bb1ace 100644
--- a/include/linux/compat-2.6.19.h
+++ b/include/linux/compat-2.6.19.h
@@ -19,6 +19,6 @@ compat_kmem_cache_destroy(struct kmem_cache *cachep)
 #endif
 }
 
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)) */
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19)) */
 
 #endif /* LINUX_26_19_COMPAT_H */
-- 
1.7.2.30.gc37d7.dirty

