Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59081 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab2HFWg3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 18:36:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: add include/linux/olpc-ec.h
Date: Tue,  7 Aug 2012 00:36:21 +0200
Message-Id: <1344292581-25959-2-git-send-email-hauke@hauke-m.de> (sfid-20120807_003633_387041_35E9E7A2)
In-Reply-To: <1344292581-25959-1-git-send-email-hauke@hauke-m.de>
References: <1344292581-25959-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The libertas driver now needs this include file.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/olpc-ec.h |   10 ++++++++++
 1 file changed, 10 insertions(+)
 create mode 100644 include/linux/olpc-ec.h

diff --git a/include/linux/olpc-ec.h b/include/linux/olpc-ec.h
new file mode 100644
index 0000000..a5b932a
--- /dev/null
+++ b/include/linux/olpc-ec.h
@@ -0,0 +1,10 @@
+#ifndef _COMPAT_LINUX_OLPC_EC_H
+#define _COMPAT_LINUX_OLPC_EC_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0))
+#include_next <linux/olpc-ec.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(3,6,0)) */
+
+#endif	/* _COMPAT_LINUX_OLPC_EC_H */
-- 
1.7.9.5

