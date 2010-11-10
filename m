Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab0KJCVC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:02 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:02 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 09/44] compat/2.6.20: add compat macro for `struct delayed_work'
Date: Tue,  9 Nov 2010 21:19:51 -0500
Message-Id: <1289355626-25373-10-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.20.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.20.h b/include/linux/compat-2.6.20.h
index bbfdacb..c77e87e 100644
--- a/include/linux/compat-2.6.20.h
+++ b/include/linux/compat-2.6.20.h
@@ -6,6 +6,9 @@
 /* Compat work for 2.6.20 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
 
+/* `struct work_struct' and `struct delayed_work' are field compatible */
+#define delayed_work work_struct
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)) */
 
 #endif /* LINUX_26_20_COMPAT_H */
-- 
1.7.2.30.gc37d7.dirty

