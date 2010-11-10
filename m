Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36265 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab0KJCVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:13 -0500
Received: by qyk31 with SMTP id 31so159944qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:12 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 16/44] compat/2.6.29: don't include <linux/if_link.h> prior to 2.6.19
Date: Tue,  9 Nov 2010 21:19:58 -0500
Message-Id: <1289355626-25373-17-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.29.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index cce678f..ef40d00 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -3,7 +3,9 @@
 
 #include <linux/version.h>
 #include <linux/netdevice.h>
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19))
 #include <linux/if_link.h>
+#endif
 
 /*
  * I kow this looks odd.. but 2.6.32 added the netdev_tx_t
-- 
1.7.2.30.gc37d7.dirty

