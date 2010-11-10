Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0KJCVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:01 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:00 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 08/44] compat/2.6.20: add header's skeleton
Date: Tue,  9 Nov 2010 21:19:50 -0500
Message-Id: <1289355626-25373-9-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.20.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/compat-2.6.20.h

diff --git a/include/linux/compat-2.6.20.h b/include/linux/compat-2.6.20.h
new file mode 100644
index 0000000..bbfdacb
--- /dev/null
+++ b/include/linux/compat-2.6.20.h
@@ -0,0 +1,11 @@
+#ifndef LINUX_26_20_COMPAT_H
+#define LINUX_26_20_COMPAT_H
+
+#include <linux/version.h>
+
+/* Compat work for 2.6.20 */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)) */
+
+#endif /* LINUX_26_20_COMPAT_H */
-- 
1.7.2.30.gc37d7.dirty

