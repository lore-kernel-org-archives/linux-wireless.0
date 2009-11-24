Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:46358 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbZKXCY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:24:58 -0500
Received: by gxk4 with SMTP id 4so12982314gxk.8
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:25:04 -0800 (PST)
Message-ID: <4B0B43BF.9000708@gmail.com>
Date: Mon, 23 Nov 2009 21:23:59 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 02/13] Add typedef for `gfp_t'
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added on commit dd0fc66f by Al Viro in include/linux/types.h.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 compat-2.6.14.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/compat-2.6.14.h b/compat-2.6.14.h
index ec12941..22e7e31 100644
--- a/compat-2.6.14.h
+++ b/compat-2.6.14.h
@@ -7,6 +7,8 @@
 /* Compat work for 2.6.14 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14))

+typedef unsigned int gfp_t;
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)) */

 #endif /* LINUX_26_14_COMPAT_H */
-- 
1.6.3.3.385.g60647.dirty


