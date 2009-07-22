Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40893 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbZGVUh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 16:37:56 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] [compat-2.6] Add missing import.
Date: Wed, 22 Jul 2009 22:37:47 +0200
Message-Id: <1248295068-26942-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This import was missing in 3615cdf6a700ca02cd14118a7d84ed0065a6e1c1

It is not needed now, but it will be soon.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/compat/compat.h b/compat/compat.h
index c5ed4ff..05612b2 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -20,5 +20,6 @@
 #include <net/compat-2.6.29.h>
 #include <net/compat-2.6.30.h>
 #include <net/compat-2.6.31.h>
+#include <net/compat-2.6.32.h>
 
 #endif /* LINUX_26_COMPAT_H */
-- 
1.6.2.1

