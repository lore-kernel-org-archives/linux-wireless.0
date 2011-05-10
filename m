Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53229 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab1EJLKk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 07:10:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: add missing include
Date: Tue, 10 May 2011 13:10:14 +0200
Message-Id: <1305025816-12538-1-git-send-email-hauke@hauke-m.de> (sfid-20110510_131044_191151_ED8418ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-By: George Nychis <gnychis@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.37.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index 8698e1d..a62b13f 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -12,6 +12,7 @@
 #include <linux/netdevice.h>
 #include <net/sock.h>
 #include <linux/nsproxy.h>
+#include <linux/vmalloc.h>
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35)
 static const void *net_current_ns(void)
-- 
1.7.4.1

