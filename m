Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36265 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab0KJCWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:22:02 -0500
Received: by mail-qy0-f181.google.com with SMTP id 31so159944qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:22:02 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 41/44] compat/2.6.29: fix typos
Date: Tue,  9 Nov 2010 21:20:23 -0500
Message-Id: <1289355626-25373-42-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.29.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index 0c20c9e..845a0d8 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -11,8 +11,8 @@
 #endif
 
 /*
- * I kow this looks odd.. but 2.6.32 added the netdev_tx_t
- * and we backport that there so inlcude that header first
+ * I know this looks odd.. but 2.6.32 added the netdev_tx_t
+ * and we backport that there so include that header first
  * as we need it for the netdev ops.
  */
 #include <linux/compat-2.6.32.h>
-- 
1.7.2.30.gc37d7.dirty

