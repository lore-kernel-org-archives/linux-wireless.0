Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54757 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZLAIjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 03:39:31 -0500
Received: by yxe17 with SMTP id 17so4395588yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 00:39:38 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: mcgrof@bombadil.infradead.org, linux-wireless@vger.kernel.org,
	Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 1/5] Add posix SHUT_RD/SHUT_WR/SHUT_RDWR macros
Date: Tue,  1 Dec 2009 03:38:17 -0500
Message-Id: <1259656701-12329-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <4B0B4405.4050605@gmail.com>
References: <4B0B4405.4050605@gmail.com>
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
 /* Added on 2.6.24 in include/linux/types.h by Al viro on commit 142956af */
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

