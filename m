Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48713 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbZKXC0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:26:17 -0500
Received: by mail-yx0-f187.google.com with SMTP id 17so5308557yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:26:23 -0800 (PST)
Message-ID: <4B0B440D.4030201@gmail.com>
Date: Mon, 23 Nov 2009 21:25:17 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 09/13] Add posix SHUT_RD/SHUT_WR/SHUT_RDWR macros
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added on commit 91cf45f0 by Trond Myklebust in include/linux/net.h.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 compat-2.6.24.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/compat-2.6.24.h b/compat-2.6.24.h
index d8f7c2c..68d33c7 100644
--- a/compat-2.6.24.h
+++ b/compat-2.6.24.h
@@ -10,6 +10,13 @@
 /* Added on 2.6.24 in include/linux/types.h by Al viro on commit
142956af */
 typedef unsigned long               uintptr_t;

+/* From include/linux/net.h */
+enum sock_shutdown_cmd {
+	SHUT_RD		= 0,
+	SHUT_WR		= 1,
+	SHUT_RDWR	= 2,
+};
+
 #if (LINUX_VERSION_CODE == KERNEL_VERSION(2,6,23)) /* Local check */
 /* Added as of 2.6.24 in include/linux/skbuff.h.
  *
-- 
1.6.3.3.385.g60647.dirty


